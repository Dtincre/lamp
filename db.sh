#!/usr/bin/env bash
set -euo pipefail

PACKAGES=(apache2 php php-mysql php-xml php-mbstring php-curl php-gd mariadb-server)

show_help() {
  cat <<EOF
install.sh - Instala paquetes requeridos en Debian/Ubuntu.
Uso: ./install.sh o ./install.sh -y
EOF
}

# --- Lógica de instalación (se mantiene igual) ---
AUTO_YES=0
while getopts "y" opt; do
  case $opt in
    y) AUTO_YES=1 ;;
    *) show_help; exit 1 ;;
  esac
done

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  SUDO=sudo
fi

if [ "$AUTO_YES" -eq 1 ]; then
  $SUDO apt update && DEBIAN_FRONTEND=noninteractive $SUDO apt install -y "${PACKAGES[@]}"
else
  $SUDO apt update && $SUDO apt install "${PACKAGES[@]}"
fi

echo "Instalación finalizada."

# --- SECCIÓN DE BASE DE DATOS Y USUARIOS ---

read -p "nombre de la base de datos: " db_input
read -p "Nombre de usuario con todos los permisos: " user_input

# 1. Lógica para la Base de Datos
if [[ "$db_input" == "--"* ]]; then
    DB_NAME="${db_input#--}" 
    echo "Borrando base de datos: $DB_NAME"
    $SUDO mysql -e "DROP DATABASE IF EXISTS $DB_NAME;"
elif [[ "$db_input" == "*" ]]; then
    echo "Omitiendo comando de Base de Datos."
else
    echo "Creando base de datos: $db_input"
    $SUDO mysql -e "CREATE DATABASE IF NOT EXISTS $db_input;"
fi

# 2. Lógica para el Usuario
if [[ "$user_input" == "--"* ]]; then
    USER_NAME="${user_input#--}"
    echo "Borrando usuario: $USER_NAME"
    $SUDO mysql -e "DROP USER IF EXISTS '$USER_NAME'@'localhost';"
elif [[ "$user_input" == "*" ]]; then
    echo "Omitiendo comando de Usuario."
else
    # Aquí es donde pedimos la contraseña SOLO si estamos creando un usuario
    read -p "Contraseña del usuario: " db_pass
    
    echo "Creando usuario y asignando privilegios..."
    $SUDO mysql <<EOF
CREATE USER IF NOT EXISTS '$user_input'@'localhost' IDENTIFIED BY '$db_pass';
GRANT ALL PRIVILEGES ON ${db_input}.* TO '$user_input'@'localhost';
FLUSH PRIVILEGES;
EOF
fi

echo "Operación finalizada."
