
resource "kubernetes_config_map_v1" "config_map" {
  metadata {
    name =  "mysql-dbcreation-script" 
  }
  data = {
    "webappdb.sql" = "${file("${path.module}/file/webappdb.sql")}"
  }
}