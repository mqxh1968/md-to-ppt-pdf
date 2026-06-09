# md-to-ppt-pdf 技能完整说明

> 基于 **html-ppt-skill**（GitHub 5700+ Star）设计理念自建的 Markdown 报告精美转换工具链。
> Token 驱动设计系统 + Navy Gold 主题配色，一链出 PPTX + PDF。

---

## 一、技能概述

| 属性 | 值 |
|------|-----|
| **技能名** | `md-to-ppt-pdf` |
| **触发词** | MD转PPT、报告转PPT、生成PPT、生成PDF、报告转PDF |
| **适用场景** | 研究报告、行业报告、投资分析报告等需要精美排版的场景 |
| **核心依赖** | python-pptx（PPTX）、pandoc 或 sn-md-to-html-report（HTML）、Edge/Chrome（PDF） |
| **输出格式** | `.pptx` + `.pdf` + `.docx` 三种格式 |

---

## 二、架构流程

```
report.md                        ← 你写的 Markdown 源文件
    │
    ├──→ [python-pptx 模板引擎] ──→ report.pptx    12页精美幻灯片
    │
    └──→ [sn-md-to-html-report] ──→ report.html     美化 HTML
                 │
                 ├──→ [inject_css.py] ──→  注入 DesignTokens CSS
                 │
                 └──→ [Edge headless CLI] ──→ report.pdf   专业 PDF
```

---

## 三、DesignTokens 配色系统

基于 Corporate Pitch 风格，核心配色：

```
┌─────────────────────────────────────────┐
│  PRIMARY   ■ #0D2137  Navy Blue  标题  │
│  SECONDARY ■ #D4AF37  Gold        强调  │
│  ACCENT    ■ #2E86AB  Teal        链接  │
│  BG_LIGHT  ■ #F5F3EE  暖灰        背景  │
│  CARD_BG   ■ #FFFFFF  白色        卡片  │
│  TEXT      ■ #1A1A2E  深蓝黑      正文  │
│  MUTED     ■ #6B7280  灰色        辅助  │
└─────────────────────────────────────────┘
```

修改 `generate_ppt.py` 中的 `class DesignTokens` 和 `inject_css.py` 中的 CSS 变量即可一键换皮。

---

## 四、11 种布局模板（generate_ppt.py）

| 函数 | 用途 | 固定页 |
|------|------|--------|
| `slide_cover(title, subtitle, date)` | 封面：标题 + 副标题 + 日期 | P1 |
| `slide_toc(items)` | 目录：编号列表 | P2 |
| `slide_3_conclusions(cards)` | 三栏核心结论卡片 | P3 |
| `slide_single_conclusion(text)` | 单栏大结论（黑底金字） | P4 |
| `slide_market_size(title, table_data)` | 数据表格 + 指标高亮 | P5 |
| `slide_competitive(us, them)` | 双栏对比（我们 vs 竞品） | P6 |
| `slide_monetization(tiers)` | 三层变现漏斗 | P7 |
| `slide_differentiation(cards)` | 四卡差异化分析 | P8 |
| `slide_90day_plan(phases)` | 时间线（多阶段里程碑） | P9 |
| `slide_risk(risks)` | 风险预案表 | P10 |
| `slide_thanks()` | 致谢尾页 | 末页 |

---

## 五、文件结构

```
md-to-ppt-pdf/
├── SKILL.md                 ← WorkBuddy 技能定义（加载入口）
├── SKILLS说明.md            ← 你正在看的这份文档
├── README.md                ← 通用使用手册（跨平台/跨智能体）
├── Makefile                 ← 一键构建脚本
├── scripts/
│   ├── generate_ppt.py      ← PPTX 模板引擎（～32KB，核心脚本）
│   └── inject_css.py        ← HTML CSS 增强注入器（～3KB）
├── assets/                  ← 静态资源预留（未来放字体/主题包）
└── references/              ← 设计文档预留
```

---

## 六、完整使用命令

### 在 WorkBuddy 中（自然语言触发）

```
"把这份报告转成 PPT 和 PDF"
"用 md-to-ppt-pdf 处理 report.md"
```

### 命令行直接调用

```bash
# PPTX
python scripts/generate_ppt.py

# HTML（需 sn-md-to-html-report skill）
python ~/.workbuddy/skills/sn-md-to-html-report/scripts/render_report.py \
    report.md report.html --with-js --mermaid-source cdn --title-style comfortable

# CSS 增强
python scripts/inject_css.py report.html

# PDF（Windows Edge）
"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" \
    --headless --disable-gpu --print-to-pdf=report.pdf \
    --no-pdf-header-footer "file:///C:/path/to/report.html"
```

### Makefile 一键构建

```bash
make all MD="报告.md" TITLE="报告标题"
```

---

## 七、已知限制与注意事项

| 限制 | 说明 | 应对 |
|------|------|------|
| RGBColor 不支持 alpha | python-pptx 的 RGBColor 只接受 3 参数 | 用纯色替代半透明 |
| Snakeviz 布局模板空 | `generate_ppt.py` 是骨架模板 | 每次需要根据报告内容定制 slide 函数 |
| Edge 路径固定 | 强制依赖 `C:\Program Files (x86)\Microsoft\Edge\` | macOS/Linux 替换为 Chrome 路径 |
| 中文渲染依赖系统字体 | Edge headless 无额外字体 | 确保系统安装了微软雅黑 |
| sn-md-to-html-report 仅 WorkBuddy | 其他智能体没有这个 skill | 用 pandoc 替代：`pandoc report.md -o report.html` |

---

## 八、迁移到其他 AI 智能体

### Cursor
将 SKILL.md 内容复制到 `.cursorrules`，删除 frontmatter 三行 `---`。

### Claude Code
改写为 `.claude/commands/md-to-ppt.md`（slash command 格式）。

### GitHub Copilot
改写为 `.github/copilot-instructions.md` 全局规则。

### 关键适配点
1. **MD→HTML**：把 `sn-md-to-html-report` 换成 `pandoc` 或 `marked`
2. **HTML→PDF**：把 Edge 路径换成目标平台的 Chrome/Chromium 路径
3. **指令格式**：把 WorkBuddy 的 `技能描述 → 流程说明` 改写成目标平台的 rules/commands 格式

---

## 九、版本历史

| 日期 | 版本 | 变更 |
|------|------|------|
| 2026-06-09 | 1.0 | 初始版本：基于 html-ppt-skill 设计理念自建 |
| 2026-06-09 | 1.1 | 添加 README.md + Makefile，支持跨智能体迁移 |
