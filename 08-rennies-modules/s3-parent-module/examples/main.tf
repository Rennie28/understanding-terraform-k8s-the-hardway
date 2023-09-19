############################
#child's module
############################

module "s3" {
   # source = "/Users/renniesakyi/Downloads/scr/understanding-terraform-k8s-the-hardway/08-rennies-modules/s3-parent-module" #provide absolute path or relative path
    source = "../"

    bucket_name = "test.bucket.rennies"
    versioning = "Enabled"
}