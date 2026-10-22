output "nazvy" {
  description = "Názvy kontejnerů backendu (DNS jména v síti)."
  value       = docker_container.backend[*].name
}
