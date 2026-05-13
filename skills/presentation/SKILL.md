---
name: presentation
description: Create presentations from text/outline using Marp (Markdown to slides). Use when user asks to create presentation, slides, pitch deck. Triggers on "презентация", "слайды", "presentation", "pitch deck", "сделай презентацию".
---

# Presentation Creator

Create professional presentations from text or outline using Marp CLI.

## Output Formats

- **PDF** — универсальный, для печати и шаринга
- **PPTX** — PowerPoint, можно редактировать
- **HTML** — интерактивные слайды в браузере

## Workflow

### Step 1: Create Markdown slides

Create `.md` file with Marp syntax:

```markdown
---
marp: true
theme: default
paginate: true
---

# Заголовок презентации

Подзаголовок или автор

---

## Слайд 2

- Пункт 1
- Пункт 2
- Пункт 3

---

## Слайд с изображением

![bg right:40%](path/to/image.jpg)

Текст слева от картинки

---

## Код

```python
print("Hello, World!")
```

---

# Спасибо за внимание!

Контакты: example@email.com
```

### Step 2: Export to desired format

```bash
# PDF (default, best quality)
marp presentation.md -o ~/Desktop/presentation.pdf

# PowerPoint
marp presentation.md -o ~/Desktop/presentation.pptx

# HTML (single file)
marp presentation.md -o ~/Desktop/presentation.html
```

## Marp Syntax Quick Reference

### Slide separator
```
---
```

### Background images
```markdown
![bg](path/to/image.jpg)           # full background
![bg left](path/to/image.jpg)      # left split
![bg right:40%](path/to/image.jpg) # right 40%
![bg contain](path/to/image.jpg)   # fit inside
![bg cover](path/to/image.jpg)     # cover (crop)
```

### Text styling
```markdown
**bold** *italic* ~~strikethrough~~
`inline code`
```

### Themes
Available: `default`, `gaia`, `uncover`

Set in frontmatter:
```yaml
---
marp: true
theme: gaia
class: lead
---
```

### Colors & classes
```markdown
<!-- _class: lead -->      # centered title slide
<!-- _backgroundColor: #123 -->
<!-- _color: white -->
```

## Script Usage

```bash
# Create presentation
{baseDir}/scripts/create-presentation.sh "Title" "outline.txt" ~/Desktop/output.pdf

# Or manually
marp slides.md -o output.pdf --allow-local-files
```

## Tips

- Keep slides minimal: 1 idea per slide
- Use images for visual impact
- Max 6 bullet points per slide
- Large fonts (Marp defaults are good)
- For PDF: `--pdf-notes` includes speaker notes
