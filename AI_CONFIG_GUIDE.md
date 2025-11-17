# Squirrel AI 智能补全 - 配置指南

## 快速配置

### 方法1：使用配置工具（推荐）

运行配置工具脚本：
```bash
cd /Users/abruzz1/code/squirrel
./ai-config-tool.sh
```

按照提示输入：
- API Base URL（例如：`https://api.openai.com/v1/chat/completions`）
- API Key
- Model Name（例如：`gpt-4o-mini`）

### 方法2：手动编辑配置文件

1. 打开配置目录：
```bash
open ~/Library/Rime
```

2. 编辑 `ai_pinyin.custom.yaml`：
```yaml
patch:
  ai_completion/base_url: "https://api.openai.com/v1/chat/completions"
  ai_completion/api_key: "YOUR_API_KEY_HERE"
  ai_completion/model_name: "gpt-4o-mini"
```

3. 重新部署：
```bash
"/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel" --reload
```

## 功能说明

### Tab 键 - 智能联想
1. 输入拼音（如 `nihao`）
2. 按 Tab 键
3. 选择 AI 生成的联想句子

### Command 键 - 知识问答
1. 输入拼音（如 `meixijinnianjisui`）
2. 按 Command 键 → 看到 3 个相关问题
3. 用方向键选择问题
4. 再按 Command 键 → 看到答案
5. 按回车输出答案

## 文件位置

- 配置文件：`~/Library/Rime/ai_pinyin.custom.yaml`
- Lua 脚本：`~/Library/Rime/rime.lua`
- Schema 文件：`~/Library/Rime/ai_pinyin.schema.yaml`
- 调试日志：`~/Library/Rime/ai_debug.log`

## 故障排查

查看日志：
```bash
tail -f ~/Library/Rime/ai_debug.log
```

## 通过菜单访问（未来版本）

当前版本可以通过以下方式手动访问配置：
1. 右键点击输入法图标
2. 选择"Settings..."打开配置文件夹
3. 编辑 `ai_pinyin.custom.yaml`

未来版本将添加"AI Config..."菜单项，直接打开配置界面。
