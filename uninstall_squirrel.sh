#!/bin/bash
# Squirrel 输入法卸载脚本

set -e

echo "========================================="
echo "  Squirrel 输入法卸载工具"
echo "========================================="
echo ""

# 检查权限
if [ "$EUID" -ne 0 ]; then 
    echo "错误：需要管理员权限"
    echo "请使用: sudo bash uninstall_squirrel.sh"
    exit 1
fi

SQUIRREL_APP="/Library/Input Methods/Squirrel.app"
USER_DATA="$HOME/.local/share/rime"

echo "即将执行以下操作："
echo "1. 停止 Squirrel 进程"
echo "2. 删除 $SQUIRREL_APP"
echo "3. （可选）删除用户数据 $USER_DATA"
echo ""

read -p "是否继续? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "已取消"
    exit 0
fi

# 1. 停止 Squirrel 进程
echo ""
echo "步骤 1/3: 停止 Squirrel 进程..."
killall Squirrel 2>/dev/null || echo "  Squirrel 未运行"

# 2. 删除应用程序
echo ""
echo "步骤 2/3: 删除 Squirrel.app..."
if [ -d "$SQUIRREL_APP" ]; then
    rm -rf "$SQUIRREL_APP"
    echo "  ✓ 已删除: $SQUIRREL_APP"
else
    echo "  ! 未找到: $SQUIRREL_APP"
fi

# 3. 询问是否删除用户数据
echo ""
echo "步骤 3/3: 用户数据处理..."
if [ -d "$USER_DATA" ]; then
    echo "  发现用户数据目录: $USER_DATA"
    read -p "  是否删除用户数据（词库、配置等）? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$USER_DATA"
        echo "  ✓ 已删除用户数据"
    else
        echo "  ⊙ 保留用户数据"
    fi
else
    echo "  ! 未找到用户数据目录"
fi

echo ""
echo "========================================="
echo "  卸载完成！"
echo "========================================="
echo ""
echo "后续步骤："
echo "1. 前往「系统偏好设置」→「键盘」→「输入法」"
echo "2. 移除 Squirrel 输入法（如果还在列表中）"
echo "3. 重新登录或重启系统（推荐）"
echo ""
echo "现在可以安装新版本的 Squirrel："
echo "  cd /Users/abruzz1/code/squirrel"
echo "  make release"
echo "  sudo make install"
echo ""
