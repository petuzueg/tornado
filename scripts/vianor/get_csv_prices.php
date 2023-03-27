<?php

$items = [];
$doc = new DOMDocument();
$string = file_get_contents('/var/www/tornado.generalshop.ru/web/sites/default/files/feeds/tmp/vianor-catalog_unprocessed.xml');

$doc->loadXML($string);

$xpath = new DOMXpath($doc);

// $elements = $xpath->query('/catalog/stores/gd[not(./store/@BR)]');
$elements = $xpath->query('/catalog/stores/gd[./store/@BR]');

if (!is_null($elements)) {
  foreach ($elements as $element) {
    $cae = $price = $amount = 0;
    $nodes = $element->childNodes;
    if ($element->nodeName == 'gd') {
      $cae = $element->getAttribute('cae');
    }
    foreach ($nodes as $node) {
      if ($node->nodeName == "price") {
        $price = $node->getAttribute('p1');
      }
      if ($node->nodeName == 'store') {
        $amount = $node->getAttribute('BR');
      }
    }

    if ($cae) {
      $items[$cae] = [
        'cae' => $cae,
        'price' => $price,
        'amount' => $amount,
      ];
    } else {
      // $no_cae[] = ['price' => $price, 'amount' => $amount];
    }
  }

  // Open a file in write mode ('w')
  $fp = fopen('/var/www/tornado.generalshop.ru/web/sites/default/files/feeds/csv/vianor.csv', 'w');

  fputcsv($fp, ['cae', 'price', 'amount']);

  // Loop through file pointer and a line
  foreach ($items as $fields) {
    fputcsv($fp, $fields);
  }

  fclose($fp);

}

