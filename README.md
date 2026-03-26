# SPRUT Agent Kit ⚡

**Ready-to-go AI agent with "soul" for ClaudeClaw**

One command - and you have a configured personal assistant with memory, 25 skills, and automation.

## What is this?

Starter kit for [ClaudeClaw](https://github.com/moazbuilds/claudeclaw) - a ready-made agent configuration with:
- **Soul** (SOUL.md + AGENTS.md) - identity, principles, work rules
- **Memory** (SQLite + embeddings) - vector search + FTS5, decay system
- **25 ready-made skills** - research, debugging, brainstorming, YouTube, website audit, etc.
- **Crons** - automated tasks (backup, health check, memory cleanup)
- **Progress system** - technical messages in Telegram
- **Security layer** - personal data protection

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/sprut-agent-kit.git
cd sprut-agent-kit
./install.sh
```

The script will:
1. Check dependencies (bun, git, claude)
2. Install ClaudeClaw (if not already installed)
3. Configure settings (asks for Telegram ID, timezone)
4. Install agent soul (SOUL.md, AGENTS.md)
5. Install 25 skills
6. Optionally: import memory, set up autostart

## Repository Structure

```
sprut-agent-kit/
├── install.sh              # ClaudeClaw installation + setup
├── claudeclaw.json         # Config (owner, models, memory, skills, crons)
├── SOUL.md                 # Agent soul (identity, principles)
├── AGENTS.md               # Work rules (memory, security, skills)
├── CLAUDE.md.example       # Personalization template
├── skills/                 # 25 ready-made skills
│   ├── weather/            # Weather and forecasts
│   ├── deep-research-pro/  # Deep research (web search)
│   ├── systematic-debugging/ # Debugging and diagnostics
│   ├── brainstorming/      # Brainstorming
│   ├── writing-plans/      # Step-by-step plans
│   ├── subagent-runner/    # Parallel subagents
│   ├── subagent-coordinator/ # Multi-subagent coordination
│   ├── agent-builder/      # Persistent agent creator
│   ├── audit-website/      # Website audit (SEO, UX, security)
│   ├── presentation/       # Presentation creation (Marp)
│   ├── excalidraw/         # Diagrams and schemes
│   ├── tubescribe/         # YouTube video → text + audio
│   ├── tweet-writer/       # Tweet writing
│   ├── social-card-gen/    # Social media posts
│   ├── reddit/             # Reddit operations
│   └── last30days/         # 30-day trend research
└── README.md
```

## Configuration

**Main config:** `~/.claude/claudeclaw/settings.json`

```json
{
  "model": "claude-opus-4-6",
  "telegram": {
    "token": "YOUR_BOT_TOKEN",
    "allowedUserIds": [YOUR_TELEGRAM_ID]
  },
  "web": {
    "enabled": true,
    "port": 4632
  },
  "memory": {
    "enabled": true,
    "maxResults": 5,
    "vectorWeight": 0.7,
    "textWeight": 0.3
  }
}
```

**Full config:** `claudeclaw.json` (documentation of all settings)

## Skills

25 ready-made skills out of the box:

| Skill | Description |
|-------|-------------|
| weather | Weather and forecasts (wttr.in, Open-Meteo) |
| deep-research-pro | Deep research with citations (DuckDuckGo) |
| systematic-debugging | Step-by-step debugging of any problems |
| brainstorming | Structured brainstorming |
| writing-plans | Step-by-step implementation plans |
| subagent-runner | Launch and manage subagents |
| subagent-coordinator | Coordinate parallel subagents |
| agent-builder | Create persistent skill-agents |
| audit-website | SEO, UX, website security |
| presentation | Presentations via Marp (Markdown → slides) |
| excalidraw | Diagrams for Obsidian |
| tubescribe | YouTube video → text + audio |
| tweet-writer | Viral tweets and threads |
| social-card-gen | Posts for different social networks |
| reddit | Search and work with Reddit |
| last30days | Research trends from the last 30 days |

Installing a new skill:
```bash
cp -r skill-name ~/.claude/skills/
```

## "Portable Soul" Architecture

ClaudeClaw is designed for cross-platform transfer:

1. **SOUL.md** - agent identity (who I am, what I believe, how I act)
2. **AGENTS.md** - work rules (memory, security, skills)
3. **claudeclaw.json** - full configuration (models, paths, crons)
4. **Skills** - specialized agents with data files
5. **Memory** - import/export facts between agents

Installing on a new Mac = `./install.sh` + config setup

## Memory

**SQLite + embeddings (automatically from main provider)**

- Hybrid search: vector (0.7) + FTS5 (0.3)
- Decay system: semantic -0.01/day, episodic -0.05/day
- Auto-extract: automatic fact extraction from dialogues
- Import/export: memory migration between agents

## Daemon & Web UI

**REST API:**
- `POST /api/subagent/run` - run subagent
- `GET /api/subagent/status/:id` - status
- `GET /api/subagent/wait/:id` - wait for result

**Web UI:** http://localhost:4632

**Launch:**
```bash
bun run src/index.ts start --web
```

## Telegram Integration

**Progress messages:**
```bash
bun commands/progress.ts "⚙️" "Creating file"
```

Emojis: ⚙️ (action), 🔍 (search), 🤖 (subagent), 📦 (installation), ✅ (done), ❌ (error)

## Security

- Never store personal data (passports, cards, addresses)
- Communication only with owner (Telegram ID whitelist)
- Don't touch main agent files without explicit request
- Security levels: locked / strict / moderate / unrestricted

## Philosophy

ClaudeClaw is an experiment in "portable agent soul":
1. AI agent = code + config + identity (soul)
2. Soul can be described in text files
3. Installing an agent = copying soul + running code
4. Two agents with one soul = redundancy without identity loss

## Contributing

1. Fork the repository
2. Feature branch (`git checkout -b feature/new-skill`)
3. Commit and Push
4. Pull Request

---

# SPRUT Agent Kit ⚡

**Готовый AI-агент с "душой" для ClaudeClaw**

Одна команда - и у вас настроенный персональный ассистент с памятью, 25 skills и автоматикой.

## Что это?

Starter kit для [ClaudeClaw](https://github.com/moazbuilds/claudeclaw) - готовая конфигурация агента с:
- **Душой** (SOUL.md + AGENTS.md) - идентичность, принципы, правила работы
- **Памятью** (SQLite + embeddings) - векторный поиск + FTS5, decay система
- **25 готовых skills** - ресёрч, debugging, brainstorming, YouTube, аудит сайтов и т.д.
- **Crons** - автоматические задачи (backup, health check, memory cleanup)
- **Progress-система** - технические сообщения в Telegram
- **Security layer** - защита личных данных

## Быстрый старт

```bash
git clone https://github.com/YOUR_USERNAME/sprut-agent-kit.git
cd sprut-agent-kit
./install.sh
```

Скрипт:
1. Проверит зависимости (bun, git, claude)
2. Установит ClaudeClaw (если ещё не стоит)
3. Настроит конфиг (спросит Telegram ID, timezone)
4. Установит душу агента (SOUL.md, AGENTS.md)
5. Установит 25 skills
6. Опционально: импортирует память, настроит автозапуск

## Структура репозитория

```
sprut-agent-kit/
├── install.sh              # Установка ClaudeClaw + надстройка
├── claudeclaw.json         # Конфиг (owner, models, memory, skills, crons)
├── SOUL.md                 # Душа агента (идентичность, принципы)
├── AGENTS.md               # Правила работы (память, безопасность, skills)
├── CLAUDE.md.example       # Шаблон персонализации
├── skills/                 # 25 готовых skills
│   ├── weather/            # Погода и прогнозы
│   ├── deep-research-pro/  # Глубокое исследование (web search)
│   ├── systematic-debugging/ # Отладка и диагностика
│   ├── brainstorming/      # Мозговой штурм
│   ├── writing-plans/      # Пошаговые планы
│   ├── subagent-runner/    # Параллельные субагенты
│   ├── subagent-coordinator/ # Координация нескольких субагентов
│   ├── agent-builder/      # Создатель persistent агентов
│   ├── audit-website/      # Аудит сайтов (SEO, UX, безопасность)
│   ├── presentation/       # Создание презентаций (Marp)
│   ├── excalidraw/         # Схемы и диаграммы
│   ├── tubescribe/         # YouTube видео → текст + аудио
│   ├── tweet-writer/       # Написание твитов
│   ├── social-card-gen/    # Посты для соцсетей
│   ├── reddit/             # Работа с Reddit
│   └── last30days/         # Исследование трендов за 30 дней
└── README.md
```

## Конфигурация

**Основной конфиг:** `~/.claude/claudeclaw/settings.json`

```json
{
  "model": "claude-opus-4-6",
  "telegram": {
    "token": "YOUR_BOT_TOKEN",
    "allowedUserIds": [YOUR_TELEGRAM_ID]
  },
  "web": {
    "enabled": true,
    "port": 4632
  },
  "memory": {
    "enabled": true,
    "maxResults": 5,
    "vectorWeight": 0.7,
    "textWeight": 0.3
  }
}
```

**Полный конфиг:** `claudeclaw.json` (документация всех настроек)

## Skills

25 готовых skills из коробки:

| Skill | Описание |
|-------|----------|
| weather | Погода и прогнозы (wttr.in, Open-Meteo) |
| deep-research-pro | Глубокое исследование с цитатами (DuckDuckGo) |
| systematic-debugging | Пошаговая отладка любых проблем |
| brainstorming | Структурированный мозговой штурм |
| writing-plans | Пошаговые планы реализации |
| subagent-runner | Запуск и управление субагентами |
| subagent-coordinator | Координация параллельных субагентов |
| agent-builder | Создание persistent skill-агентов |
| audit-website | SEO, UX, безопасность сайтов |
| presentation | Презентации через Marp (Markdown → слайды) |
| excalidraw | Схемы и диаграммы для Obsidian |
| tubescribe | YouTube видео → текст + аудио |
| tweet-writer | Вирусные твиты и треды |
| social-card-gen | Посты для разных соцсетей |
| reddit | Поиск и работа с Reddit |
| last30days | Исследование трендов за последние 30 дней |

Установка нового skill:
```bash
cp -r skill-name ~/.claude/skills/
```

## Архитектура "Переносимой души"

ClaudeClaw спроектирован для переноса между платформами:

1. **SOUL.md** - идентичность агента (кто я, во что верю, как действую)
2. **AGENTS.md** - рабочие правила (память, безопасность, skills)
3. **claudeclaw.json** - полная конфигурация (модели, пути, crons)
4. **Skills** - специализированные агенты с data-файлами
5. **Memory** - экспорт/импорт фактов между агентами

Установка на новый Mac = `./install.sh` + настройка конфига

## Память

**SQLite + embeddings (автоматически от основного провайдера)**

- Hybrid search: векторный (0.7) + FTS5 (0.3)
- Decay система: semantic -0.01/день, episodic -0.05/день
- Auto-extract: автоматическое извлечение фактов из диалогов
- Import/export: миграция памяти между агентами

## Daemon & Web UI

**REST API:**
- `POST /api/subagent/run` - запуск субагента
- `GET /api/subagent/status/:id` - статус
- `GET /api/subagent/wait/:id` - ждать результат

**Web UI:** http://localhost:4632

**Запуск:**
```bash
bun run src/index.ts start --web
```

## Telegram интеграция

**Progress сообщения:**
```bash
bun commands/progress.ts "⚙️" "Создаю файл"
```

Эмодзи: ⚙️ (действие), 🔍 (поиск), 🤖 (субагент), 📦 (установка), ✅ (готово), ❌ (ошибка)

## Безопасность

- Никогда не хранить личные данные (паспорта, карты, адреса)
- Общение только с владельцем (Telegram ID whitelist)
- Не трогать файлы основного агента без явного запроса
- Security levels: locked / strict / moderate / unrestricted

## Философия

ClaudeClaw - эксперимент "переносимой души агента":
1. AI-агент = код + конфиг + идентичность (душа)
2. Душу можно описать в текстовых файлах
3. Установка агента = копирование души + запуск кода
4. Два агента с одной душой = резервирование без потери идентичности

## Contributing

1. Fork репозитория
2. Feature branch (`git checkout -b feature/new-skill`)
3. Commit и Push
4. Pull Request

---

## Resources | Ресурсы

- 📺 YouTube: [youtube.com/@alekseiulianov](https://youtube.com/@alekseiulianov)
- 📱 Telegram: [t.me/Sprut_AI](https://t.me/Sprut_AI)
- 🔥 AI ОПЕРАЦИОНКА (Premium): [Подписка](https://t.me/tribute/app?startapp=sJyg) — продвинутые материалы, скиллы, агенты, поддержка
- 💻 GitHub: [github.com/AlekseiUL](https://github.com/AlekseiUL)

## License

MIT

---

*A portable AI agent soul experiment by Aleksei Ulianov | Эксперимент переносимой души AI-агента от Алексея Ульянова*
