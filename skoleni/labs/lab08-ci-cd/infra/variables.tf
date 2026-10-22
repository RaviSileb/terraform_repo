variable "verze_aplikace" {
  description = "Verze aplikace, kterou pipeline „nasazuje“."
  type        = string
  default     = "1.0.0"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+$", var.verze_aplikace))
    error_message = "verze_aplikace musí být ve formátu SemVer, např. 1.2.3."
  }
}
