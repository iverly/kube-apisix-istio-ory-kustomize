output "cluster_config_endpoint" {
  value = k3d_cluster.this.credentials[0].host
}

output "cluster_config_cluster_ca_certificate" {
  value = k3d_cluster.this.credentials[0].cluster_ca_certificate
}

output "cluster_config_client_certificate" {
  value = k3d_cluster.this.credentials[0].client_certificate
}

output "cluster_config_client_key" {
  value = k3d_cluster.this.credentials[0].client_key
}
