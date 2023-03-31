#!/bin/bash

params="--root=/var/www/tornado.generalshop.ru --uri=tornado.generalshop.ru"
paramsGS="--root=/var/www/generalshop.ru --uri=generalshop.ru"

# Товары
drush -y $params feeds:import 9  # Товары Шинсервис
drush -y $params feeds:import 6  # Товары Колобокс
drush -y $params feeds:import 13 # Товары 4tochki
drush -y $params feeds:import 16 # Товары Vianor

iconv -f windows-1251 -t utf-8 /var/www/generalshop.ru/sites/default/files/uploads/AUTORUSshina.csv > /var/www/tornado.generalshop.ru/web/sites/default/files/feeds/xml/autorus_shina.xml
drush -y $params feeds:import 17 # Товары Авторусь

# Сбросить кэш GS.
drush $paramsGS cc all

# Генерация CSV файла для обновления цен в GS для уже существующих товаров.
mysql --user=tornado --password=oe4Ra6oh1 --database=tornado --host=localhost --port=3306 < /var/www/tornado.generalshop.ru/scripts/export_to_csv.sql | sed 's/\t/,/g' > /var/www/generalshop.ru/sites/default/files/import/export_from_tornado.csv

# Импорт из CSV-файла в GS.
drush -y $paramsGS feeds-import tornado_import_prices # Импорт данных из сгенерированного CSV в GS.

# Снимаем с публикации старые товары (старее 2 часов).
mysql --user=generalshop --password=ewa9kxj4La --database=generalshop --host=localhost --port=3306 < /var/www/tornado.generalshop.ru/scripts/reset_prices.sql

