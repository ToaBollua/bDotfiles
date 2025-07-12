#!/bin/bash

# Banner ASCII
clear
echo -e "\033[1;32m"
cat << "EOF"
    __    __  __          __      __     
   / /_  / / / /___  ____/ /___ _/ /____ 
  / __ \/ / / / __ \/ __  / __ `/ __/ _ \
 / /_/ / /_/ / /_/ / /_/ / /_/ / /_/  __/
/_.___/\____/ .___/\__,_/\__,_/\__/\___/ 
           /_/                           

EOF

echo "Bienvenido al actualizador de sistema..."

# Función para actualizar un gestor de paquetes
update_package_manager() {
    local manager_name=$1
    local update_command=$2
    local confirmation_message=$3

    echo -e "\033[1;32m"
    read -p "$confirmation_message (S/n) " update_choice
    update_choice="${update_choice:-s}"  # Establece la opción de actualización por defecto a "S"

    if [[ "$update_choice" == "s" ]]; then
        if eval "$update_command"; then
            echo "Paquetes de $manager_name actualizados."
        else
            echo "Error al actualizar los paquetes de $manager_name."
        fi
    else
        echo "Paquetes de $manager_name no actualizados."
    fi
}

#   Actualiza los distintos gestores de paquetes.
#   Comenta o descomenta los gestores de paquetes
#   que uses en tu sistema.

update_package_manager "Pacman" "sudo pacman -Scc --noconfirm && sudo pacman -Syu --noconfirm" "Quieres actualizar los paquetes de Pacman?"

update_package_manager "Yay" "yay -Scc --noconfirm && yay -Syu --noconfirm" "Quieres actualizar los paquetes de Yay?"

update_package_manager "Flatpak" "flatpak update" "Quieres actualizar los paquetes de Flatpak?"

update_package_manager "ClamAV" "sudo freshclam" "Quieres actualizar la base de datos de virus?"

#update_package_manager "APT" "sudo apt update && sudo apt upgrade" "Quieres actualizar los paquetes de APT?"

#update_package_manager "PKG" "pkg update && pkg upgrade" "Quieres actualizar los paquetes PKG?"

#update_package_manager "DNF" "sudo dnf update" "Quieres actualizar los paquetes DNF?"

echo "====== Toda tu mierda se actualizó ======"
