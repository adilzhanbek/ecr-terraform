#!/bin/bash

# Путь к файлу с именами
names_file="names.txt"

# Базовый путь, где будут создаваться папки
base_path="./infra/eu-central-1/infra/ecr"

# Переменная для хранения имени
current_name=""

# Чтение и обработка имен из файла
while IFS= read -r current_name; do
    # Путь к целевой папке для имени
    target_folder="$base_path/$current_name"

    # Проверка существования папки
    if [ -d "$target_folder" ]; then
        echo "Folder for services $target_folder already exists, skip..."
        continue
    else
        echo "Creating new folder: $target_folder"
        mkdir -p "$target_folder"
    fi

    # Копирование файла terragrunt.hcl
    cp "./infra/eu-central-1/infra/ecr/microservice1/terragrunt.hcl" "$target_folder"

    # Переход в целевую папку
    cd "$target_folder" || exit

    # Запуск terragrunt plan
    echo "Terragrunt plan for $current_name"
    terragrunt plan

    # Возврат в исходную папку
    cd - || exit

    echo "Done for: $current_name"
done < "$names_file"
