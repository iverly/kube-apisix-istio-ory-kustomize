output "cluster_endpoint" {
  value = k3d_cluster.this.credentials[0].host
}

output "cluster_cluster_ca_certificate" {
  value = k3d_cluster.this.credentials[0].cluster_ca_certificate
}

output "cluster_client_certificate" {
  value = k3d_cluster.this.credentials[0].client_certificate
}

output "cluster_client_key" {
  value = k3d_cluster.this.credentials[0].client_key
}
