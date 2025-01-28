variable "location" {
  type        = string
  description = "Location of the resources."
}

variable "ssh_key_location" {
  type        = string
  description = "Location of the SSH key."
  default     = "~/.ssh/id_ed25519.pub"
}

variable "team_name" {
  type        = string
  description = "Name of the team."
  default     = "stephen"
}
