#!/bin/bash

# Squirrel AI 配置工具
# 用于快速配置 AI 智能补全功能

CONFIG_DIR="$HOME/Library/Rime"
CONFIG_FILE="$CONFIG_DIR/ai_pinyin.custom.yaml"
EXAMPLE_FILE="$CONFIG_DIR/ai_pinyin.custom.yaml.example"

echo "======================================"
echo "  Squirrel AI 智能补全配置工具"
echo "======================================"
echo ""

# 确保目录存在
mkdir -p "$CONFIG_DIR"

# 如果配置文件不存在，从示例复制
if [ ! -f "$CONFIG_FILE" ] && [ -f "$EXAMPLE_FILE" ]; then
    cp "$EXAMPLE_FILE" "$CONFIG_FILE"
    echo "✓ 已从示例文件创建配置"
fi

# 读取当前配置
if [ -f "$CONFIG_FILE" ]; then
    CURRENT_BASE_URL=$(grep 'ai_completion/base_url:' "$CONFIG_FILE" | sed 's/.*"\(.*\)".*/\1/')
    CURRENT_API_KEY=$(grep 'ai_completion/api_key:' "$CONFIG_FILE" | sed 's/.*"\(.*\)".*/\1/')
    CURRENT_MODEL=$(grep 'ai_completion/model_name:' "$CONFIG_FILE" | sed 's/.*"\(.*\)".*/\1/')
    
    echo "当前配置:"
    echo "  Base URL: $CURRENT_BASE_URL"
    echo "  API Key: ${CURRENT_API_KEY:0:20}..."
    echo "  Model: $CURRENT_MODEL"
    echo ""
fi

# 询问是否要修改
read -p "是否要修改配置? (y/n): " MODIFY
if [ "$MODIFY" != "y" ] && [ "$MODIFY" != "Y" ]; then
    echo "配置未修改"
    exit 0
fi

# 输入新配置
echo ""
echo "请输入新的配置 (直接回车保持不变):"
echo ""

read -p "API Base URL [$CURRENT_BASE_URL]: " NEW_BASE_URL
NEW_BASE_URL=${NEW_BASE_URL:-$CURRENT_BASE_URL}

read -p "API Key [$CURRENT_API_KEY]: " NEW_API_KEY
NEW_API_KEY=${NEW_API_KEY:-$CURRENT_API_KEY}

read -p "Model Name [$CURRENT_MODEL]: " NEW_MODEL
NEW_MODEL=${NEW_MODEL:-$CURRENT_MODEL}

# 生成新配置文件
cat > "$CONFIG_FILE" << YAML_EOF
# ai_pinyin.custom.yaml
# AI 拼音输入方案自定义配置
# 通过 AI 配置工具生成

patch:
  # AI 补全配置
  ai_completion/enabled: true
  ai_completion/trigger_key: "Tab"

  # AI 模型配置
  ai_completion/base_url: "$NEW_BASE_URL"
  ai_completion/api_key: "$NEW_API_KEY"
  ai_completion/model_name: "$NEW_MODEL"

  # 上下文配置
  ai_completion/context_window_minutes: 10
  ai_completion/max_candidates: 3

  # 按键绑定配置
  key_binder/bindings:
    - { when: composing, accept: Tab, send: Tab }
    - { when: composing, accept: Shift+Tab, send: Shift+Tab }
YAML_EOF

echo ""
echo "✓ 配置已保存到: $CONFIG_FILE"
echo ""
echo "正在重新加载 Squirrel..."
"/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel" --reload 2>/dev/null || echo "请手动重新部署 Squirrel"
echo ""
echo "✓ 完成！AI 功能已配置"
echo ""
