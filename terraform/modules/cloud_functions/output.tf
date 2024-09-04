output "function_names" {
  description = "Map of function names"
  value       = { for idx, f in var.functions : f.name => google_cloudfunctions2_function.function[idx].name }
}

output "function_urls" {
  value = {
    for idx, func in google_cloudfunctions2_function.function :
    func.name => func.service_config[0].uri
  }
}