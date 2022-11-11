### AWS Variables ###
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}
variable "deployment_name" {
  description = "Name for this deployment"
  type        = string
  default     = "demo"
}

### Node Group One ###
variable "node_group_one_instance_types" {
  description = "Instance types to use in node group"
  type        = list
  default     = ["m5.4xlarge"]
}
variable "node_group_one_min_size" {
  description = "Minimum number of nodes in node group"
  type        = number
  default     = 1
}
variable "node_group_one_max_size" {
  description = "Maximum number of nodes in node group"
  type        = number
  default     = 6
}
variable "node_group_one_desired_size" {
  description = "Desired number of nodes in node group -- unused by default as Cluster Autoscaler is enabled. See README for details."
  type        = number
  default     = 3
}

### Sourcegraph Variables ###
variable "sourcegraph_version" {
  description = "Version number of Sourcegraph chart to install -- ignored if using local chart"
  type        = string
  default     = "4.1.3"
}
variable "use_remote_charts" {
  description = "Use the remote charts from https://helm.sourcegraph.com/release. This enables the searcher and symbols pods to use ephemeral storage as dictated in ./resources/override.yaml"
  type        = bool
  default     = false
}