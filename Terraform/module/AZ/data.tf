data "aws_availability_zones" "selected" {
  state = "available"

  filter {
    name   = "zone-name"
    values = ["ap-northeast-2a", "ap-northeast-2c"]  # 원하는 특정 가용 영역 이름
  }
}