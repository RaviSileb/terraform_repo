variable "docker_host" {
  type    = string
  default = null
}

variable "sluzby_seznam" {
  description = "Názvy služeb (část A – verze s count)."
  type        = list(string)
  default     = ["web", "api", "docs"]
}

# Část B: nahraďte sluzby_seznam proměnnou "sluzby" typu map(object({...})) – viz README.
