#!/bin/bash

# 获取当前脚本的目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 显示帮助信息
function show_help {
    echo "Usage: ait [command]"
    echo ""
    echo "Commands:"
    echo "  review    展示变更日志以及改正建议"
    echo "  commit    创建一个提交信息"
    echo "  -h, --help  展示帮助菜单"
}

# 检查帮助命令
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# 调用 get_changelog.sh
if [[ $1 == "review" ]]; then
    "$SCRIPT_DIR/get_changelog.sh"
# 调用 get_commit_message.sh
elif [[ $1 == "commit" ]]; then
    "$SCRIPT_DIR/get_commit_message.sh"
else
    echo "Usage: $0 {review|commit}"
    exit 1
fi