variable "afriyie_bucket" {
  type        = list(any)
  description = "this is the s3 bucket that'll store the statefile"
  default     = ["zayne.state.bucket", "boseme-bucket", "06-3-tier-architecture-implementation","terraform-remote-state-datasource",
  "create-eks-cluster"]
}