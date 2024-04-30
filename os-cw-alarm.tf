locals {
  thresholds = {
    FreeStorageSpaceThreshold            = floor(max(var.free_storage_space_threshold, 0))
    FreeStorageSpaceTotalThreshold       = floor(max(var.free_storage_space_total_threshold, 0))
    MinimumAvailableNodes                = floor(max(var.min_available_nodes, 0))
    ShardActiveNumberThreshold           = floor(max(var.shard_active_number_threshold, 0))
    ThreadpoolWriteQueueThreshold        = floor(max(var.threadpool_write_queue_threshold, 0))
    ThreadpoolWriteQueueThresholdAverage = floor(max(var.threadpool_search_queue_average_threshold, 0))
    ThreadpoolWriteQueueThresholdMax     = floor(max(var.threadpool_search_queue_max_threshold, 0))
    CPUUtilizationThreshold              = floor(min(max(var.cpu_utilization_threshold, 0), 100))
    JVMMemoryPressureThreshold           = floor(min(max(var.jvm_memory_pressure_threshold, 0), 100))
    MasterCPUUtilizationThreshold        = floor(min(max(coalesce(var.master_cpu_utilization_threshold, var.cpu_utilization_threshold), 0), 100))
    MasterJVMMemoryPressureThreshold     = floor(min(max(coalesce(var.master_jvm_memory_pressure_threshold, var.jvm_memory_pressure_threshold), 0), 100))
  }
}

resource "aws_cloudwatch_metric_alarm" "cluster_status_is_red" {
  count               = var.monitor_cluster_status_is_red ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-ClusterStatusIsRed${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_cluster_status_is_red_periods
  datapoints_to_alarm = var.alarm_cluster_status_is_red_periods
  metric_name         = "ClusterStatus.red"
  namespace           = "AWS/ES"
  period              = var.alarm_cluster_status_is_red_period
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Average OpenSearch cluster status is in red over last ${floor(var.alarm_cluster_status_is_red_periods * var.alarm_cluster_status_is_red_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cluster_status_is_yellow" {
  count               = var.monitor_cluster_status_is_yellow ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-ClusterStatusIsYellow${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_cluster_status_is_yellow_periods
  datapoints_to_alarm = var.alarm_cluster_status_is_yellow_periods
  metric_name         = "ClusterStatus.yellow"
  namespace           = "AWS/ES"
  period              = var.alarm_cluster_status_is_yellow_period
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Average OpenSearch cluster status is in yellow over last ${floor(var.alarm_cluster_status_is_yellow_periods * var.alarm_cluster_status_is_yellow_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  count               = var.monitor_free_storage_space_too_low ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-FreeStorageSpaceTooLow${var.alarm_name_postfix}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_free_storage_space_too_low_periods
  datapoints_to_alarm = var.alarm_free_storage_space_too_low_periods
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/ES"
  period              = var.alarm_free_storage_space_too_low_period
  statistic           = "Minimum"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Minimum free disk space on a single node under ${local.thresholds["FreeStorageSpaceThreshold"]}MB for the last ${floor(var.alarm_free_storage_space_too_low_periods * var.alarm_free_storage_space_too_low_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_total_too_low" {
  # If the user specified how many nodes, and they want to create this alert (disabled by default)
  count               = var.monitor_free_storage_space_total_too_low ? var.min_available_nodes > 0 ? 1 : 0 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-FreeStorageSpaceTotalTooLow${var.alarm_name_postfix}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_free_storage_space_total_too_low_periods
  datapoints_to_alarm = var.alarm_free_storage_space_total_too_low_periods
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/ES"
  period              = var.alarm_free_storage_space_total_too_low_period
  statistic           = "Sum"
  threshold           = local.thresholds["FreeStorageSpaceTotalThreshold"]
  alarm_description   = "Total aggregate free disk space under ${local.thresholds["FreeStorageSpaceTotalThreshold"]}MB for the last ${floor(var.alarm_free_storage_space_total_too_low_periods * var.alarm_free_storage_space_total_too_low_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}


resource "aws_cloudwatch_metric_alarm" "cluster_index_writes_blocked" {
  count               = var.monitor_cluster_index_writes_blocked ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-ClusterIndexWritesBlocked${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_cluster_index_writes_blocked_periods
  datapoints_to_alarm = var.alarm_cluster_index_writes_blocked_periods
  metric_name         = "ClusterIndexWritesBlocked"
  namespace           = "AWS/ES"
  period              = var.alarm_cluster_index_writes_blocked_period
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "OpenSearch index writes being blocker over last ${floor(var.alarm_cluster_index_writes_blocked_periods * var.alarm_cluster_index_writes_blocked_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "insufficient_available_nodes" {
  count               = var.monitor_min_available_nodes ? (var.min_available_nodes > 0 ? 1 : 0) : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-InsufficientAvailableNodes${var.alarm_name_postfix}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.alarm_min_available_nodes_periods
  datapoints_to_alarm = var.alarm_min_available_nodes_periods
  metric_name         = "Nodes"
  namespace           = "AWS/ES"
  period              = var.alarm_min_available_nodes_period
  statistic           = "Minimum"
  threshold           = local.thresholds["MinimumAvailableNodes"]
  alarm_description   = "OpenSearch nodes minimum < ${local.thresholds["MinimumAvailableNodes"]} for ${floor(var.alarm_min_available_nodes_periods * var.alarm_min_available_nodes_period / 60)} minutes(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "automated_snapshot_failure" {
  count               = var.monitor_automated_snapshot_failure ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-AutomatedSnapshotFailure${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_automated_snapshot_failure_periods
  datapoints_to_alarm = var.alarm_automated_snapshot_failure_periods
  metric_name         = "AutomatedSnapshotFailure"
  namespace           = "AWS/ES"
  period              = var.alarm_automated_snapshot_failure_period
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "OpenSearch automated snapshot failed over last ${floor(var.alarm_automated_snapshot_failure_periods * var.alarm_automated_snapshot_failure_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count               = var.monitor_cpu_utilization_too_high ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-CPUUtilizationTooHigh${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_cpu_utilization_too_high_periods
  datapoints_to_alarm = var.alarm_cpu_utilization_too_high_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ES"
  period              = var.alarm_cpu_utilization_too_high_period
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilizationThreshold"]
  alarm_description   = "Average OpenSearch cluster CPU utilization above ${local.thresholds["CPUUtilizationThreshold"]} over last ${floor(var.alarm_cpu_utilization_too_high_periods * var.alarm_cpu_utilization_too_high_period / 60)} minute(s) too high"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "jvm_memory_pressure_too_high" {
  count               = var.monitor_jvm_memory_pressure_too_high ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-JVMMemoryPressure${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_jvm_memory_pressure_too_high_periods
  datapoints_to_alarm = var.alarm_jvm_memory_pressure_too_high_periods
  metric_name         = "JVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = var.alarm_jvm_memory_pressure_too_high_period
  statistic           = "Maximum"
  threshold           = local.thresholds["JVMMemoryPressureThreshold"]
  alarm_description   = "OpenSearch JVM memory pressure is over ${local.thresholds["JVMMemoryPressureThreshold"]} over the last ${floor(var.alarm_jvm_memory_pressure_too_high_periods * var.alarm_jvm_memory_pressure_too_high_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_cpu_utilization_too_high" {
  count               = var.monitor_master_cpu_utilization_too_high ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-MasterCPUUtilizationTooHigh${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_master_cpu_utilization_too_high_periods
  datapoints_to_alarm = var.alarm_master_cpu_utilization_too_high_periods
  metric_name         = "MasterCPUUtilization"
  namespace           = "AWS/ES"
  period              = var.alarm_master_cpu_utilization_too_high_period
  statistic           = "Average"
  threshold           = local.thresholds["MasterCPUUtilizationThreshold"]
  alarm_description   = "Average OpenSearch cluster master CPU utilization above ${local.thresholds["MasterCPUUtilizationThreshold"]} over last ${floor(var.alarm_master_cpu_utilization_too_high_periods * var.alarm_master_cpu_utilization_too_high_period / 60)} minute(s) too high"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_jvm_memory_pressure_too_high" {
  count               = var.monitor_master_jvm_memory_pressure_too_high ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-MasterJVMMemoryPressure${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_master_jvm_memory_pressure_too_high_periods
  datapoints_to_alarm = var.alarm_master_jvm_memory_pressure_too_high_periods
  metric_name         = "MasterJVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = var.alarm_master_jvm_memory_pressure_too_high_period
  statistic           = "Maximum"
  threshold           = local.thresholds["MasterJVMMemoryPressureThreshold"]
  alarm_description   = "OpenSearch JVM memory pressure is over ${local.thresholds["MasterJVMMemoryPressureThreshold"]} over the last ${floor(var.alarm_master_jvm_memory_pressure_too_high_periods * var.alarm_master_jvm_memory_pressure_too_high_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "kms_key_error" {
  count               = var.monitor_kms ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-KMSKeyError${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_kms_periods
  datapoints_to_alarm = var.alarm_kms_periods
  metric_name         = "KMSKeyError"
  namespace           = "AWS/ES"
  period              = var.alarm_kms_period
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "OpenSearch KMS Key Error failed over last ${floor(var.alarm_kms_periods * var.alarm_kms_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "notBreaching"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "kms_key_inaccessible" {
  count               = var.monitor_kms ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-KMSKeyInaccessible${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_kms_periods
  datapoints_to_alarm = var.alarm_kms_periods
  metric_name         = "KMSKeyInaccessible"
  namespace           = "AWS/ES"
  period              = var.alarm_kms_period
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "OpenSearch KMS Key Inaccessible failed over last ${floor(var.alarm_kms_periods * var.alarm_kms_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "notBreaching"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}


resource "aws_cloudwatch_metric_alarm" "shards_active_too_high" {
  count               = var.monitor_shard ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-ShardActiveNumberTooHigh${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_shard_active_number_too_high_periods
  datapoints_to_alarm = var.alarm_shard_active_number_too_high_periods
  metric_name         = "Shards.active"
  namespace           = "AWS/ES"
  period              = var.alarm_shard_active_number_too_high_period
  statistic           = "Maximum"
  threshold           = local.thresholds["ShardActiveNumberThreshold"]
  alarm_description   = "OpenSearch active shard number is over ${local.thresholds["ShardActiveNumberThreshold"]} over the last ${floor(var.alarm_shard_active_number_too_high_periods * var.alarm_shard_active_number_too_high_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "unreachable_master_node" {
  count               = var.monitor_unreachable_master_node ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-MasterNodeUnreachable${var.alarm_name_postfix}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.alarm_unreachable_master_node_periods
  datapoints_to_alarm = var.alarm_unreachable_master_node_periods
  metric_name         = "MasterReachableFromNode"
  namespace           = "AWS/ES"
  period              = var.alarm_unreachable_master_node_period
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "OpenSearch Master Node is unreachable over the last ${floor(var.alarm_unreachable_master_node_periods * var.alarm_unreachable_master_node_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

# CloudWatch Alarm for ThreadpoolWriteQueue
resource "aws_cloudwatch_metric_alarm" "threadpool_write_queue_too_high" {
  count               = var.monitor_threadpool_write_queue ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-ThreadpoolWriteQueueTooHigh${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_threadpool_write_queue_too_high_periods
  datapoints_to_alarm = var.alarm_threadpool_write_queue_too_high_periods
  metric_name         = "ThreadpoolWriteQueue"
  namespace           = "AWS/ES"
  period              = var.alarm_threadpool_write_queue_too_high_period
  statistic           = "Average"
  threshold           = local.thresholds["ThreadpoolWriteQueueThreshold"]
  alarm_description   = "OpenSearch is experiencing high indexing concurrency over the last ${floor(var.alarm_threadpool_write_queue_too_high_periods * var.alarm_threadpool_write_queue_too_high_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "threadpool_search_queue_average" {
  count               = var.monitor_threadpool_search_queue ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-ThreadpoolSearchQueueAverageTooHigh${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_threadpool_search_queue_too_high_periods
  datapoints_to_alarm = var.alarm_threadpool_search_queue_too_high_periods
  metric_name         = "ThreadpoolSearchQueue"
  namespace           = "AWS/ES"
  period              = var.alarm_threadpool_search_queue_too_high_period
  statistic           = "Average"
  threshold           = local.thresholds["ThreadpoolWriteQueueThresholdAverage"]
  alarm_description   = "OpenSearch is experiencing high average searching concurrency over the last ${floor(var.alarm_threadpool_search_queue_too_high_periods * var.alarm_threadpool_search_queue_too_high_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "threadpool_search_queue_max" {
  count               = var.monitor_threadpool_search_queue ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-ThreadpoolSearchQueueMaxTooHigh${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_threadpool_search_queue_too_high_periods
  datapoints_to_alarm = var.alarm_threadpool_search_queue_too_high_periods
  metric_name         = "ThreadpoolSearchQueue"
  namespace           = "AWS/ES"
  period              = var.alarm_threadpool_search_queue_too_high_period
  statistic           = "Maximum"
  threshold           = local.thresholds["ThreadpoolWriteQueueThresholdMax"]
  alarm_description   = "OpenSearch is experiencing high maximum searching concurrency over the last ${floor(var.alarm_threadpool_search_queue_too_high_periods * var.alarm_threadpool_search_queue_too_high_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.default.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "threadpool_search_rejected" {
  count               = var.monitor_threadpool_search_rejected ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-ThreadpoolSearchRejected${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_threadpool_search_rejected_periods
  datapoints_to_alarm = var.alarm_threadpool_search_rejected_periods
  threshold           = var.threadpool_write_rejected_threshold
  alarm_description   = "OpenSearch is experiencing threadpool write rejected over the last ${floor(var.alarm_threadpool_search_rejected_periods * var.alarm_threadpool_search_rejected_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags


  # Use a metric query to calculate the difference
  metric_query {
    id          = "e1"
    expression  = "DIFF(m1)"
    label       = "Difference in ThreadpoolSearchRejected"
    return_data = true
  }

  metric_query {
    id          = "m1"
    return_data = false
    metric {
      metric_name = "ThreadpoolSearchRejected"
      namespace   = "AWS/ES"
      stat        = "Sum"
      unit        = "Count"
      period      = var.alarm_threadpool_search_rejected_period

      dimensions = {
        DomainName = var.domain_name
        ClientId   = data.aws_caller_identity.default.account_id
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "threadpool_write_rejected" {
  count               = var.monitor_threadpool_write_rejected ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}OpenSearch-ThreadpoolWriteRejected${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_threadpool_write_rejected_periods
  datapoints_to_alarm = var.alarm_threadpool_write_rejected_periods
  threshold           = var.threadpool_write_rejected_threshold
  alarm_description   = "OpenSearch is experiencing threadpool write rejected over the last ${floor(var.alarm_threadpool_write_rejected_periods * var.alarm_threadpool_write_rejected_period / 60)} minute(s)"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"
  tags                = var.tags


  # Use a metric query to calculate the difference
  metric_query {
    id          = "e1"
    expression  = "DIFF(m1)"
    label       = "Difference in ThreadpoolWriteRejected"
    return_data = true
  }

  metric_query {
    id          = "m1"
    return_data = false
    metric {
      metric_name = "ThreadpoolWriteRejected"
      namespace   = "AWS/ES"
      stat        = "Sum"
      unit        = "Count"
      period      = var.alarm_threadpool_write_rejected_period

      dimensions = {
        DomainName = var.domain_name
        ClientId   = data.aws_caller_identity.default.account_id
      }
    }
  }
}
