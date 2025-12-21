#!/usr/bin/env bash
set -euo pipefail

# Comprobar si tenemos privilegios de root/sudo
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO=sudo
  else
    echo "Error: este script requiere privilegios de sudo para gestionar MariaDB." >&2
    exit 1
  fi
fi

echo "--- Gestor de Bases de Datos MariaDB ---"
echo "Instrucciones: Use '--nombre' para borrar o '*' para omitir."
echo "----------------------------------------"

# 1. Pedir datos al usuario
read -p "nombre de la base de datos: " db_input
read -p "Nombre de usuario con todos los permisos: " user_input

# 2. Lógica para la Base de Datos
if [[ "$db_input" == "--"* ]]; then
    DB_NAME="${db_input#--}" 
    echo "Ejecutando: DROP DATABASE IF EXISTS $DB_NAME ;"
    $SUDO mysql -e "DROP DATABASE IF EXISTS $DB_NAME;"
elif [[ "$db_input" == "*" ]]; then
    echo "Omitiendo comando de Base de Datos."
else
    echo "Ejecutando: CREATE DATABASE $db_input ;"
    $SUDO mysql -e "CREATE DATABASE IF NOT EXISTS $db_input;"
fi

# 3. Lógica para el Usuario
if [[ "$user_input" == "--"* ]]; then
    USER_NAME="${user_input#--}"
    echo "Ejecutando: DROP USER '$USER_NAME'@'localhost' ;"
    $SUDO mysql -e "DROP USER IF EXISTS '$USER_NAME'@'localhost';"
elif [[ "$user_input" == "*" ]]; then
    echo "Omitiendo comando de Usuario."
else
    # Solicitar contraseña solo si se va a crear el usuario
    read -p "Contraseña del usuario: " db_pass
    
    echo "Ejecutando comandos de creación y privilegios..."
    $SUDO mysql <<EOF
CREATE USER IF NOT EXISTS '$user_input'@'localhost' IDENTIFIED BY '$db_pass';
GRANT ALL PRIVILEGES ON ${db_input}.* TO '$user_input'@'localhost';
FLUSH PRIVILEGES;
exit
EOF
fi

echo "----------------------------------------"
echo "Operación finalizada con éxito."
