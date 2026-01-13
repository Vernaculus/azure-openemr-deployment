variable "alert_email" {
  type        = string
  description = "Email address for budget alerts and monitoring notifications"
  sensitive   = true # Marks this as sensitive so it won't show in plan output
}

