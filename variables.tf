variable "project_name" {
  description = "Project Name - will prefex all generated resource names"
  default     = "CP-Lab"
}

variable "location" {
  default = "West US 2"
}

variable "gateway_int_ip" {
  default = "10.99.1.10"
}

variable "vnet_cidr" {
  description = "CIDR block for Virtual Network"
}

variable "Demo_tag" {
  description = ""
}

variable "GW_int_priv_IP" {
  description = ""
}

variable "GW_ext_priv_IP" {
  description = ""
}

variable "External_subnet" {
  description = ""
}

variable "Gateway_subnet" {
  description = ""
}

variable "Internal_Subnet" {
  description = ""
}

variable "DMZ1_subnet" {
  description = ""
}

variable "DMZ2_subnet" {
  description = ""
}

variable "DMZ3_subnet" {
  description = "CIDR block for DMZ3 Subnet within a Virtual Network."
}

variable "vm_username" {
  description = "Enter admin username to SSH into Linux VM"
}

variable "vm_password" {
  description = "Enter admin password to SSH into VM"
}

variable "GW_user_data" {
  description = "Startup script for Gateway"
}

variable "Linux_user_data" {
  description = "Startup script for Gateway"
}

