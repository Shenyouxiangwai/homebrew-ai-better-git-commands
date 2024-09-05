#!/bin/bash

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

if ! command -v jq &> /dev/null; then
    printf "\e[31mError: jq is not installed! Please install jq to continue.\e[0m\n" >&2
    exit 1
fi

git add .

diff_output=$(git diff --staged)

if [ -z "$diff_output" ]; then
    printf "\e[31mError: staged is empty!\e[0m\n" >&2
    exit 1
fi

escaped_diff_output=$(echo "$diff_output" | jq -R .)

if [ -z "$AIT_SECRET_KEY" ]; then
    printf "\e[31mError: AIT_SECRET_KEY NOT FOUND!\e[0m\n" >&2
    exit 1
fi

escaped_secret_key=$(echo "$AIT_SECRET_KEY" | jq -R .)

json_data=$(jq -n \
  --arg diff_output "$escaped_diff_output" \
  --arg secret_key "$escaped_secret_key" \
  '{diff_output: $diff_output, secret_key: $secret_key}')

function get_changelog {
    response=$(curl -s -X POST https://shenyouxiangwai.com/gitcommands/getChangelog \
      -H "Content-Type: application/json" \
      -d "$json_data" | tr -d '\000-\037')

    cleaned_response=$(echo "$response" | tr -d '\000-\037')

    changelog=$(echo "$cleaned_response" | jq -r '.changelog')

    if [ "$changelog" == "null" ]; then
        printf "\e[31mError: Server returned null for changelog!\e[0m\n" >&2
        exit 1
    fi

    printf "\e[32mChangelog: $changelog\e[0m\n"
}

function get_commit_message {
    response=$(curl -s -X POST https://shenyouxiangwai.com/gitcommands/getGitCommitMessage \
      -H "Content-Type: application/json" \
      -d "$json_data" | tr -d '\000-\037')

    cleaned_response=$(echo "$response" | tr -d '\000-\037')

    commit_message=$(echo "$cleaned_response" | jq -r '.commit_message')

    if [ "$commit_message" == "null" ]; then
        printf "\e[31mError: Server returned null for commit message!\e[0m\n" >&2
        exit 1
    fi

    git commit -m "$commit_message"
    printf "\e[32mSuccess: Git commit created with message: '$commit_message'\e[0m\n"
}

if [[ $1 == "review" ]]; then
    get_changelog
elif [[ $1 == "commit" ]]; then
    get_commit_message
else
    echo "Usage: $0 {review|commit}"
    exit 1
fi