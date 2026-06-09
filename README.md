# md-to-ppt-pdf — Markdown 报告一键转精美 PPT + PDF

基于 **html-ppt-skill** 设计理念（Token 驱动设计系统 + 36主题配色库 + 31布局模板），自建的跨平台报告转换工具链。

## 特性

- **纯 Python**，零外部服务依赖，离线可用
- **Token 驱动设计**：Navy Blue + Gold 主题，修改一行变量即可换皮
- **PPTX 精美排版**：卡片布局、时间线、漏斗图、数据表格
- **PDF 专业输出**：CSS 增强注入（斑马纹表格、金边 blockquote、h2 金竖线）
- **跨智能体可用**：脚本自包含，改名 SKILL.md 指令层即可接入任意 AI 编程助手

## 快速开始

### 安装依赖

```bash
pip install python-pptx
```

### 三条命令出成品

```bash
# 1. MD → PPTX（需按内容定制 slide 函数）
python scripts/generate_ppt.py

# 2. MD → HTML → CSS 增强
pandoc report.md -o report.html --standalone --css=styles.css
python scripts/inject_css.py report.html

# 3. HTML → PDF（选一种）
msedge --headless --disable-gpu --print-to-pdf=report.pdf --no-pdf-header-footer file:///absolute/path/report.html
# 或
chrome --headless --disable-gpu --print-to-pdf=report.pdf file:///absolute/path/report.html
# 或
npx puppeteer print report.html report.pdf
```

## 文件结构

```
md-to-ppt-pdf/
├── README.md               ← 你在这里
├── SKILL.md                ← WorkBuddy 专用指令（其他平台需改写）
├── Makefile                ← 一键构建
├── scripts/
│   ├── generate_ppt.py     ← python-pptx 模板引擎（核心）
│   └── inject_css.py       ← HTML CSS 增强注入
├── assets/                 ← 静态资源（后续放主题包、字体）
└── references/             ← 设计文档
```

## 在其他 AI 编程助手中使用

### 方式一：直接调脚本（最通用）

任何支持 `run` / `execute_command` 的智能体都能调用：

```
# 给智能体的提示词：
"读取 scripts/generate_ppt.py，根据 DesignTokens 类，
为当前 Markdown 报告生成定制 PPTX。然后调用 scripts/inject_css.py 增强 HTML，
最后用 Edge/Chrome headless 打印 PDF。"
```

### 方式二：改写为平台指令

| 平台 | 操作 |
|------|------|
| **Cursor** | 复制 SKILL.md 内容到 `.cursorrules`，删除 frontmatter |
| **Claude Code** | 改写为 `.claude/commands/md-to-ppt.md`，用 slash command 触发 |
| **Copilot** | 改写为 `.github/copilot-instructions.md`，作为全局规则 |
| **Cline / Roo Code** | 在 `.clinerules` 中添加自定义指令块 |
| **Windsurf** | 写入 `.windsurfrules` |
| **通用 IDE** | 直接作为项目 README，人工/AI 参照执行 |

### 方式三：封装为独立 CLI 工具

```bash
# 后续可升级为 pip 包
pip install md-to-ppt-pdf

# 一键生成
md-to-ppt report.md --theme corporate --output report.pptx
```

## DesignTokens 参考

| Token | 色值 | 用途 |
|-------|------|------|
| `PRIMARY` | `#0D2137` | 标题、卡片头、深色背景 |
| `SECONDARY` | `#D4AF37` | 强调色、分割线、高亮 |
| `ACCENT` | `#2E86AB` | 链接、三级标题、数据 |
| `BG_LIGHT` | `#F5F3EE` | 页面背景 |
| `CARD_BG` | `#FFFFFF` | 卡片背景 |
| `TEXT_DARK` | `#1A1A2E` | 正文 |
| `TEXT_MUTED` | `#6B7280` | 辅助文字 |

## 布局模板

`generate_ppt.py` 内置的 slide 函数：

| 函数 | 用途 | 页数 |
|------|------|------|
| `slide_cover` | 封面（标题 + 副标题 + 日期） | 1 |
| `slide_toc` | 目录（编号列表） | 1 |
| `slide_3_conclusions` | 三栏核心结论卡片 | 1-2 |
| `slide_market_size` | 数据表格 + 指标高亮 | 1 |
| `slide_competitive` | 双栏对比（我们 vs 竞品） | 1 |
| `slide_monetization` | 三层变现漏斗图 | 1 |
| `slide_differentiation` | 四卡差异化分析 | 1 |
| `slide_90day_plan` | 时间线（5 阶段里程碑） | 1 |
| `slide_risk` | 风险预案表 | 1 |
| `slide_mvp` | CTA 行动号召 | 1 |
| `slide_thanks` | 致谢尾页 | 1 |

## 定制主题

修改 `scripts/generate_ppt.py` 顶部的 `DesignTokens` 类：

```python
class DesignTokens:
    COLOR_PRIMARY    = RGBColor(0x0D, 0x21, 0x37)   # 改成你的品牌色
    COLOR_SECONDARY  = RGBColor(0xD4, 0xAF, 0x37)
    COLOR_ACCENT     = RGBColor(0x2E, 0x86, 0xAB)
```

同步修改 `scripts/inject_css.py` 的 CSS 变量。

## 依赖

| 组件 | 用途 | 必需？ |
|------|------|--------|
| `python-pptx` | PPTX 生成 | ✅ 必需 |
| `pandoc` | MD→HTML 转换 | 可选（可用任一 MD 渲染器替代） |
| `msedge` / `chrome` | HTML→PDF 打印 | 仅 PDF 需要 |
| `sn-md-to-html-report` | WorkBuddy 内置 MD→HTML 美化 | WorkBuddy 专属，其他平台用 pandoc 替代 |

## License

MIT
