#!/bin/bash

# Obtener y actualizar de maner automatica las llaves no firmadas en el sistema

# Nos aseguramos que somos root para continuar
if [ "$(id -u)" != "0" ]; then
   echo "Tiene que ser root para ejecutar este script"
   exit 1
fi

echo "Obteniendo las llaves no firmadas del sistema... "

# LLave no firmada
VAR_KEY_PUBLIC_=$(aptitude update 2>&1 | grep "NO_PUBKEY" | head -n 1 | cut -d ":" -f2 | cut -d " " -f3)


# Verificando si la variable VAR_KEY_PUBLIC_ esta vacia
if [ -z $VAR_KEY_PUBLIC_ ] ; then
	echo "No se encontraron llaves sin firmar"
	exit 0
fi

echo "Llave no firmada encontrada: $VAR_KEY_PUBLIC_"

read -p "Actualizar llave publica? s/n " LLAVE

if [ "$LLAVE" = "s" ] ; then
	echo "Obteniendo y actualizando llaves"
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $VAR_KEY_PUBLIC_
	echo "Actualizando repositorios, espere..."
	aptitude update 1>/dev/null
	echo "llaves actualizadas correctamente"
	exit 0
else
	exit 0
fi

