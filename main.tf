resource "aws_key_pair" "aws-key" {
    key_name = "aws-key"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
  
}