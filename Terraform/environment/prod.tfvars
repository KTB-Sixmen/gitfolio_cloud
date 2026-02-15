// 네트워크 변수
private_ips = {
  master1  = "10.0.4.5",
  master2  = "10.0.4.6",
  master3  = "10.0.4.7"
  ingress1 = "10.0.4.8",
  ingress2 = "10.0.4.9",
  ingress3 = "10.0.4.10",
  db1      = "10.0.4.11",
  db2      = "10.0.4.12",
  db3      = "10.0.4.13",

  jenkins = "10.0.107.10",
  argo    = "10.0.108.123"
}

// 로드 밸런서 변수
lb_type           = "application"
idle_timeout      = 900
delete_protection = false
target_port = {
  "http"     = 80
  "https"    = 443
  "back_alt" = 81
  "mysql"    = 3306
  "mongo"    = 27017
  "redis"    = 6379
  "fastapi"  = 8000
  "k8s"      = 6443
  "cicd"     = 8080
  "NodePort" = 30000
} // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
target_protocol    = "HTTP"
health_threshold   = 3
health_interval    = 30
health_matcher     = "200"
health_path        = "/" // 헬스 체크를 할 주소
health_port        = "traffic-port"
health_protocol    = "HTTP"
health_timeout     = 5
health_unthreshold = 2
