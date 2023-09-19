
resource "kubernetes_deployment_v1" "mysql_deployment" {
  metadata {
    name = "mysql"
    labels = {
      app  = "mysql"
      tier = "backend"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }
      spec {
        volume {
          name = "mysql-dbcreation-script"
          config_map {
            name = "mysql-dbcreation-script"
          }
        }
        container {
          name  = "mysql"
          image = "mysql:5.6"
          port {
            container_port = 3306
          }
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "${local.db_secrets["password"]}" 
          }
          volume_mount {
            name       = "mysql-dbcreation-script"
            mount_path = "/docker-entrypoint-initdb.d"
          }
        }
      }
    }
  }
}            