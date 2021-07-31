output "instance_group_id" {
    value = google_compute_instance_group.webservers.id
}

output "instances" {
    value = google_compute_instance.vm_instance
}