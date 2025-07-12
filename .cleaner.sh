#!/bin/bash

# Banner ASCII
clear
echo -e "\033[1;32m"
cat << "EOF"
 _      ____ _                            
| |__  / ___| | ___  __ _ _ __   ___ _ __ 
| '_ \| |   | |/ _ \/ _` | '_ \ / _ \ '__|
| |_) | |___| |  __/ (_| | | | |  __/ |   
|_.__/ \____|_|\___|\__,_|_| |_|\___|_|   




EOF

echo "Bienvenido al limpiador de sistema..."


clean_component() {
    local name=$1
    local command=$2
    local message=$3

    echo -e "\033[1;32m"
    read -rp "$message (S/n) " choice
    choice="${choice,,}"  # Convertir a minúscula
    choice="${choice:-s}"

    if [[ "$choice" == "s" ]]; then
        echo -e "\n→ Ejecutando limpieza de $name..."
        timeout 300s bash -c "$command"
        local status=$?
        if [[ $status -eq 124 ]]; then
            echo "⚠️  Tiempo de ejecución agotado para $name."
        elif [[ $status -ne 0 ]]; then
            echo "⚠️  Ocurrió un error al limpiar $name. Código: $status"
        else
            echo "✓ $name limpiado."
        fi
    else
        echo "✗ $name no fue limpiado."
    fi
    echo -e "\033[0m"
}

# Limpieza de paquetes huérfanos y caché Pacman (solo si hay paquetes huérfanos)
orphans=$(pacman -Qtdq 2>/dev/null)
if [[ -n "$orphans" ]]; then
    clean_component "paquetes huérfanos de Pacman" "sudo timeout 300s pacman -Rns --noconfirm $orphans" "¿Deseas limpiar paquetes huérfanos de Pacman?"
else
    echo -e "\nNo hay paquetes huérfanos en Pacman."
fi

clean_component "caché de Pacman" "sudo timeout 300s pacman -Scc --noconfirm" "¿Deseas limpiar la caché de Pacman?"

clean_component "caché y paquetes huérfanos de Yay" "yay -Yc --noconfirm && yay -Scc --noconfirm" "¿Deseas limpiar la caché y paquetes huérfanos de Yay?"

clean_component "Flatpak" "timeout 30s flatpak uninstall --unused --assumeyes || echo 'Timeout o error en limpieza de Flatpak'
" "¿Deseas eliminar apps y runtimes no usados de Flatpak?"

clean_component "archivos temporales" "sudo timeout 300s bash -c '
    rm -rf /tmp/* &&
    find ~/.cache/wal -type f ! -name "colors.json" -delete &&
    find ~/.cache -mindepth 1 -maxdepth 1 ! -name wal -exec rm -rf {} +
'
" "¿Deseas eliminar archivos temporales del sistema y usuario?"

clean_component "logs antiguos" "sudo timeout 300s journalctl --vacuum-time=3d" "¿Deseas eliminar logs del sistema con más de 3 días?"

clean_component "thumbnails de usuario" "rm -rf ~/.cache/thumbnails/*" "¿Deseas borrar miniaturas del sistema?"

# Si no usas systemd-boot, comenta o elimina esta línea
clean_component "núcleos antiguos (si usas systemd-boot)" "sudo bootctl update && sudo paccache -rk2" "¿Deseas eliminar kernels antiguos? (si usas systemd-boot)"

echo -e "\n\033[1;32m====== Sistema limpio y listo para despegar ======\033[0m"
