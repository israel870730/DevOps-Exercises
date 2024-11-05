variable "instance_count" {
  description = "Cantidad de instancias EC2"
  type        = number
  default     = 3
}

variable "puerto_servidor" {
  description = "Puerto para las instancias"
  type        = number
  default     = 80

  #Forma de validar una variable
  validation {
    condition     = var.puerto_servidor > 0 && var.puerto_servidor <= 65535
    error_message = "El valor del puerto debe estar comprendido entre 1 y 65535."
  }
}

variable "puerto_lb" {
  description = "Puerto para el LB"
  type        = number
  default     = 80
}

variable "puerto_ssh" {
  description = "Puerto SSh para acceder a la instancias"
  type        = number
  default     = 22
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.nano"
}

variable "public_key" {
  description = "Public key path"
  default     = "~/.ssh/id_rsa.pub"
}

#Variables en forma de mapas
variable "ubuntu_ami" {
  description = "AMI por region"
  type        = map(string)

  default = {
    us-east-1 = "ami-052efd3df9dad4825"
    us-east-2 = "ami-02f3416038bdb17fb"
    us-west-1 = "ami-08012c0a9ee8e21c4"
  }
}

#Variable instances name
# variable "instance_names" {
#   description = "Nombre de las instancias"
  
#   type = map(object({
#     nombre = string,
#   }))
  
#   default = {
#     "serv-1" = { nombre = "servidor-1" },
#     "serv-2" = { nombre = "servidor-2" }
#   }
# }

variable "instance_names" {
  description = "A list of instance_names"
  type        = list(string)
  default     = []
}
