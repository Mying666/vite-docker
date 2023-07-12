#!/bin/bash

# 设置要删除的文件夹的最大存在天数
max_days=7

# 指定要扫描的文件夹路径
folder_path="/www/server/nginx/html"

# 获取当前日期时间的时间戳
current_timestamp=$(date +%s)

# 获取文件夹列表
folders=$(find "$folder_path" -maxdepth 1 -type d)

# 遍历文件夹
for folder in $folders; do

  # 跳过根文件夹和名为"master"的文件夹
  if [[ "$folder" == "$folder_path" || "$folder" == "$folder_path/master" ]]; then
    continue
  fi

  # 获取文件夹的最后修改时间
  modified_timestamp=$(stat -f %m "$folder")

  # 计算文件夹的存在天数
  days=$(( (current_timestamp - modified_timestamp) / (3600 * 24) ))

  # 如果文件夹存在天数超过7天，则删除文件夹
  if (( days > $max_days )); then
    rm -rf "$folder"
    echo "Deleted folder: $folder"
  fi
done