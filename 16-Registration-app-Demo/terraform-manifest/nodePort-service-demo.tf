
resource "kubernetes_service_v1" "nodeport_app_service" {
  metadata {
    name = "my-nodeport-service"
  }
  spec {
    selector = {
     app = kubernetes_deployment_v1.registration_app.spec.0.selector.0.match_labels.app
    }
    port {
      name = "http"
      port        = 80 
      target_port = 8080 
      # node_port = ""
    }
    type = "NodePort"
  }
}

