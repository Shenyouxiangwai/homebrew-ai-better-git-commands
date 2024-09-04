#!/bin/bash

# 检查是否安装了 jq
if ! command -v jq &> /dev/null
then
    printf "\e[31mError: jq is not installed! Please install jq to continue.\e[0m\n" >&2
    exit 1
fi

# 第一步：执行 git diff --staged 并保存输出
diff_output=$(git diff --staged)

# 第二步：检查 diff 输出是否为空
if [ -z "$diff_output" ]; then
    printf "\e[31mError: staged is empty!\e[0m\n" >&2
    exit 1
fi

# 转义 diff_output 并使用 jq 处理
escaped_diff_output=$(echo "$diff_output" | jq -R .)

if [ -z "$AIT_SECRET_KEY" ]; then
    printf "\e[31mError: AIT_SECRET_KEY NOT FOUND!\e[0m\n" >&2
    exit 1
fi

escaped_secret_key=$(echo "$AIT_SECRET_KEY" | jq -R .)

# 构建完整的JSON数据
json_data=$(jq -n \
  --arg diff_output "$escaped_diff_output" \
  --arg secret_key "$escaped_secret_key" \
  '{diff_output: $diff_output, secret_key: $secret_key}')

# 调用 API 获取变更日志
response=$(curl -s -X POST https://shenyouxiangwai.com/gitcommands/getChangelog \
  -H "Content-Type: application/json" \
  -d "$json_data" | tr -d '\000-\037')

# 删除控制字符并解析 JSON 响应
cleaned_response=$(echo "$response" | tr -d '\000-\037')

# 使用 jq 解析 JSON 响应
changelog=$(echo "$cleaned_response" | jq -r '.changelog')

if [ "$changelog" == "null" ]; then
    printf "\e[31mError: Server returned null for changelog!\e[0m\n" >&2
    exit 1
fi

# 打印变更日志
printf "\e[32mChangelog: $changelog\e[0m\n"