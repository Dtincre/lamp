# LAMP (instalación de paquetes al clonar)

IMPORTANTE: Git no ejecuta scripts automáticamente al hacer `git clone`. Esto es una medida de seguridad.
Para instalar los paquetes (apache2, php y mariadb) después de clonar, usa una de las siguientes opciones:

1) Método recomendado (manual y seguro)
   git clone https://github.com/Dtincre/wordpress-pack.git ;   
   cd wordpress-pack ;   
   chmod +x install.sh ;   # hay que otorgarle permisos de ejecución ;   
   ./install.sh ;   # te pedirá confirmación ;   
   # o para no interactuar:
   ./install.sh -y

El repositorio incluye:
- install.sh          : script para instalar paquetes en Debian/Ubuntu.
- .githooks/post-checkout : hook de ejemplo que puede ejecutar install.sh una vez que habilites hooks.
- install-hooks.sh    : script para configurar core.hooksPath a .githooks.
- Dockerfile          : imagen Debian con los paquetes instalados.
```
