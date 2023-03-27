<?php

$file_name = '/var/www/tornado.generalshop.ru/web/sites/default/files/feeds/csv/4tochki.csv';

get_tyres($file_name);

function get_tyres($file_name) {
  $client = new SoapClient("http://api-b2b.4tochki.ru/WCF/ClientService.svc?wsdl", ['trace' => TRUE]);
  $user = 'sa05902';
  $pass = 'Xw@P*w(e5S';
  $wrh = [1, 232]; // Склады mkrs и yamka.
  $result = [];

  foreach ($wrh as $w) {
    $total_pages = 0;
    for ($page = 0; $page <= $total_pages; $page++) {
      $params = [
        'login' => $user,
        'password' => $pass,
        'filter' => [
          'wrh_list' => [$w], // Склад.
          'quality' => 0, // Только новые.
          'type_list' => [
            'car',
            'cartruck',
            'vned',
          ],
        ],
        'page' => $page,
        'pageSize' => 2000,
      ];

      $answer = $client->GetFindTyre($params);

      // Debugging:
      // echo "REQUEST:\n" . htmlentities($client->__getLastRequest()) . "\n";
      // echo "RESPONSE:\n" . htmlentities($client->__getLastResponse()) . "\n";

      if (is_null($answer->GetFindTyreResult->error)) {
        $total_pages = --$answer->GetFindTyreResult->totalPages;
        if (property_exists($answer->GetFindTyreResult->price_rest_list, 'TyrePriceRest')) {
          $items = $answer->GetFindTyreResult->price_rest_list->TyrePriceRest;
          foreach ($items as $r) {

            // Add a space before R.
            $name_replaced = preg_replace('/(.+[0-9].)([R][1-9])(.+)/', '$1 $2$3', $r->name);
            // Set full name.
            $r->full_name = $r->marka . ' ' . $r->model . ' ' . str_replace($r->model, '', $name_replaced);
            // Cast object to array.
            //$result[] = json_decode(json_encode($r), TRUE);
            $result[] = $r;
          }
        }
      }
      else {
        // todo throw error.
      }
    }
  }

  // Sort the array by full_name.
  array_multisort(array_column($result, 'full_name'), SORT_ASC, SORT_STRING, $result);

  // $file_name = 'file.csv';
  // Clear the file.
  file_put_contents($file_name, "");
  $fp = fopen($file_name, 'w');
  write_CSV($result, $fp);
  fclose($fp);
}

function write_CSV(array $tyre_price_list, $fp) {
  $excluded_brands = [
    'Nexen',
    'Bridgestone',
    'Maxxis',
  ];
  $fields = [
    'code',
    'price',
    'full_name',
    'marka',
    'model',
    'name',
    'season',
    'thorn',
    'type',
    'amount',
    'wrh',
  ];
  // Добавляем заголовки колонок в CSV-файл.
  fputcsv($fp, $fields);

  /*  foreach ($tyre_price_list as $item) {
      if (isset($item['whpr']['wh_price_rest']['price']) && !in_array($item['marka'], $excluded_brands)) {
        foreach ($fields as $f) {
          switch ($f) {
            case 'price':
              $l = $item['whpr']['wh_price_rest']['price'];
              break;
            case 'amount':
              $l = $item['whpr']['wh_price_rest']['rest'];
              break;
            case 'wrh':
              $l = $item['whpr']['wh_price_rest']['wrh'];
              break;
            default:
              $l = $item[$f];
          }
          $list[$f] = $l;
        }
      }
      fputcsv($fp, $list);
    }*/

  foreach ($tyre_price_list as $item) {
    if (isset($item->whpr->wh_price_rest->price) && !in_array($item->marka, $excluded_brands)) {
      foreach ($fields as $f) {
        switch ($f) {
          case 'price':
            $l = $item->whpr->wh_price_rest->price;
            break;
          case 'amount':
            $l = $item->whpr->wh_price_rest->rest;
            break;
          case 'wrh':
            $l = $item->whpr->wh_price_rest->wrh;
            break;
          default:
            $l = $item->$f;
        }
        $list[$f] = $l;
      }
      fputcsv($fp, $list);
    }
  }
}


