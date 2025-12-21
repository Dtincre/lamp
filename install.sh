#!/usr/bin/env bash
set -euo pipefail

PACKAGES=(apache2 php php-mysql php-xml php-mbstring php-curl php-gd mariadb-server)

show_help() {
  cat <<EOF
install.sh - Instala paquetes requeridos en Debian/Ubuntu.

Uso:
  ./install.sh         # instalará interactivo (pedirá confirmación en apt)
  ./install.sh -y      # instalará sin preguntar (apt -y)

Nota: este script usa 'sudo' si no se ejecuta como root.
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  show_help
  exit 0
fi

AUTO_YES=0
while getopts "y" opt; do
  case $opt in
    y) AUTO_YES=1 ;;
    *) show_help; exit 1 ;;
  esac
done

if ! command -v apt >/dev/null 2>&1; then
  echo "Error: apt no está disponible. Este script está diseñado para Debian/Ubuntu." >&2
  exit 2
fi

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO=sudo
  else
    echo "Error: necesitas privilegios de root o sudo para instalar paquetes." >&2
    exit 3
  fi
fi

echo "Se instalarán los paquetes: ${PACKAGES[*]}"
if [ "$AUTO_YES" -eq 1 ]; then
  echo "Modo no interactivo: se usará -y en apt."
  $SUDO apt update
  DEBIAN_FRONTEND=noninteractive $SUDO apt install -y "${PACKAGES[@]}"
else
  $SUDO apt update
  $SUDO apt install "${PACKAGES[@]}"
fi

echo "Instalación finalizada."
