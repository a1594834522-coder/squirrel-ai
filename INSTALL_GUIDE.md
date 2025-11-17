# AI 智能补全输入法 - 完整安装指南

## ⚠️ 重要提示

1. **触发键已更改**: 默认使用 `Control+Space`（Tab 键已被占用）
2. **需要先卸载**: 如已安装原版 Squirrel，需要先卸载

---

## 步骤一：卸载旧版本（如有）

### 自动卸载（推荐）

```bash
sudo ./uninstall_squirrel.sh
```

按提示操作：
- 输入 `y` 确认卸载
- 选择是否删除用户数据（建议保留，输入 `n`）

### 手动卸载

```bash
# 1. 停止 Squirrel
killall Squirrel

# 2. 删除应用
sudo rm -rf "/Library/Input Methods/Squirrel.app"

# 3. （可选）删除用户数据
# rm -rf ~/.local/share/rime
```

### 系统设置清理

1. 打开「系统偏好设置」→「键盘」→「输入法」
2. 移除 Squirrel（点击 `-` 号）
3. **重新登录**或重启系统

---

## 步骤二：构建新版本

```bash
cd /Users/abruzz1/code/squirrel

# 清理之前的构建（可选）
make clean

# 构建（如果还没构建依赖）
make deps

# 构建 Squirrel
make release
```

---

## 步骤三：安装新版本

```bash
# 安装到系统
sudo make install
```

---

## 步骤四：安装 AI 补全配置

```bash
# 1. 创建目录
mkdir -p ~/.local/share/rime/lua

# 2. 复制 Lua 插件
cp lua/ai_completion.lua ~/.local/share/rime/lua/

# 3. 复制 schema 文件
cp data/ai_pinyin.schema.yaml ~/.local/share/rime/

# 4. 创建配置文件
cp data/ai_pinyin.custom.yaml.example ~/.local/share/rime/ai_pinyin.custom.yaml
```

---

## 步骤五：配置 AI API Key

编辑配置文件：

```bash
vim ~/.local/share/rime/ai_pinyin.custom.yaml
# 或使用其他编辑器
open -a TextEdit ~/.local/share/rime/ai_pinyin.custom.yaml
```

修改以下内容：

```yaml
patch:
  ai_completion/enabled: true
  
  # ⚠️ 触发键已改为 Control+space（Tab 已被占用）
  ai_completion/trigger_key: "Control+space"
  
  # 必须配置 API Key！
  ai_completion/api_key: "sk-your-actual-api-key-here"  # 替换为你的真实 API Key
  
  # 可选：自定义 API 配置
  ai_completion/base_url: "https://api.openai.com/v1/chat/completions"
  ai_completion/model_name: "gpt-3.5-turbo"
  ai_completion/context_window_minutes: 5
  ai_completion/max_candidates: 3
```

---

## 步骤六：添加 AI 拼音方案

编辑或创建 `~/.local/share/rime/default.custom.yaml`：

```bash
vim ~/.local/share/rime/default.custom.yaml
```

添加以下内容：

```yaml
patch:
  schema_list:
    - schema: ai_pinyin  # 添加 AI 拼音方案
    # 如果有其他方案，也在这里添加
    # - schema: luna_pinyin
    # - schema: cangjie5
```

---

## 步骤七：激活输入法

### 1. 重新登录

**重要**：首次安装需要退出登录并重新登录

```bash
# 或者重启系统
sudo shutdown -r now
```

### 2. 添加输入法

重新登录后：

1. 打开「系统偏好设置」→「键盘」→「输入法」
2. 点击 `+` 号
3. 选择「简体中文」
4. 找到「鼠鬚管」(Squirrel)
5. 点击「添加」

---

## 步骤八：重新部署 Rime

### 方法一：菜单操作

1. 点击菜单栏的 Squirrel 图标（输入法图标）
2. 选择「重新部署」

### 方法二：命令行

```bash
/Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload
```

---

## 步骤九：测试 AI 补全

### 1. 切换到 AI 拼音方案

- 按 `Control + ~` 或 `F4`
- 选择「AI 拼音」

### 2. 测试基本补全

- 在任意文本编辑器中
- 输入拼音，例如 `nihao`
- **按 `Control+Space`**（不是 Tab）
- 应该看到 AI 生成的候选项

---

## 🎯 快捷键说明

| 功能 | 快捷键 | 说明 |
|------|--------|------|
| **AI 补全** | `Control+Space` | 触发 AI 智能补全 |
| 切换方案 | `Control+~` 或 `F4` | 切换输入方案 |
| 重新部署 | 菜单操作 | 应用配置更改 |

### ⚠️ 如果 Control+Space 也冲突

可以在配置中修改为其他快捷键：

```yaml
# ~/.local/share/rime/ai_pinyin.custom.yaml
patch:
  ai_completion/trigger_key: "Control+Shift+space"  # 或其他组合
```

---

## 故障排查

### 问题 1: 输入法不出现

**解决**：
1. 确认已重新登录
2. 检查「系统偏好设置」→「键盘」→「输入法」中是否有 Squirrel
3. 如果没有，可能需要手动添加

### 问题 2: AI 拼音方案不出现

**检查**：
```bash
# 确认文件存在
ls ~/.local/share/rime/ai_pinyin.schema.yaml
ls ~/.local/share/rime/default.custom.yaml

# 查看日志
tail -f /tmp/rime.squirrel/rime.log
```

**解决**：重新部署 Rime

### 问题 3: 按 Control+Space 没反应

**检查列表**：
1. 确认已切换到「AI 拼音」方案
2. 确认有输入内容（先输入拼音）
3. 确认 API Key 已配置
4. 查看日志：`tail -f /tmp/rime.squirrel/rime.log`

### 问题 4: AI 错误提示

可能原因：
- API Key 未配置或无效
- 网络问题
- API 服务不可用

**检查**：
```bash
# 手动测试 API
curl -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"hello"}]}'
```

---

## 完整流程总结

```bash
# 1. 卸载旧版本
sudo ./uninstall_squirrel.sh

# 2. 构建新版本
make release && sudo make install

# 3. 安装配置
mkdir -p ~/.local/share/rime/lua
cp lua/ai_completion.lua ~/.local/share/rime/lua/
cp data/ai_pinyin.schema.yaml ~/.local/share/rime/
cp data/ai_pinyin.custom.yaml.example ~/.local/share/rime/ai_pinyin.custom.yaml

# 4. 编辑配置（添加 API Key）
vim ~/.local/share/rime/ai_pinyin.custom.yaml

# 5. 添加方案
echo 'patch:
  schema_list:
    - schema: ai_pinyin' > ~/.local/share/rime/default.custom.yaml

# 6. 重新登录系统

# 7. 添加输入法（通过系统设置）

# 8. 重新部署
/Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload

# 9. 测试（切换到 AI 拼音，输入拼音，按 Control+Space）
```

---

## 📝 重要提醒

- ✅ 触发键是 `Control+Space`，不是 Tab
- ✅ 首次安装需要重新登录
- ✅ 必须配置 API Key
- ✅ 需要切换到「AI 拼音」方案

---

有问题查看详细文档：
- `TESTING.md` - 测试指南
- `AI_COMPLETION_GUIDE.md` - 使用指南
- `FINAL_SUMMARY.md` - 项目总结
