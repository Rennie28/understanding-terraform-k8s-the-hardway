
output "alb_dnsname" {
    value = format("http://%s", kubernetes_service_v1.alb_app_service.status.0.load_balancer.0.ingress.0.hostname)
}

output "nlb_dnsname" {
    value = format("http://%s", kubernetes_service_v1.nlb_app_service.status.0.load_balancer.0.ingress.0.hostname)
}