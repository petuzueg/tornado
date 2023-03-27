update
    field_data_commerce_price price,
    field_revision_commerce_price price_revision,
    commerce_product product,
    field_data_field_availability avail,
    field_revision_field_availability avail_revision

set price.commerce_price_amount    = 0,
    price_revision.commerce_price_amount = 0,
    avail.field_availability_value = 'under_the_order',
    avail_revision.field_availability_value = 'under_the_order'

WHERE product.type = 'product'
  and price.entity_id = product.product_id
  and avail.entity_id = product.product_id
  and avail.revision_id = avail_revision.revision_id
  and price.revision_id = price_revision.revision_id
  and product.changed < UNIX_TIMESTAMP() - 60 * 60 * 2
  and avail.field_availability_value = 'in_stock'
  and product.product_id not in (select entity_id from field_data_field_freeze where field_freeze_value=1)
;
