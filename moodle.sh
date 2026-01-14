#!/usr/bin/env bash
set -euo pipefail

# 1. Clonar el repositorio y configurar la versión
echo "Clonando Moodle en /var/www/..."
cd /var/www/
sudo git clone https://github.com/moodle/moodle.git
cd moodle
echo "Cambiando a la rama MOODLE_403_STABLE..."
sudo git checkout MOODLE_403_STABLE
cd ..

# 2. Crear directorio de datos y configurar permisos
echo "Configurando directorio moodledata y permisos..."
sudo mkdir -p /var/moodledata
sudo chown -R www-data:www-data /var/www/moodle
sudo chown -R www-data:www-data /var/moodledata
sudo chmod 775 /var/moodledata

# 3. Editar php.ini (max_input_vars) usando sed
# Buscamos la línea que contiene max_input_vars y cambiamos 1000 por 5000
PHP_INI="/etc/php/8.2/apache2/php.ini"

if [ -f "$PHP_INI" ]; then
    echo "Modificando max_input_vars en $PHP_INI..."
    # Eliminamos el punto y coma (si estuviera comentado) y cambiamos el valor
    sudo sed -i 's/^;*max_input_vars = 1000/max_input_vars = 5000/' "$PHP_INI"
    
    # Reiniciar apache para aplicar cambios de PHP
    echo "Reiniciando Apache..."
    sudo systemctl restart apache2
else
    echo "Error: No se encontró el archivo $PHP_INI. Verifica la versión de PHP."
fi

echo "Script finalizado con éxito."
