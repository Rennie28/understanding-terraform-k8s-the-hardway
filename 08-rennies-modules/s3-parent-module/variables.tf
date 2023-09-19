
variable "bucket_name" {
    type = string
    description = "s3 bucket name"
}

variable "tags" {
    type = map
    description = "tag value"
    default = {}
}

variable "versioning" {
    type = string
    description = "Do you want to enable versioning? [Enabled Suspended Disabled]"
}