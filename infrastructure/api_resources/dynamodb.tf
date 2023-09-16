/*
import {
    to = aws_dynamodb_table.dynamo_update_dynamo_db
    id = "visitors_counter"
}
*/

resource "aws_dynamodb_table" "dynamo_update_dynamo_db" {
  billing_mode                = "PROVISIONED"
  deletion_protection_enabled = false
  hash_key                    = "count id"
  name                        = "visitors_counter"
  range_key                   = null
  read_capacity               = 1
  restore_date_time           = null
  restore_source_name         = null
  restore_to_latest_time      = null
  stream_enabled              = false
  stream_view_type            = null
  table_class                 = "STANDARD"
  tags                        = {}
  tags_all                    = {}
  write_capacity              = 1
  attribute {
    name = "count id"
    type = "N"
  }
  point_in_time_recovery {
    enabled = false
  }
  ttl {
    attribute_name = ""
    enabled        = false
  }
}