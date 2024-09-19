#!/bin/bash

function show_help {
    echo "Usage: ait [command]"
    echo ""
    echo "Commands:"
    echo "  review      展示变更日志以及改正建议"
    echo "  commit      创建一个提交信息"
    echo "  -h, --help  展示帮助菜单"
}

# 检查帮助命令
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if ! command -v jq &> /dev/null; then
    printf "\e[31mError: jq is not installed! Please install jq to continue.\e[0m\n" >&2
    exit 1
fi

git add .

diff_output=$(git diff --staged)

if [ -z "$diff_output" ]; then
    printf "\e[31mError: Staged changes are empty!\e[0m\n" >&2
    exit 1
fi

if [ -z "$AIT_SECRET_KEY" ]; then
    printf "\e[31mError: AIT_SECRET_KEY NOT FOUND!\e[0m\n" >&2
    exit 1
fi

json_data=$(jq -n \
  --arg diff_output "$diff_output" \
  --arg secret_key "$AIT_SECRET_KEY" \
  '{diff_output: $diff_output, secret_key: $secret_key}')

# 动态加载效果函数
function show_spinner {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "\r\e[33mProcessing... %c\e[0m" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\r\e[32mProcessing... Done!\e[0m\n"
}

function get_changelog {
    # 后台运行curl命令
    {
        response=$(curl -s -w "\n%{http_code}" -X POST https://shenyouxiangwai.com/gitcommands/getChangelog \
          -H "Content-Type: application/json" \
          -d "$json_data")
        echo "$response" > /tmp/response_changelog
    } &

    # 显示动态加载效果
    show_spinner

    response=$(cat /tmp/response_changelog)
    rm /tmp/response_changelog

    status_code=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | sed '$d')

    if [ "$status_code" -ne 200 ]; then
        printf "\e[31mError: Received HTTP status $status_code from server!\e[0m\n" >&2
        exit 1
    fi

    cleaned_response=$(echo "$body" | tr -d '\000-\037')

    changelog=$(echo "$cleaned_response" | jq -r '.changelog')

    if [ "$changelog" == "null" ]; then
        printf "\e[31mError: Server returned null for changelog!\e[0m\n" >&2
        exit 1
    fi

    printf "\e[32mChangelog:\n$changelog\e[0m\n"
}

function get_commit_message {
    # 后台运行curl命令
    {
        response=$(curl -s -w "\n%{http_code}" -X POST https://shenyouxiangwai.com/gitcommands/getCommitMessage \
          -H "Content-Type: application/json" \
          -d "$json_data")
        echo "$response" > /tmp/response_commit
    } &

    # 显示动态加载效果
    show_spinner

    response=$(cat /tmp/response_commit)
    rm /tmp/response_commit

    status_code=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | sed '$d')

    if [ "$status_code" -ne 200 ]; then
        printf "\e[31mError: Received HTTP status $status_code from server!\e[0m\n" >&2
        exit 1
    fi

    cleaned_response=$(echo "$body" | tr -d '\000-\037')

    commit_message=$(echo "$cleaned_response" | jq -r '.commit_message')

    if [ "$commit_message" == "null" ]; then
        printf "\e[31mError: Server returned null for commit message!\e[0m\n" >&2
        exit 1
    fi

    git commit -m "$commit_message"
    printf "\e[32mSuccess: Git commit created with message:\n'$commit_message'\e[0m\n"
}

if [[ $1 == "review" ]]; then
    get_changelog
elif [[ $1 == "commit" ]]; then
    get_commit_message
else
    echo "Usage: $0 {review|commit}"
    exit 1
fi