#################
# Configuration #
#################

# Add module-specific variables here

########
# Tags #
########
# variable "business_unit" {
#   description = "Area of the MOJ responsible for the service"
#   type        = string
# }

# variable "application" {
#   description = "Application name"
#   type        = string
# }

# variable "is_production" {
#   description = "Whether this is used for production or not"
#   type        = string
# }

# variable "team_name" {
#   description = "Team name"
#   type        = string
# }

# variable "namespace" {
#   description = "Namespace name"
#   type        = string
# }

# variable "environment_name" {
#   description = "Environment name"
#   type        = string
# }

# variable "infrastructure_support" {
#   description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
#   type        = string
# }


variable "domain_name" {
  description = "The Elasticsearch domain name you want to monitor"
  type        = string
}

variable "alarm_name_prefix" {
  description = "Alarm name prefix, used in the naming of alarms created"
  type        = string
  default     = ""
}

variable "alarm_name_postfix" {
  description = "Alarm name suffix, used in the naming of alarms created"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}


########################################
# SNS-Related Variables
########################################
variable "sns_topic" {
  description = "SNS topic you want to specify. If leave empty, it will use a prefix and a timestampe appended"
  type        = string
  default     = ""
}


########################################
# Boolean flagging to disable specific alarms not interested in using
########################################
variable "monitor_cluster_status_is_red" {
  description = "Enable monitoring of cluster status is in red"
  type        = bool
  default     = true
}

variable "monitor_cluster_status_is_yellow" {
  description = "Enable monitoring of cluster status is in yellow"
  type        = bool
  default     = true
}

variable "monitor_free_storage_space_too_low" {
  description = "Enable monitoring of cluster per-node free storage is too low"
  type        = bool
  default     = true
}

variable "monitor_free_storage_space_total_too_low" {
  description = "Enable monitoring of cluster total free storage is too low.  Disabled by default, if you set this you must set free_storage_space_total_threshold also"
  type        = bool
  default     = false
}

variable "monitor_cluster_index_writes_blocked" {
  description = "Enable monitoring of cluster index writes being blocked"
  type        = bool
  default     = true
}

variable "monitor_min_available_nodes" {
  description = "Enable monitoring of minimum available nodes"
  type        = bool
  default     = true
}

variable "monitor_automated_snapshot_failure" {
  description = "Enable monitoring of automated snapshot failure"
  type        = bool
  default     = true
}

variable "monitor_cpu_utilization_too_high" {
  description = "Enable monitoring of CPU utilization is too high"
  type        = bool
  default     = true
}

variable "monitor_jvm_memory_pressure_too_high" {
  description = "Enable monitoring of JVM memory pressure is too high"
  type        = bool
  default     = true
}

variable "monitor_kms" {
  description = "Enable monitoring of KMS-related metrics.  Only enable this when using KMS with ElasticSearch"
  type        = bool
  default     = false
}

variable "monitor_master_cpu_utilization_too_high" {
  description = "Enable monitoring of CPU utilization of master nodes are too high. Only enable this when dedicated master is enabled"
  type        = bool
  default     = false
}

variable "monitor_master_jvm_memory_pressure_too_high" {
  description = "Enable monitoring of JVM memory pressure of master nodes are too high. Only enable this wwhen dedicated master is enabled"
  type        = bool
  default     = false
}

variable "monitor_shard" {
  description = "Enable monitoring of sharding of master nodes are too high. Only enable this wwhen dedicated master is enabled"
  type        = bool
  default     = true
}

########################################
# Evaluation period time length (in seconds) for alarms
########################################
variable "alarm_min_available_nodes_period" {
  description = "The period of the minimum available nodes should the statistics be applied in seconds"
  type        = number
  default     = 86400
}

variable "alarm_cluster_status_is_red_period" {
  description = "The period of the cluster status is in red should the statistics be applied in seconds"
  type        = number
  default     = 60
}

variable "alarm_cluster_status_is_yellow_period" {
  description = "The period of the cluster status is in yellow should the statistics be applied in seconds"
  type        = number
  default     = 60
}

variable "alarm_free_storage_space_too_low_period" {
  description = "The period of the per-node free storage is too low should the statistics be applied in seconds"
  type        = number
  default     = 60
}

variable "alarm_free_storage_space_total_too_low_period" {
  description = "The period of the total cluster free storage is too low should the statistics be applied in seconds"
  type        = number
  default     = 60
}

variable "alarm_cluster_index_writes_blocked_period" {
  description = "The period of the cluster index writes being blocked should the statistics be applied in seconds"
  type        = number
  default     = 300
}

variable "alarm_automated_snapshot_failure_period" {
  description = "The period of the automated snapshot failure should the statistics be applied in seconds"
  type        = number
  default     = 60
}

variable "alarm_cpu_utilization_too_high_period" {
  description = "The period of the CPU utilization is too high should the statistics be applied in seconds"
  type        = number
  default     = 900
}

variable "alarm_jvm_memory_pressure_too_high_period" {
  description = "The period of the JVM memory pressure is too high should the statistics be applied in seconds"
  type        = number
  default     = 900
}

variable "alarm_kms_period" {
  description = "The period of the KMS-related metrics should the statistics be applied in seconds"
  type        = number
  default     = 60
}

variable "alarm_master_cpu_utilization_too_high_period" {
  description = "The period of the CPU utilization of master nodes are too high should the statistics be applied in seconds"
  type        = number
  default     = 900
}

variable "alarm_master_jvm_memory_pressure_too_high_period" {
  description = "The period of the JVM memory pressure of master nodes are too high should the statistics be applied in seconds"
  type        = number
  default     = 900
}

variable "alarm_shard_active_number_too_high_period" {
  description = "The period of the JVM memory pressure of master nodes are too high should the statistics be applied in seconds"
  type        = number
  default     = 60
}

########################################
# Alarm thresholds
########################################
variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in megabytes.  This is per-node."
  type        = number
  default     = 20480 ## 20 Gigabyte in MegaByte
}

variable "free_storage_space_total_threshold" {
  description = "The minimum amount of available storage space in megabytes aggregated across your cluster (for multi-node).  This is an aggregate, typically use (free_storage_space_threshold * min_available_nodes)"
  type        = number
  default     = 20480 ## 20 Gigabyte in MegaByte
}

variable "min_available_nodes" {
  description = "The minimum available (reachable) nodes to have, set to non-zero to enable"
  type        = number
  default     = 0
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization"
  type        = number
  default     = 80 # 80 percent in Percentage
}

variable "jvm_memory_pressure_threshold" {
  description = "The maximum percentage of the Java heap used for all data nodes in the cluster"
  type        = number
  default     = 80 # 80 percent in Percentage
}

variable "master_cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization of master nodes"
  type        = number
  default     = 80 # default same as `cpu_utilization_threshold` in Percentage
}

variable "master_jvm_memory_pressure_threshold" {
  description = "The maximum percentage of the Java heap used for master nodes in the cluster"
  type        = number
  default     = 80 # default same as `jvm_memory_pressure_threshold` in Percentage
}

variable "shard_active_number_threshold" {
  description = "The maximum number of active primary and replica shards number"
  type        = number
  default     = 30000
}

########################################
# Evaluation periods for alarms
########################################
variable "alarm_cluster_status_is_red_periods" {
  description = "The number of periods to alert that cluster status is red.  Default: 1, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 1
}

variable "alarm_cluster_status_is_yellow_periods" {
  description = "The number of periods to alert that cluster status is yellow.  Default: 1, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 1
}

variable "alarm_free_storage_space_too_low_periods" {
  description = "The number of periods to alert that the per-node free storage space is too low.  Default: 1, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 1
}

variable "alarm_free_storage_space_total_too_low_periods" {
  description = "The number of periods to alert that total cluster free storage space is too low.  Default: 1, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 1
}

variable "alarm_cluster_index_writes_blocked_periods" {
  description = "The number of periods to alert that cluster index writes are blocked.  Default: 1, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 1
}

variable "alarm_min_available_nodes_periods" {
  description = "The number of periods to alert that minimum number of available nodes dropped below a threshold.  Default: 1, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 1
}

variable "alarm_automated_snapshot_failure_periods" {
  description = "The number of periods to alert that automatic snapshots failed.  Default: 1, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 1
}

variable "alarm_cpu_utilization_too_high_periods" {
  description = "The number of periods to alert that CPU usage is too high.  Default: 3, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 3
}

variable "alarm_jvm_memory_pressure_too_high_periods" {
  description = "The number of periods which it must be in the alarmed state to alert"
  type        = number
  default     = 1
}

variable "alarm_master_cpu_utilization_too_high_periods" {
  description = "The number of periods to alert that masters CPU usage is too high.  Default: 3, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 3
}

variable "alarm_master_jvm_memory_pressure_too_high_periods" {
  description = "The number of periods which it must be in the alarmed state to alert"
  type        = number
  default     = 1
}

variable "alarm_kms_periods" {
  description = "The number of periods to alert that kms has failed.  Default: 1, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 1
}

variable "alarm_shard_active_number_too_high_periods" {
  description = "The number of periods to alert that active shard number is too high.  Default: 1, raise this to be less noisy, as this can occur often for only 1 period"
  type        = number
  default     = 1
}
