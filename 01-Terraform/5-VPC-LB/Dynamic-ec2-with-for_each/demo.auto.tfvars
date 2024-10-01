puerto_lb       = 80
puerto_servidor = 80
puerto_ssh      = 22
instance_type   = "t2.medium"
servidores      = {
    "serv-1" = { az = "a", nombre = "servidor-1" },
    "serv-2" = { az = "b", nombre = "servidor-2" }
}