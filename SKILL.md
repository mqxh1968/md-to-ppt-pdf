---
name: md-to-ppt-pdf
description: 将 Markdown 报告转换为精美 PPTX 和 PDF。基于 html-ppt-skill 设计理念：Token 驱动设计系统 + Navy Gold 主题配色。触发词：MD转PPT、报告转PPT、生成PPT、生成PDF、报告转PDF。适用场景：研究报告、行业报告、投资分析报告等需要精美排版的场景。
agent_created: true
---

# MD → PPT + PDF 精美转换管线

将 Markdown 研究报告转换为：
- **PPTX**：基于 html-ppt-skill 设计理念的 python-pptx 模板引擎，Navy + Gold Corporate Pitch 风格
- **PDF**：sn-md-to-html-report → CSS 增强注入 → Edge headless CLI 打印

## 完整流程（按顺序执行）

### Step 1: 生成 PPTX

使用 `scripts/generate_ppt.py` 生成幻灯片。该脚本现为示例模板，实际使用时需要根据报告内容定制页面。

通用流程：
```bash
python scripts/generate_ppt.py
```

如果需要为特定报告定制 PPT，基于 DesignTokens 系统编写新的 slide 函数：
- 配色：T.COLOR_PRIMARY (Navy #0D2137), T.COLOR_SECONDARY (Gold #D4AF37), T.COLOR_ACCENT (Teal #2E86AB)
- 布局模式：封面(slide_cover)、目录(slide_toc)、三栏卡片(slide_3_conclusions)、表格(slide_market_size)、双栏对比(slide_competitive)、三层漏斗(slide_monetization)、四卡(slide_differentiation)、时间线(slide_90day_plan)、风险表(slide_risk)、CTA(slide_mvp)、致谢(slide_thanks)

### Step 2: 生成 HTML

```bash
python <sn-md-to-html-report-path>/scripts/render_report.py <report.md> <output.html> --with-js --mermaid-source cdn --title-style comfortable
```

`sn-md-to-html-report` 路径：`~/.workbuddy/skills/sn-md-to-html-report/scripts/render_report.py`

### Step 3: CSS 增强注入

```bash
python scripts/inject_css.py <output.html>
```

注入 Navy + Gold 设计 Token：表格斑马纹、h2 金边竖线、blockquote 金边、标题 Navy 配色。

### Step 4: HTML → PDF（Edge headless CLI）

Windows 上使用 Edge 无头模式（替代 playwright）：
```bash
msedge --headless --disable-gpu \
  --print-to-pdf=<output.pdf> \
  --no-pdf-header-footer \
  <file:///absolute/path/to/report.html>
```

Edge 路径（Windows）：`C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe`

## DesignTokens 参考

| Token | 颜色 | 用途 |
|-------|------|------|
| PRIMARY | #0D2137 | 标题、卡片头、深色背景 |
| SECONDARY | #D4AF37 | 强调色、分割线、高亮 |
| ACCENT | #2E86AB | 链接、三级标题、数据 |
| BG_LIGHT | #F5F3EE | 页面背景 |
| CARD_BG | #FFFFFF | 卡片背景 |
| TEXT_DARK | #1A1A2E | 正文 |
| TEXT_MUTED | #6B7280 | 辅助文字 |

## 已知限制

- python-pptx 的 RGBColor 只支持 RGB 三参数，不支持 alpha 透明度
- Edge headless 在 Windows 上对中文字体渲染依赖系统字体
- `--title-style` 仅支持 `comfortable` 选项
