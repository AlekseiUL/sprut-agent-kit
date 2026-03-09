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


