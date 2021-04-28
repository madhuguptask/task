data "aws_caller_identity" "current" {}
locals {
  attributes = concat(
  [
    {
      name = var.range_key
      type = var.range_key_type
    },
    {
      name = var.hash_key
      type = var.hash_key_type
    }
  ],
  var.dynamodb_attributes
  )

  # Remove the first map from the list if no `range_key` is provided
  from_index = length(var.range_key) > 0 ? 0 : 1

  attributes_final = slice(local.attributes, local.from_index, length(local.attributes))
}

resource "null_resource" "global_secondary_index_names" {
  count = (var.enabled ? 1 : 0) * length(var.global_secondary_index_map)

  # Convert the multi-item `global_secondary_index_map` into a simple `map` with just one item `name` since `triggers` does not support `lists` in `maps` (which are used in `non_key_attributes`)
  # See `examples/complete`
  # https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html#non_key_attributes-1
  triggers = {
    "name" = var.global_secondary_index_map[count.index]["name"]
  }
}

resource "null_resource" "local_secondary_index_names" {
  count = (var.enabled ? 1 : 0) * length(var.local_secondary_index_map)

  # Convert the multi-item `local_secondary_index_map` into a simple `map` with just one item `name` since `triggers` does not support `lists` in `maps` (which are used in `non_key_attributes`)
  # See `examples/complete`
  # https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html#non_key_attributes-1
  triggers = {
    "name" = var.local_secondary_index_map[count.index]["name"]
  }
}

resource "aws_dynamodb_table" "dynamodb" {
  count            = var.enabled ? 1 : 0
  name             = var.name
  billing_mode     = var.billing_mode
  read_capacity    = var.dynamodb_read_capacity
  write_capacity   = var.dynamodb_write_capacity
  hash_key         = var.hash_key
  range_key        = var.range_key
  stream_enabled   = var.enable_streams
  stream_view_type = var.enable_streams ? var.stream_view_type : ""

  server_side_encryption {
    enabled = var.enable_encryption
//    enabled = var.enable_encryption == false ? false : true
//    kms_key_arn = var.kms_key_arn
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity
    ]
  }

  dynamic "attribute" {
    for_each = local.attributes_final
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index_map
    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = global_secondary_index.value.name
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_index_map
    content {
      name               = local_secondary_index.value.name
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
    }
  }

  ttl {
    attribute_name = var.ttl_attribute
    enabled        = var.ttl_attribute != "" && var.ttl_attribute != null ? true : false
  }

  tags = var.tags
}
resource "aws_appautoscaling_target" "read-target" {
  max_capacity       = var.dynamodb_max_read_capacity
  min_capacity       = var.dynamodb_read_capacity
  resource_id        = "table/${var.name}"
  role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}
resource "aws_appautoscaling_policy" "read-policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read-target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read-target.resource_id
  scalable_dimension = aws_appautoscaling_target.read-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.read-target.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = var.read_target_value
  }
}
resource "aws_appautoscaling_target" "write-target" {
  max_capacity       = var.dynamodb_max_write_capacity
  min_capacity       = var.dynamodb_write_capacity
  resource_id        = "table/${var.name}"
  role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}
resource "aws_appautoscaling_policy" "write-policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write-target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write-target.resource_id
  scalable_dimension = aws_appautoscaling_target.write-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.write-target.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = var.write_target_value
  }
}