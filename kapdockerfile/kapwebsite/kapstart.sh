#!/bin/bash


set -e  # Establece la opción -e para que el script se detenga si se produce algún error

# Variables
REPO=https://github.com/morgadodesarrollador/ApijardineriaNest.git
LOG=/root/logs/logs.txt

# Función para configurar el repositorio git
kapconfigGIT(){
    # Verifica si ya existe el directorio git en el directorio actual
    if [ -d /root/api ]; then
        cd /root/api
        git clone $REPO
        echo 'Ok: se ha descargado el git' >> "$LOG"
    else
        echo 'Error: No se ha descargado el git' >> "$LOG"
        exit 1
    fi
}

# Función para instalar las dependencias del proyecto y ponerlo en marcha
kapmakebuild(){
    echo 'Instalando dependencias del proyecto y puesta en marcha' >> "$LOG"  # Registro de actividad

    # Instala las dependencias del proyecto con npm install y luego inicia la aplicación con npm run build
    cd /root/api/ApijardineriaNest  || exit 1
    npm install --force
    npm run start:dev

    if [ $? -eq 0 ]; then
        echo "Ok: se ha realizado el build" >> "$LOG"
    else
        echo "Error: no se ha realizado el build" >> "$LOG"
        exit 1
    fi
}

# Función para desplegar en Nginx
kapdespliegengnix(){
    cp -R /root/api/ApijardineriaNest/*  /var/www/kapwebsite

    # Cambia el propietario de los archivos al usuario nginx
    chown -R nginx:nginx /var/www/kapwebsite

    # Inicia nginx (el comando puede variar dependiendo de la distribución de Linux)
    /etc/init.d/nginx start &
}

# Función principal que llama a las funciones en secuencia
main(){
    kapconfigGIT
    kapmakebuild
    kapdespliegengnix
    tail -f /dev/null
}

main  # Llama a la función principal para iniciar el script
