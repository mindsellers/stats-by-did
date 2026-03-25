#!/bin/bash

# Параметры подключения (измените под свои)
DB_HOST="localhost"
DB_USER="root"
DB_PASS="PASSWORD"
DB_NAME="asteriskcdrdb"

# Файл со списком номеров
NUM_LIST="numlist"

# Начало и конец интервала
START_DATE="2026-03-00 00:00:00"
END_DATE="2026-03-25 23:59:59"

# Читаем номера в массив, оборачиваем в кавычки и объединяем через запятую
numbers=$(awk '{printf "\"%s\",", $0}' "$NUM_LIST" | sed 's/,$//')

# Формируем SQL-запрос
sql="SELECT did, COUNT(*) AS call_count
     FROM cdr
     WHERE calldate BETWEEN '$START_DATE' AND '$END_DATE'
       AND did IN ($numbers)
     AND disposition='ANSWERED'
     GROUP BY did
     ORDER BY did;"

# Выполняем запрос
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "$sql"
