# Запускается только в ручном режиме.
# Генерация CSV-файла для передачи в GS.
mysql --user=tornado --password=oe4Ra6oh1 --database=tornado --host=localhost --port=3306 < export_to_csv.sql | sed 's/\t/,/g' > /var/www/generalshop.ru/sites/default/files/import/export_from_tornado.csv
