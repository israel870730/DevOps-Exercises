# Comandos de Linux Más Usados por SysAdmins, DevOps y CloudOps

## **Networking**
**SSH Key Authentication**:
   - `ssh-keygen -t rsa` – Generar una clave SSH.
   - `ssh-copy-id user@hostname` – Copiar clave pública a un host remoto.
**File Transfer**:
   - `scp localfile.txt user@remote:/path` – Transferir archivos a un host remoto.
3. **Network Configuration**:
   - `ifconfig` – Configurar interfaces de red (deprecado; usa `ip` en su lugar).
   - `ip addr show` – Mostrar direcciones IP de las interfaces de red.
**Monitor Network Traffic**:
   - `tcpdump -i eth0` – Capturar y analizar paquetes en una interfaz.
**SSH Tunneling**:
   - `ssh -L local_port:remote_host:remote_port user@hostname` – Crear un túnel SSH.
**List Open Ports**:
  - `netstat -tulpn` – Mostrar todos los puertos abiertos y los programas asociados.
  - `ss -tulpn` – Alternativa moderna a `netstat` para listar puertos abiertos y servicios.
  - `lsof -i :port` – Mostrar el proceso que está utilizando un puerto específico.
  - `nmap localhost` – Escanear puertos abiertos en la máquina local.
  - `fuser -n tcp port_number` – Identificar procesos que usan un puerto específico.
  - `iptables -L -n -v` – Listar reglas de firewall que podrían afectar los puertos.

---

## **Storage and Disk Management**
**Disk Usage**:
   - `df -h` – Mostrar uso del sistema de archivos.
   - `du -bsh /path` – Mostrar tamaño de un directorio.
**Find Large Files**:
   - `find / -type f -size +100M` – Buscar archivos mayores a 100 MB.
**Disk Encryption**:
   - `cryptsetup luksFormat /dev/sdX` – Configurar cifrado en un disco.
**Create a RAM Disk**:
   - `mount -t tmpfs -o size=512M tmpfs /mnt/ramdisk` – Crear un disco RAM temporal.

---

## **User and Permissions**
**User Management**:
   - `useradd username` – Crear un nuevo usuario.
   - `passwd username` – Establecer o cambiar la contraseña de un usuario.
**File Permissions**:
   - `chmod +x filename` – Hacer un archivo ejecutable.
   - `chown user:group filename` – Cambiar propietario y grupo de un archivo.
**Failed Login Attempts**:
   - `cat /var/log/auth.log | grep "Failed password"` – Revisar intentos de inicio de sesión fallidos.

---

## **System Monitoring**
**Check System Load**:
   - `top` – Monitorear procesos y carga del sistema.
   - `uptime` – Ver el tiempo de actividad del sistema.
**Available Memory**:
   - `free -m` – Ver memoria disponible en MB.
**System Architecture**:
   - `arch` – Mostrar arquitectura del sistema.
**Monitor Disk I/O**:
   - `iostat -d 5` – Monitorear operaciones de entrada/salida en discos.
**Check Service Status**:
   - `systemctl status service_name` – Verificar estado de un servicio.

---

## **Logs and Automation**
**System Logs**:
   - `tail -f /var/log/syslog` – Monitorear logs en tiempo real.
**Cron Jobs**:
   - `crontab -e` – Editar trabajos programados de cron.
**Run a Command at Regular Intervals**:
   - `watch -n 1 command` – Ejecutar un comando periódicamente.
**Text Search and Processing**:
   - `grep -r "pattern" /path/to/search` – Buscar texto dentro de archivos.
   - `awk '{print $1, $3}' file` – Extraer y mostrar columnas específicas de un archivo.
   - `sed -i 's/old_text/new_text/g' filename` – Buscar y reemplazar texto en un archivo.
   - `xargs -n 1 command` – Ejecutar comandos de forma iterativa.

---

## **Development and Package Management**
**Package Management**:
   - `apt-get update` – Actualizar lista de paquetes.
   - `apt-get install package_name` – Instalar un paquete.
**Install Git**:
   - `apt-get install git` – Instalar Git.
**Install Python Pip**:
   - `apt-get install python3-pip` – Instalar pip para Python 3.
**Install Node.js**:
   - `curl -sL https://deb.nodesource.com/setup_14.x | bash -` – Añadir repositorio Node.js.
   - `apt-get install -y nodejs` – Instalar Node.js.

---

## **File Operations**
**Find and Replace in Files**:
   - `sed -i 's/old_text/new_text/g' filename` – Reemplazar texto en un archivo.
**Archive and Compress**:
   - `tar -czvf archive.tar.gz /path/to/directory` – Crear un archivo comprimido.
**Create Symbolic Link**:
   - `ln -s /path/to/source /path/to/link` – Crear un enlace simbólico.

---

## **Docker and Containers**
**Docker Commands**:
   - `docker ps` – Listar contenedores en ejecución.
   - `docker exec -it container_id /bin/bash` – Acceder a la terminal de un contenedor.

---

## **Security**
**Generate Random Password**:
   - `openssl rand -base64 12` – Generar una contraseña aleatoria.
**Firewall Configuration**:
   - `ufw allow 80` – Permitir tráfico en el puerto 80.
**Check SELinux Status**:
   - `sestatus` – Verificar el estado de SELinux.

## **Build Tools**
- **Automate Build Tasks with Make**:
  - `make` – Ejecutar las tareas definidas en un archivo `Makefile`.
  - `make target_name` – Ejecutar una tarea específica definida en el `Makefile`.
  - `make clean` – Limpiar archivos generados durante el proceso de construcción (usualmente definido en el `Makefile`).
