
resource "kubernetes_service_v1" "nlb_app_service" {
  metadata {
    name = "my-nlb-service"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }
  spec {
    selector = {
     app = kubernetes_deployment_v1.registration_app.spec.0.selector.0.match_labels.app
    }
    port {
      name = "http"
      port        = 80 
      target_port = 8080 
    }
    type = "LoadBalancer"
  }
}
