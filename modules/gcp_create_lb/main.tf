resource "google_compute_global_address" "default" {
  name         = "global-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_url_map" "urlmap" {
  name        = "urlmap"
  default_service = google_compute_backend_service.webservers_service.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "all"
  }
    path_matcher {
    name            = "all"
    default_service = google_compute_backend_service.webservers_service.self_link

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.webservers_service.self_link
    }
  }
}

resource "google_compute_target_http_proxy" "http" {
  name    = "http-proxy"
  url_map = google_compute_url_map.urlmap.self_link
}

resource "google_compute_backend_service" "webservers_service" {
  name      = "webservers-service"
  port_name = "http"
  protocol  = "HTTP"

  backend {
    group = var.instance_group_id
  }

  health_checks = [
    google_compute_health_check.webserves_health.id,
  ]
}

resource "google_compute_health_check" "webserves_health" {
  name         = "webservers-health"
  check_interval_sec = 1
  timeout_sec        = 1

  http_health_check {
    port = "80"
  }
}

resource "google_compute_global_forwarding_rule" "http" {
  provider   = google-beta
  name       = "http-rule"
  target     = google_compute_target_http_proxy.http.self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"

  depends_on = [google_compute_global_address.default]
}

resource "google_dns_managed_zone" "parent-zone" {
  provider = "google-beta"
  name        = "zone"
  dns_name    = "myzone.hashicorptest.com"
  description = "Test Description"
}

resource "google_dns_record_set" "dns" {
  name = "test-record.myzone.hashicorptest.com"
  type = "A"
  ttl  = 60

  managed_zone = google_dns_managed_zone.parent-zone.name

  rrdatas = [google_compute_global_address.default.address]
}