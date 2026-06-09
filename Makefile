# md-to-ppt-pdf — Markdown → PPTX + PDF 一键构建
# 依赖: python-pptx, pandoc (或 sn-md-to-html-report), msedge (或 chrome)
#
# 用法:
#   make install         安装 Python 依赖
#   make ppt             生成 PPTX
#   make html MD=报告.md  MD → HTML
#   make pdf  HTML=报告.html   HTML → PDF
#   make all  MD=报告.md  全流程 MD → PPTX + PDF
#   make clean           清理产物

.SILENT:

# === 配置 ===
PYTHON       ?= python3
PANDOC       ?= pandoc
EDGE         ?= "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
CHROME       ?= chrome
PIP          ?= pip3

# 默认输入输出
MD           ?= report.md
HTML         ?= $(MD:.md=.html)
PPTX         ?= $(MD:.md=.pptx)
PDF          ?= $(MD:.md=.pdf)
TITLE        ?= "报告"

# === 目标 ===
.PHONY: install ppt html pdf all clean help

help: ## 显示帮助
	@echo "md-to-ppt-pdf — Markdown 一键转精美 PPT + PDF"
	@echo ""
	@echo "用法:"
	@echo "  make install         安装 Python 依赖"
	@echo "  make ppt  MD=xxx.md  生成 PPTX"
	@echo "  make html MD=xxx.md  MD → HTML + CSS 增强"
	@echo "  make pdf  HTML=xxx.html  HTML → PDF"
	@echo "  make all  MD=xxx.md  全流程 MD → PPTX + PDF"
	@echo "  make clean           清理产物"
	@echo ""
	@echo "示例:"
	@echo "  make all MD=\"文旅报告.md\" TITLE=\"文旅研究报告\""

install: ## 安装 Python 依赖
	@echo "[install] 安装 python-pptx ..."
	$(PIP) install python-pptx -q
	@echo "[install] 完成"

ppt: ## MD → PPTX
	@echo "[ppt] 生成 PPTX: $(PPTX)"
	$(PYTHON) scripts/generate_ppt.py

html: ## MD → HTML + CSS 增强（依赖 pandoc）
	@echo "[html] $(MD) → $(HTML)"
	$(PANDOC) "$(MD)" -o "$(HTML)" --standalone --self-contained \
		--metadata title="$(TITLE)" \
		-V lang=zh-CN \
		--css=style.css
	@echo "[html] 注入 DesignTokens CSS ..."
	$(PYTHON) scripts/inject_css.py "$(HTML)"
	@echo "[html] 完成 → $(HTML)"

pdf: ## HTML → PDF（依赖 Edge/Chrome）
	@echo "[pdf] $(HTML) → $(PDF)"
	@if [ -f $(EDGE) ]; then \
		$(EDGE) --headless --disable-gpu \
			--print-to-pdf="$(PDF)" \
			--no-pdf-header-footer \
			"file:///$(PWD)/$(HTML)" 2>/dev/null && \
		echo "[pdf] Edge 完成 → $(PDF)" ; \
	elif command -v $(CHROME) >/dev/null 2>&1; then \
		$(CHROME) --headless --disable-gpu \
			--print-to-pdf="$(PDF)" \
			--no-pdf-header-footer \
			"file:///$(PWD)/$(HTML)" 2>/dev/null && \
		echo "[pdf] Chrome 完成 → $(PDF)" ; \
	else \
		echo "[pdf] 错误: 未找到 Edge 或 Chrome。请设置 EDGE 或 CHROME 变量。"; \
		exit 1; \
	fi

all: ## 全流程 MD → PPTX + PDF
	@$(MAKE) --no-print-directory ppt MD="$(MD)"
	@echo ""
	@$(MAKE) --no-print-directory html MD="$(MD)" TITLE="$(TITLE)"
	@echo ""
	@$(MAKE) --no-print-directory pdf HTML="$(HTML)"
	@echo ""
	@echo "===== 全流程完成 ====="
	@echo "  PPTX: $(PPTX)"
	@echo "  PDF:  $(PDF)"
	@echo "====================="

clean: ## 清理产物（保留源 MD）
	@echo "[clean] 清理 ..."
	@rm -f *.html *.pdf *.pptx 2>/dev/null || true
	@echo "[clean] 完成"
