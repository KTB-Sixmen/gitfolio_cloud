output "az" {
    value = data.aws_availability_zones.selected.names[*]
}