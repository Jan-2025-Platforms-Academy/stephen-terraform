output "load_balancer_ip_address" {
  value = "http://${azurerm_public_ip.load_balacer.ip_address}"
}
