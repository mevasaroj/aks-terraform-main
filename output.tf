output "client_certificate" {
  sensitive = true
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
}
output "kube_config" {
  sensitive = true
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
}
output "fqdn" {
  sensitive = true
  value = azurerm_kubernetes_cluster.k8s.fqdn
}
