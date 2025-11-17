# AI 补全输入法测试指南

## 阶段一测试（概念验证）✅

**状态**: 已完成，返回固定候选词

## 阶段二测试（真实 AI 集成）🔄

**状态**: 开发完成，待测试

### 前置条件

1. 已安装 Xcode 14.0+
2. 已安装 cmake 和 boost（`brew install cmake boost`）
3. 克隆项目并初始化子模块

### 构建步骤

```bash
cd /Users/abruzz1/code/squirrel

# 1. 清理之前的构建（可选）
make clean

# 2. 构建依赖（如果还没构建过）
make deps

# 3. 构建 Squirrel
make release

# 4. 安装到系统
sudo make install
```

### 安装配置文件

```bash
# 1. 创建 Rime 用户目录（如果不存在）
mkdir -p ~/.local/share/rime

# 2. 复制 Lua 脚本
cp lua/ai_completion.lua ~/.local/share/rime/lua/

# 3. 复制 schema 文件
cp data/ai_pinyin.schema.yaml ~/.local/share/rime/
cp data/ai_pinyin.custom.yaml.example ~/.local/share/rime/ai_pinyin.custom.yaml

# 4. 配置默认方案（添加 ai_pinyin 到方案列表）
cat >> ~/.local/share/rime/default.custom.yaml << 'EOF'
patch:
  schema_list:
    - schema: ai_pinyin
EOF
```

### 测试步骤

1. **退出并重新登录**（或杀掉 Squirrel 进程）
   ```bash
   killall Squirrel
   ```

2. **启动 Squirrel**
   - 从「系统偏好设置」→「键盘」→「输入法」启用 Squirrel

3. **重新部署 Rime**
   - 点击菜单栏的 Squirrel 图标
   - 选择「重新部署」(Redeploy)
   - 等待部署完成

4. **切换到 AI 拼音方案**
   - 按 `Ctrl + ~` 或 `F4`
   - 选择「AI 拼音」

5. **测试 AI 补全**
   - 在任意文本编辑器中
   - 输入一些拼音，例如 "nihao"
   - 按 `Tab` 键
   - 应该看到 AI 补全候选项（标注 [AI]）

### 预期结果

输入 "nihao" 后按 Tab，应该显示：

```
1. 这是 AI 补全测试候选项 1 [AI]
2. 这是 AI 补全测试候选项 2 [AI]
3. 这是 AI 补全测试候选项 3 - 输入: nihao [AI]
```

### 查看日志

如果有问题，查看 Rime 日志：

```bash
# Rime 引擎日志
tail -f /tmp/rime.squirrel/rime.log

# Squirrel 应用日志
tail -f /tmp/rime.squirrel/squirrel.log

# 或使用 macOS 日志系统
log stream --predicate 'process == "Squirrel"' --level debug
```

### 常见问题

#### 1. AI 拼音方案不出现

检查：
- `~/.local/share/rime/ai_pinyin.schema.yaml` 是否存在
- `~/.local/share/rime/default.custom.yaml` 是否包含 ai_pinyin

解决：
```bash
# 重新复制文件
cp data/ai_pinyin.schema.yaml ~/.local/share/rime/

# 重新部署
/Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload
```

#### 2. 按 Tab 没有反应

检查：
- 是否在 AI 拼音方案下（不是其他方案）
- 是否有输入内容

解决：
- 确认切换到 AI 拼音方案
- 先输入拼音，再按 Tab

#### 3. Lua 错误

查看日志找到具体错误：
```bash
grep -i "lua\|error" /tmp/rime.squirrel/rime.log
```

可能原因：
- Lua 脚本路径不对
- Lua 语法错误

解决：
```bash
# 确认 Lua 文件存在
ls -la ~/.local/share/rime/lua/ai_completion.lua

# 检查 Lua 语法
luac -p ~/.local/share/rime/lua/ai_completion.lua
```

## 开发调试

### 修改 Lua 代码后

1. 修改 `lua/ai_completion.lua`
2. 复制到用户目录：
   ```bash
   cp lua/ai_completion.lua ~/.local/share/rime/lua/
   ```
3. 重新部署 Rime

### 修改 schema 配置后

1. 修改 `data/ai_pinyin.schema.yaml` 或 `.custom.yaml`
2. 复制到用户目录：
   ```bash
   cp data/ai_pinyin.schema.yaml ~/.local/share/rime/
   ```
3. 重新部署 Rime

### 快速重新部署

```bash
# 命令行方式
/Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload

# 或通过菜单
# 点击 Squirrel 图标 → 重新部署
```

## 下一步

阶段一测试通过后，继续开发阶段二：集成真实的 AI API。

## 阶段二特定配置

### 1. 配置 AI API Key

编辑 `~/.local/share/rime/ai_pinyin.custom.yaml`：

```yaml
patch:
  ai_completion/enabled: true
  ai_completion/trigger_key: "Tab"
  
  # 必须配置！
  ai_completion/api_key: "sk-your-actual-api-key-here"
  
  # 可选：自定义 API 端点
  ai_completion/base_url: "https://api.openai.com/v1/chat/completions"
  ai_completion/model_name: "gpt-3.5-turbo"
  
  # 上下文和候选配置
  ai_completion/context_window_minutes: 5
  ai_completion/max_candidates: 3
```

### 2. 测试步骤

#### A. 基础 API 连接测试

1. **配置 API Key**
   - 确保 `ai_pinyin.custom.yaml` 中配置了有效的 API Key
   
2. **重新部署 Rime**
   ```bash
   /Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload
   ```

3. **测试基本补全**
   - 切换到 AI 拼音方案
   - 输入简单拼音，如 "nihao"
   - 按 Tab 键
   - 应该看到 AI 生成的候选项（而不是固定测试候选词）

#### B. 上下文测试

1. **输入一些文字建立上下文**
   - 输入并提交几句话，例如：
     - "今天天气很好"
     - "我想去公园散步"
   
2. **测试上下文感知补全**
   - 输入："所以我打算"
   - 按 Tab 键
   - AI 应该根据之前的上下文给出相关补全

#### C. 错误处理测试

1. **无效 API Key**
   - 故意设置错误的 API Key
   - 按 Tab 触发补全
   - 应该看到 "[AI 错误: ...]" 提示

2. **网络超时测试**
   - 断开网络
   - 按 Tab 触发补全
   - 应该静默失败或显示超时错误

### 3. 查看详细日志

查看 AI API 调用日志：

```bash
# 查看 Rime 日志
tail -f /tmp/rime.squirrel/rime.log | grep -i "ai\|error"

# 查看 Squirrel 日志
tail -f /tmp/rime.squirrel/squirrel.log

# 或使用系统日志
log stream --predicate 'process == "Squirrel"' --level debug
```

### 4. 调试技巧

#### 手动测试 curl 命令

可以手动测试 AI API 调用：

```bash
curl -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [
      {
        "role": "system",
        "content": "你是一个智能输入法助手。"
      },
      {
        "role": "user",
        "content": "当前输入：nihao\n\n补全："
      }
    ],
    "max_tokens": 100
  }'
```

#### 检查 Lua 错误

```bash
# 检查 Lua 语法
luac -p ~/.local/share/rime/lua/ai_completion.lua

# 查看 Lua 错误
grep -i "lua\|error" /tmp/rime.squirrel/rime.log
```

### 5. 预期结果

#### 成功场景

输入 "nihao" 后按 Tab，应该显示类似：

```
1. 你好 [AI]
2. 你好啊 [AI]  
3. 你好，很高兴认识你 [AI]
```

#### 错误场景

1. **API Key 未配置**
   ```
   1. [AI 错误: API Key 未配置] [AI]
   ```

2. **API 调用失败**
   ```
   1. [AI 错误: API 无响应] [AI]
   ```

3. **网络问题**
   ```
   (无候选项显示，或显示错误信息)
   ```

### 6. 性能指标

- **响应时间**: 通常 1-3 秒（取决于网络和 AI 服务）
- **超时设置**: 5 秒（curl -m 5）
- **并发**: 单次请求，不支持并发

### 7. 常见问题

#### Q: 按 Tab 没有响应

**检查列表**:
1. 确认在 AI 拼音方案下
2. 确认 API Key 已配置
3. 确认网络连接正常
4. 查看日志是否有错误

#### Q: 响应很慢

**优化建议**:
1. 检查网络连接
2. 使用更快的 AI 模型
3. 减少 `max_tokens` 设置
4. 减少 `context_window_minutes`

#### Q: 候选项质量不好

**调整建议**:
1. 调整 `temperature` 参数（在代码中）
2. 优化 system prompt
3. 提供更多上下文
4. 使用更强大的模型（如 gpt-4）

### 8. 自定义 AI 服务商

如果使用非 OpenAI 的 AI 服务（如 Claude、通义千问等）：

```yaml
patch:
  ai_completion/base_url: "https://your-ai-service.com/v1/chat/completions"
  ai_completion/api_key: "your-service-api-key"
  ai_completion/model_name: "your-model-name"
```

确保 API 格式兼容 OpenAI 的 Chat Completions API。

## 下一步：阶段三

阶段二测试通过后，可以进行阶段三的优化：
- 缓存机制
- 性能优化
- 更智能的上下文管理
- UI 改进

