variable "project" {}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "preemptible" {
  default = true
}

variable "node_count" {
  default = 1
}

variable "cluster_name" {
  default = "playground"
}
