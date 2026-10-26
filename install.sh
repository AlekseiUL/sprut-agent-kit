#!/usr/bin/env bash
set -euo pipefail

# SPRUT Agent Kit Installation Script
# Установка ClaudeClaw + надстройка одной командой

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

log_info() {
  echo -e "${GREEN}✓${RESET} $1"
}

log_warn() {
  echo -e "${YELLOW}⚠${RESET} $1"
}

log_error() {
  echo -e "${RED}✗${RESET} $1"
}

log_header() {
  echo -e "\n${BOLD}$1${RESET}"
}

check_requirements() {
  log_header "Проверка зависимостей"

  if ! command -v bun &> /dev/null; then
    log_error "Bun не установлен."
    read -p "Установить Bun сейчас? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      curl -fsSL https://bun.sh/install | bash
      source ~/.bashrc 2>/dev/null || source ~/.zshrc 2>/dev/null || true
    else
      log_error "Bun необходим для работы. Прерываем установку."
      exit 1
    fi
  fi
  log_info "Bun: $(bun --version)"

  if ! command -v sqlite3 &> /dev/null; then
    log_warn "SQLite3 не установлен (опционально для отладки памяти)"
  else
    log_info "SQLite3: $(sqlite3 --version | cut -d' ' -f1)"
  fi

  if ! command -v git &> /dev/null; then
    log_error "Git не установлен"
    exit 1
  fi
  log_info "Git: $(git --version | cut -d' ' -f3)"

  if ! command -v claude &> /dev/null; then
    log_error "Claude Code не установлен. Установите: https://claude.ai/download"
    exit 1
  fi
  log_info "Claude Code: установлен"
}

install_claudeclaw() {
  log_header "Установка ClaudeClaw"

  # Проверяем установлен ли ClaudeClaw
  if claude plugin list 2>/dev/null | grep -q "claudeclaw"; then
    log_info "ClaudeClaw уже установлен"
    return
  fi

  log_info "Устанавливаем ClaudeClaw из marketplace..."

  # Добавляем marketplace плагин
  if ! claude plugin marketplace add moazbuilds/claudeclaw 2>/dev/null; then
    log_warn "Не удалось добавить из marketplace, пробуем альтернативный метод..."
  fi

  # Устанавливаем плагин
  if claude plugin install claudeclaw 2>/dev/null; then
    log_info "ClaudeClaw установлен"
  else
    log_error "Не удалось установить ClaudeClaw автоматически"
    log_info "Установите вручную: claude plugin install claudeclaw"
    exit 1
  fi
}

setup_config() {
  log_header "Настройка конфигурации"

  local config_file="$HOME/.claude/claudeclaw/settings.json"
  mkdir -p "$(dirname "$config_file")"

  if [ -f "$config_file" ]; then
    log_warn "Конфиг уже существует: $config_file"
    return
  fi

  log_info "Создаём базовый конфиг..."

  # Запрашиваем Telegram ID
  read -p "Введите ваш Telegram ID (или оставьте пустым): " telegram_id
  telegram_id=${telegram_id:-0}

  # Запрашиваем timezone
  read -p "Введите timezone (например Asia/Tbilisi, или UTC): " timezone
  timezone=${timezone:-UTC}

  cat > "$config_file" <<EOF
{
  "model": "claude-opus-4-6",
  "api": "anthropic",
  "fallback": {
    "model": "claude-sonnet-4-5-20250929",
    "api": "anthropic"
  },
  "timezone": "$timezone",
  "timezoneOffsetMinutes": 0,
  "heartbeat": {
    "enabled": false,
    "interval": 15,
    "prompt": "",
    "excludeWindows": []
  },
  "telegram": {
    "token": "",
    "allowedUserIds": [$telegram_id]
  },
  "security": {
    "level": "moderate",
    "allowedTools": [],
    "disallowedTools": []
  },
  "web": {
    "enabled": true,
    "host": "127.0.0.1",
    "port": 4632
  },
  "memory": {
    "enabled": true,
    "openaiApiKeyPath": "~/.env",
    "maxResults": 5,
    "vectorWeight": 0.7,
    "textWeight": 0.3,
    "decayRate": 0.02,
    "autoExtract": true
  }
}
EOF

  log_info "Конфиг создан: $config_file"
}

import_soul() {
  log_header "Импорт души агента"

  local soul_dest="$HOME/sprut-agent-kit"
  mkdir -p "$soul_dest"

  if [ -f "$(pwd)/SOUL.md" ] && [ -f "$(pwd)/AGENTS.md" ]; then
    for file in SOUL.md AGENTS.md; do
      if [ ! -e "$soul_dest/$file" ] && [ ! -L "$soul_dest/$file" ]; then
        cp "$(pwd)/$file" "$soul_dest/$file"
      fi
    done
    log_info "SOUL.md и AGENTS.md скопированы в $soul_dest"
  else
    log_warn "Файлы SOUL.md или AGENTS.md не найдены"
  fi

  if [ -f "$(pwd)/claudeclaw.json" ]; then
    if [ ! -e "$soul_dest/claudeclaw.json" ] && [ ! -L "$soul_dest/claudeclaw.json" ]; then
      cp "$(pwd)/claudeclaw.json" "$soul_dest/"
    fi
    log_info "claudeclaw.json скопирован"
  fi
}

import_memory() {
  log_header "Импорт памяти (опционально)"

  read -p "Путь к .md файлам памяти (или Enter для пропуска): " memory_path

  if [ -z "$memory_path" ]; then
    log_info "Пропускаем импорт памяти"
    log_info "Память будет накапливаться автоматически при использовании"
    return
  fi

  memory_path="${memory_path/#\~/$HOME}"

  if [ ! -d "$memory_path" ] && [ ! -f "$memory_path" ]; then
    log_warn "Путь не найден: $memory_path"
    log_info "Пропускаем импорт. Память будет накапливаться автоматически"
    return
  fi

  local memory_dir="$HOME/.claude/plugins/cache/claudeclaw/claudeclaw/1.0.0/.claude/claudeclaw"
  mkdir -p "$memory_dir"

  # Копируем .md файлы как источник для будущего импорта
  local count=0
  if [ -d "$memory_path" ]; then
    for f in "$memory_path"/*.md; do
      [ -f "$f" ] || continue
      [ ! -e "$memory_dir/imported-$(basename "$f")" ] || continue
      cp "$f" "$memory_dir/imported-$(basename "$f")"
      count=$((count + 1))
    done
  elif [ -f "$memory_path" ]; then
    [ ! -e "$memory_dir/imported-$(basename "$memory_path")" ] || return 0
    cp "$memory_path" "$memory_dir/imported-$(basename "$memory_path")"
    count=1
  fi

  if [ $count -gt 0 ]; then
    log_info "Скопировано $count файлов памяти в $memory_dir"
    log_info "ClaudeClaw обработает их при первом запуске"
  else
    log_warn "Файлы .md не найдены в $memory_path"
  fi
}

install_skills() {
  log_header "Установка skills"

  local skills_dir="$HOME/.claude/skills"
  local repo_skills="$(pwd)/skills"

  if [ ! -d "$repo_skills" ]; then
    log_warn "Директория skills не найдена в репозитории"
    return
  fi

  local available=$(ls -d "$repo_skills"/*/ 2>/dev/null | wc -l | tr -d ' ')
  echo "Доступно skills: $available"
  echo ""
  ls -1 "$repo_skills" 2>/dev/null | while read skill; do
    echo "  - $skill"
  done
  echo ""

  read -p "Установить все $available skills? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Пропускаем установку skills"
    log_info "Можете установить позже вручную: cp -r skills/* ~/.claude/skills/"
    return
  fi

  mkdir -p "$skills_dir"

  local count=0
  for skill_dir in "$repo_skills"/*/; do
    local skill_name=$(basename "$skill_dir")
    if [ -d "$skills_dir/$skill_name" ]; then
      log_warn "Skill $skill_name уже существует, пропускаем"
    else
      cp -r "$skill_dir" "$skills_dir/"
      count=$((count + 1))
    fi
  done

  log_info "Установлено $count skills в $skills_dir"
}

setup_daemon() {
  log_header "Настройка daemon (опционально)"

  read -p "Настроить автозапуск daemon через launchd? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Пропускаем настройку daemon"
    return
  fi

  local plist_file="$HOME/Library/LaunchAgents/com.claudeclaw.daemon.plist"
  local plugin_dir="$HOME/.claude/plugins/cache/claudeclaw/claudeclaw/1.0.0"

  cat > "$plist_file" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.claudeclaw.daemon</string>
  <key>ProgramArguments</key>
  <array>
    <string>$HOME/.bun/bin/bun</string>
    <string>run</string>
    <string>$plugin_dir/src/index.ts</string>
    <string>start</string>
    <string>--web</string>
    <string>--replace-existing</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$HOME/.claudeclaw/logs/daemon.log</string>
  <key>StandardErrorPath</key>
  <string>$HOME/.claudeclaw/logs/daemon.error.log</string>
</dict>
</plist>
EOF

  mkdir -p "$HOME/.claudeclaw/logs"

  launchctl unload "$plist_file" 2>/dev/null || true
  launchctl load "$plist_file"

  log_info "Daemon настроен и запущен"
  log_info "Логи: $HOME/.claudeclaw/logs/"
  log_info "Web UI: http://localhost:4632"
}

print_summary() {
  log_header "Установка завершена ⚡"

  echo ""
  echo "Что дальше:"
  echo ""
  echo "1. Отредактируйте конфиг: ~/.claude/claudeclaw/settings.json"
  echo "   - Добавьте Telegram bot token (если нужен)"
  echo "   - Настройте timezone и allowedUserIds"
  echo ""
  echo "2. Проверьте душу агента: ~/sprut-agent-kit/SOUL.md"
  echo "   - Адаптируйте под себя"
  echo ""
  echo "3. Запустите daemon:"
  echo "   cd ~/.claude/plugins/cache/claudeclaw/claudeclaw/1.0.0"
  echo "   bun run src/index.ts start --web"
  echo ""
  echo "4. Откройте Web UI: http://localhost:4632"
  echo ""
  echo "Документация: https://github.com/YOUR_USERNAME/sprut-agent-kit"
  echo ""
}

main() {
  echo -e "${BOLD}SPRUT Agent Kit Installation ⚡${RESET}"
  echo "ClaudeClaw + готовая конфигурация"
  echo ""

  check_requirements
  install_claudeclaw
  setup_config
  import_soul
  import_memory
  install_skills
  setup_daemon
  print_summary
}

main
