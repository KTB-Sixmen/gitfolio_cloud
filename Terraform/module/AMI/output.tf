output "amazon_linux_id" {
    value = data.aws_ami.al2023.id
}

output "ubuntu_id" {
    value = data.aws_ami.ubuntu.id
}
