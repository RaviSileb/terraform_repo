resource "local_file" "readme" {
  filename = "${path.module}/vystup/README.txt"
  content  = "Dokumentace projektu A"
}
