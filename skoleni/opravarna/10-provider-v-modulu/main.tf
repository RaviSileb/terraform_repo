module "site" {
  source   = "./modul"
  for_each = toset(["dev", "prod"])

  prostredi = each.key
}
