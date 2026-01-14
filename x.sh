#!/usr/bin/env bash

# Obtener la ruta del directorio donde se encuentra este script
DIR_ACTUAL="$(cd "$(dirname "$0")" && pwd)"

echo "Buscando archivos .sh en: $DIR_ACTUAL"

# Buscar todos los archivos .sh y aplicar chmod +x
# Excluimos el propio directorio (.) para evitar errores
find "$DIR_ACTUAL" -maxdepth 1 -name "*.sh" -exec sudo chmod +x {} +

echo "Hecho. Ahora todos los scripts en esta carpeta tienen permisos de ejecución."
