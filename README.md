# LAMP 
IMPORTANTE: Git no ejecuta scripts automáticamente al hacer `git clone`. Esto es una medida de seguridad.
Para instalar los paquetes (apache2, php y mariadb) después de clonar, usa una de las siguientes opciones:

1) Instalación LAMP
   git clone https://github.com/Dtincre/lamp.git ;   
   cd lamp ;   
   chmod +x install.sh ;   # hay que otorgarle permisos de ejecución ;   
   ./install.sh ;
   
3) Instalación Base De Datos   
   chmod +x db.sh ;   
   ./db.sh ;   
   # Glosario (cuando solicita un usuario/base de datos):
   # usuario/db   =   Crea el Usuario ó la Base de datos
   # --usuario/db   =   Elimina el Usuario ó la base de datos
   # *   =   Omite introducir cualquier parámetro y no realiza ninguna acción
