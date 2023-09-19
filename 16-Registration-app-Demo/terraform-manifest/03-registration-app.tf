
locals {
  db_credentials = {
    endpoint    = var.db_endpoint
    db_username = var.db_username
    db_name     = var.db_name
    port        = var.port
    password    = random_password.password.result
  }
  db_secrets = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)
}

resource "aws_secretsmanager_secret" "this" {
  name                    = "kojitechs-mysql-secrets-mysql-${terraform.workspace}"
  description             = "Secret to manage mysql superuser password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(local.db_credentials)
}

resource "random_password" "password" {
  length  = 16
  special = false
}

data "aws_secretsmanager_secret_version" "this" {
  depends_on = [aws_secretsmanager_secret_version.this]
  secret_id = aws_secretsmanager_secret.this.id
}

resource "kubernetes_deployment_v1" "registration_app" {
  depends_on = [kubernetes_deployment_v1.mysql_deployment]

  metadata {
    name = "my-registration-app"
    labels = {
      app  = "registration-app"
      tier = "front-end"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "registration-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "registration-app"
        }
      }
      spec {
        container {
          name  = "registration-app"
          image = format("kojibello/kojitechs-registration-app:%s", var.image_version)
          port {
            container_port = "8080"
          }
          env {
            name  = "DB_HOSTNAME"
            value = "${local.db_secrets["endpoint"]}"  
          }
            env {
            name  = "DB_PORT"
            value = "${local.db_secrets["port"]}"  
          }
          env {
            name  = "DB_NAME"
            value = "${local.db_secrets["db_name"]}"  
          }
          env {
            name  = "DB_USERNAME"
            value = "${local.db_secrets["db_username"]}" 
          }
          env {
            name  = "DB_PASSWORD"
            value = "${local.db_secrets["password"]}" 
          }
        }
      }
    }
  }
}          

# resource "kubectl_manifest" "nginx_deployment" {
#   yaml_body = <<YAML
# ---  
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: my-helloword-deployment
#   labels:
#     app: my-helloword
#     tier: frontend
    
# spec:
#   replicas: 3
#   selector: 
#     matchLabels:
#      app: myapp 
#   template: 
#     metadata:
#       name: myapp-pod 
#       labels: # DICTIONARY
#         app: myapp
#     spec:
#       containers: 
#         - name: myapp 
#           image: kojibello/kojitechs-app:2.0.0 
#           ports: 
#             - containerPort: 80     
# ---
# YAML
# }