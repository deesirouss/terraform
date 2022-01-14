module "website_s3_bucket" {
  #path to reusable code of modules
  source = "./modules/s3_static_webhost"
  bucket_name = var.my_s3_bucket
  tags = var.my_s3_tags
}
# Upload an object
resource "aws_s3_bucket_object" "object" {

  for_each = fileset("myfiles/", "*")
  
  bucket = module.website_s3_bucket.name

  key    = each.value

  acl    = "public-read"  # or can be "private"

  source = "myfiles/${each.value}"

  etag = filemd5("myfiles/${each.value}")

}
