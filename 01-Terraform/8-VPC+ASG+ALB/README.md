# Para instalar la herramienta stress en un sistema Ubuntu, puedes seguir estos pasos:
- sudo apt update && sudo apt install stress

# Verificar la instalación: Después de la instalación, puedes verificar que stress se haya instalado correctamente ejecutando:
- stress --version

# Generar carga en la CPU:
- Este comando ejecutará stress utilizando 4 núcleos de CPU.
  - stress --cpu 4 --timeout 60
  - stress -c 4 &
  - Comprobamos ejecutando htop 

# Generar carga en la memoria:
- Este comando ejecutará stress utilizando 2 procesos de memoria virtual con 256 MB de memoria cada uno durante 60 segundos.
  - stress --vm 2 --vm-bytes 256M --timeout 60

# Generar carga en el disco:
- Este comando ejecutará stress utilizando 4 procesos de I/O durante 60 segundos.
  - stress --io 4 --timeout 60

# Ejecutar el script get_public_ip.sh y obtener la IP real de donde estamos:
  - chmod +x get_public_ip.sh
  - ./get_public_ip.sh
