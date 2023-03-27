#!/bin/bash

drush sql-query "update node__field_mrc set node__field_mrc.field_mrc_value=0;"
drush sql-query "update node_revision__field_mrc set node_revision__field_mrc.field_mrc_value=0;"
drush cr
