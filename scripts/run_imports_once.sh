#!/bin/bash
params="--root=/var/www/tornado.generalshop.ru --uri=tornado.generalshop.ru"
# Словари
drush -y $params feeds:import 3 # Бренды Колобокс
drush -y $params feeds:import 4 # Модели Колобокс
drush -y $params feeds:import 5 # Диаметр Колобокс
drush -y $params feeds:import 11 # Модели Шинсервис

# Номенклатура
drush -y $params feeds:import 10 # Номенклатура Шинсервис
drush -y $params feeds:import 2 # Номенклатура Колобокс

# МРЦ
# Обновить файлы - пересохранить в CSV
drush -y $params feeds:import 12 # МРЦ (зима) Шинсеравис
drush -y $params feeds:import 7 # МРЦ (лето) Шинсеравис
