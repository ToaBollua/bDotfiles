#!/bin/bash

# Shredder: elimina y sobreescribe archivos o carpetas
# Requiere: coreutils (por el comando shred)

echo -e "\033[1;31m"
cat << "EOF"
 _    ____  _                  _     _           
| |__/ ___|| |__  _ __ ___  __| | __| | ___ _ __ 
| '_ \___ \| '_ \| '__/ _ \/ _` |/ _` |/ _ \ '__|
| |_) |__) | | | | | |  __/ (_| | (_| |  __/ |   
|_.__/____/|_| |_|_|  \___|\__,_|\__,_|\___|_|   

EOF
echo -e "\033[0m"

# Confirmación de destrucción
read -rp "⚠️  Este script eliminará y sobreescribirá archivos. ¿Continuar? (S/n): " confirm
confirm="${confirm,,}"
if [[ "$confirm" != "s" && "$confirm" != "" ]]; then
    echo "❌ Cancelado por el usuario."
    exit 1
fi

# Pedir ruta(s)
read -erp "🗂️  Ruta(s) de archivo o carpeta a destruir (separadas por espacio): " -a targets

# Número de pasadas
read -rp "🔁 ¿Cuántas pasadas de sobreescritura? (por defecto: 3): " passes
passes="${passes:-3}"

# Función para destruir archivo
shred_file() {
    local file=$1
    echo "→ Destruyendo archivo: $file"
    shred -uvz -n "$passes" "$file"
}

# Función para destruir carpeta
shred_dir() {
    local dir=$1
    echo "→ Destruyendo carpeta: $dir"
    find "$dir" -type f -exec shred -uvz -n "$passes" {} \;
    echo "→ Borrando estructura de carpetas: $dir"
    rm -rf "$dir"
}

# Proceso por cada destino
for item in "${targets[@]}"; do
    if [[ -f "$item" ]]; then
        shred_file "$item"
    elif [[ -d "$item" ]]; then
        shred_dir "$item"
    else
        echo "⚠️  '$item' no existe o no es válido."
    fi
done

echo -e "\n\033[1;32m✓ Proceso completado.\033[0m"

