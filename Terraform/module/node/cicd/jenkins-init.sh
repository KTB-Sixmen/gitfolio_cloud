# Java 설치 (Jenkins 필요조건)
sudo yum update -y
sudo yum install java-17-amazon-corretto -y

# Jenkins 리포지토리 설정
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Jenkins 설치
sudo yum install jenkins -y

# Jenkins 서비스 시작
sudo systemctl start jenkins
sudo systemctl enable jenkins