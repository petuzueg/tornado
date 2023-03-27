-- Set margin for 15%.
SET
    @margin = 1.15;
SET
    @price_limit = 4000;
SET
    @amount_limit = 4;

SELECT node_sku.title                                                                         sku,
       -- REGEXP_REPLACE(node_sku.title, "^0+(?!$)", "")                                     sku1,
       CEIL(if(mrc.field_mrc_value >= MIN(price.field_price_value) * @margin, mrc.field_mrc_value,
                   MIN(price.field_price_value) * @margin))                                price_final,
       node.nid,
       MIN(price.field_price_value)                                                           price_value,
       CEIL(MIN(price.field_price_value) * @margin)                                    price_calculated,
       mrc.field_mrc_value                                                                    price_mrc,
       if(mrc.field_mrc_value >= MIN(price.field_price_value) * @margin, 'mrc', 'calculated') price_final,
       amount.field_amount_value                                                              amount,
       taxonomy_brand.name                                     as                             brand,
       taxonomy_model.name                                     as                             model,
       node_tyre_width.field_tyre_width_value                  as                             tyre_width,
       cast(node_tire_profile.field_tire_profile_value as INT) as                             tire_profile,
       taxonomy_diameter.name                                  as                             diameter,
       taxonomy_sezonnost.name                                 as                             sezonnost,
       node_load_index.field_load_index_value                  as                             load_index,
       node_speed_index.field_speed_index_value                as                             speed_index,
       node_shipy.field_shipy_value                            as                             shipy,
       IF(node_runflat.field_runflat_value = 1, "1", "0") as                             runflat,
      -- node_foto.field_foto_uri                                as                             foto,
       node_type.field_type_value                              as                             type

from node_field_data node
         left join node__field_price price
                   on node.nid = price.entity_id and price.deleted = '0'
         left join node__field_node_sku sku
                   on node.nid = sku.entity_id and sku.deleted = '0'
         left join node_field_data node_sku
                   on sku.field_node_sku_target_id = node_sku.nid
         left join node__field_amount amount
                   on node.nid = amount.entity_id
         left join node__field_mrc mrc
                   on node_sku.nid = mrc.entity_id

         left join node nomenklatura
                   on nomenklatura.type = 'product' and nomenklatura.nid = sku.field_node_sku_target_id

         left join node__field_brand node_brand
                   on nomenklatura.nid = node_brand.entity_id
         left join taxonomy_term_field_data taxonomy_brand
                   on taxonomy_brand.tid = node_brand.field_brand_target_id

         left join node__field_model node_model
                   on nomenklatura.nid = node_model.entity_id
         left join taxonomy_term_field_data taxonomy_model
                   on taxonomy_model.tid = node_model.field_model_target_id

         left join node__field_diameter node_diameter
                   on nomenklatura.nid = node_diameter.entity_id
         left join taxonomy_term_field_data taxonomy_diameter
                   on taxonomy_diameter.tid = node_diameter.field_diameter_target_id

         left join node__field_sezonnost node_sezonnost
                   on nomenklatura.nid = node_sezonnost.entity_id
         left join taxonomy_term_field_data taxonomy_sezonnost
                   on taxonomy_sezonnost.tid = node_sezonnost.field_sezonnost_target_id

         left join node__field_tyre_width node_tyre_width on nomenklatura.nid = node_tyre_width.entity_id
         left join node__field_tire_profile node_tire_profile on nomenklatura.nid = node_tire_profile.entity_id
         left join node__field_load_index node_load_index on nomenklatura.nid = node_load_index.entity_id
         left join node__field_speed_index node_speed_index on nomenklatura.nid = node_speed_index.entity_id
         left join node__field_shipy node_shipy on nomenklatura.nid = node_shipy.entity_id
         left join node__field_runflat node_runflat on nomenklatura.nid = node_runflat.entity_id
         left join node__field_foto node_foto on nomenklatura.nid = node_foto.entity_id
         left join node__field_type node_type on nomenklatura.nid = node_type.entity_id

where node.type = 'tovar'
  and node_sku.title is not null
  and amount.field_amount_value >= @amount_limit
  and price.field_price_value * @margin >= @price_limit
  and node_sku.nid not in (select entity_id from node__field_freeze where field_freeze_value = 1)
  and taxonomy_brand.name is not null
  and taxonomy_model.name is not null
GROUP BY node_sku.title
-- ORDER BY brand ASC, model ASC
