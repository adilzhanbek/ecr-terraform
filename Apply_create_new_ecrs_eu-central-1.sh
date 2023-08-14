#!/bin/sh

# Путь к файлу с именами
NAMES_FILE="to_add.list"

# Путь к директории, где находятся папки
BASE_DIR="./infra/eu-central-1/infra/ecr"

# Чтение списка имен из файла
names=$(cat "$NAMES_FILE")

# Разделение имен по строкам и выполнение действий
for name in $names; do
    # Проверяем, существует ли директория для имени
    if [ -d "$BASE_DIR/$name" ]; then
        echo "Terragrunt apply for $name..."
        # Переход в директорию и выполнение terragrunt apply
        (cd "$BASE_DIR/$name" && terragrunt apply -auto-approve)
    else
        echo "Folder $name not found"
    fi
done

