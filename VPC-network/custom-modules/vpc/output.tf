## Define each output whose value you want to use in other modules or in root module (Based on your requirements)

output "vpc-id" {
  value = google_compute_network.vpc_network.id
}
