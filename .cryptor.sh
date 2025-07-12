#!/bin/bash

# Cryptor: Encripta y desencripta archivos con GPG
# Requiere: gpg, opcionalmente shred

clear
echo -e "\033[1;36m"
cat << "EOF"
 _      ____                  _             
| |__  / ___|_ __ _   _ _ __ | |_ ___  _ __ 
| '_ \| |   | '__| | | | '_ \| __/ _ \| '__|
| |_) | |___| |  | |_| | |_) | || (_) | |   
|_.__/ \____|_|   \__, | .__/ \__\___/|_|   
                  |___/|_|                  
EOF
echo -e "\033[0m"

# Selección de modo
echo "Selecciona una opción:"
echo "1) 🔐 Encriptar archivo"
echo "2) 🔓 Desencriptar archivo"
read -rp "Opción (1/2): " option

# Validar opción
if [[ "$option" != "1" && "$option" != "2" ]]; then
    echo "❌ Opción no válida."
    exit 1
fi

# Ruta del archivo
read -erp "🗂️  Ruta del archivo: " file

if [[ ! -f "$file" ]]; then
    echo "❌ El archivo no existe."
    exit 1
fi

# Encriptar
if [[ "$option" == "1" ]]; then
    output="$file.gpg"
    echo "🔐 Encriptando '$file' → '$output'"
    gpg --symmetric --cipher-algo AES256 "$file"

    if [[ $? -eq 0 && -f "$output" ]]; then
        echo "✓ Archivo encriptado correctamente."
        read -rp "¿Deseas eliminar el archivo original? (s/N) " del
        del="${del,,}"  # a minúscula
        if [[ "$del" == "s" ]]; then
            if command -v shred >/dev/null; then
                echo "🧨 Borrando de forma segura con shred..."
                shred -u "$file"
            else
                echo "⚠️  shred no disponible, usando rm normal."
                rm -f "$file"
            fi
            echo "✓ Archivo original eliminado."
        else
            echo "✗ Archivo original conservado."
        fi
    else
        echo "❌ Error durante la encriptación."
    fi

# Desencriptar
else
    base="${file%.gpg}"
    echo "🔓 Desencriptando '$file' → '$base'"
    gpg -o "$base" -d "$file"
    if [[ $? -eq 0 ]]; then
        echo "✓ Archivo desencriptado."
    else
        echo "❌ Error al desencriptar el archivo."
    fi
fi

