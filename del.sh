#!/bin/bash

# 启用 nullglob 选项
shopt -s nullglob

# 目标目录
TARGET_DIR="/home/kvm"

# 获取初始项目列表
items=("$TARGET_DIR"/*)

# 计算总项目数
total_items=${#items[@]}

# 排除 'images' 文件夹
items_to_delete=()
images_count=0

for item in "${items[@]}"; do
    if [[ "$(basename "$item")" == "images" ]]; then
        ((images_count++))
    else
        items_to_delete+=("$item")
    fi
done

# 计算需要删除的项目数
delete_count=${#items_to_delete[@]}

echo "==========================================="
echo "目标目录: $TARGET_DIR"
echo "-------------------------------------------"
echo "总项目数: $total_items"
echo "将删除的项目数: $delete_count"
echo "将保留的项目数 (images 文件夹): $images_count"
echo "-------------------------------------------"

# 如果没有项目需要删除，退出脚本
if [ "$delete_count" -eq 0 ]; then
    echo "没有项目需要删除。操作已取消。"
    shopt -u nullglob
    exit 0
fi

# 初始化计数器
deleted=0

# 遍历并删除项目，同时显示进度
for item in "${items_to_delete[@]}"; do
    echo -n "."
    rm -rf "$item"
    ((deleted++))
    
    # 计算并显示进度百分比
    percent=$((deleted * 100 / delete_count))
    # 每删除10个项目换行一次，避免终端过于拥挤
    if (( deleted % 10 == 0 )); then
        echo -e "\n已删除 $deleted / $delete_count 个项目 (${percent}% 完成)"
    fi
done

echo -e "\n-------------------------------------------"
echo "删除完成！"
echo "已删除项目数: $deleted"
echo "剩余项目数: $(($total_items - images_count))"  # 因为 'images' 已被计入总数
echo "保留的项目: images"
echo "==========================================="

# 关闭 nullglob 选项
shopt -u nullglob