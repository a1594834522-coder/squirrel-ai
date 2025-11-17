# Squirrel AI 智能补全功能设置指南

本版本的 Squirrel 集成了 AI 智能补全功能，包括：
1. **Tab 键智能联想**：根据历史上下文和拼音生成自然语句
2. **Command 键问答**：根据拼音生成问题，并提供答案

## 快速开始

### 1. 配置 API Key

复制示例配置文件：
```bash
cd ~/Library/Rime
cp ai_pinyin.custom.yaml.example ai_pinyin.custom.yaml
```

编辑 `ai_pinyin.custom.yaml`，修改以下配置：
- `ai_completion/api_key`: 填入您的 OpenAI API Key 或兼容服务的 Key
- `ai_completion/base_url`: API 服务地址
- `ai_completion/model_name`: 使用的模型名称

### 2. 重新部署

在 Squirrel 菜单中选择「重新部署」，或在终端运行：
```bash
"/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel" --reload
```

### 3. 开始使用

#### Tab 键智能联想
1. 输入拼音（例如：`nihao`）
2. 按 Tab 键
3. 选择AI生成的候选项

#### Command 键问答
1. 输入拼音（例如：`meixijinnianjisui`）
2. 按 Command 键 → 看到3个相关问题
3. 用方向键选择一个问题
4. 再按 Command 键 → 看到答案
5. 按回车输出答案

## 配置说明

### AI 模型配置

```yaml
ai_completion/base_url: "https://api.openai.com/v1/chat/completions"
ai_completion/api_key: "YOUR_API_KEY_HERE"
ai_completion/model_name: "gpt-4o-mini"
```

支持任何兼容 OpenAI API 格式的服务。

### 上下文窗口

```yaml
ai_completion/context_window_minutes: 10
```

AI 会参考最近 N 分钟的输入历史来生成联想。

### 候选数量

```yaml
ai_completion/max_candidates: 3
```

每次 AI 调用生成的候选项数量。

## 故障排查

### AI 功能不工作

1. 检查 API Key 是否正确配置
2. 检查网络连接
3. 查看日志：`tail -f ~/Library/Rime/ai_debug.log`

### 输入法卡顿

如果 API 响应慢导致卡顿，可以：
1. 更换更快的 API 服务
2. 使用更小的模型（如 gpt-3.5-turbo）
3. 系统已内置30秒超时保护

## 注意事项

1. AI 功能需要网络连接
2. API 调用可能产生费用，请注意用量
3. 首次使用建议设置较低的调用频率
4. 隐私：输入历史会发送给 AI 服务，请注意保护敏感信息

## 禁用 AI 功能

如果想禁用 AI 功能：

```yaml
ai_completion/enabled: false
```

或直接删除 `ai_pinyin` 输入方案。
