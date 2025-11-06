#!/bin/bash
set -e

APP_NAME="tool"
INSTALL_DIR="/usr/local/bin"
LOG_DIR="/var/log/$APP_NAME"
LIB_SRC_DIR="$(pwd)/lib"
BIN_SRC_DIR="$(pwd)/bin"

echo " Installing $APP_NAME suite..."

# Create log directory
if [ ! -d "$LOG_DIR" ]; then
    echo " Creating log directory at $LOG_DIR..."
    sudo mkdir -p "$LOG_DIR"
    sudo chown $USER:adm "$LOG_DIR"
    sudo chmod 750 "$LOG_DIR"
else
    echo " Log directory already exists."
fi

# Copy scripts to /usr/local/bin/
for file in "$BIN_SRC_DIR"/*; do
    fname=$(basename "$file")
    echo " Installing $fname to $INSTALL_DIR..."
    sudo cp "$file" "$INSTALL_DIR/$fname"
    sudo chmod +x "$INSTALL_DIR/$fname"
done

# Copy lib folder to /usr/local/lib/tool/
if [ ! -d "/usr/local/lib/$APP_NAME" ]; then
    echo " Copying libraries to /usr/local/lib/$APP_NAME..."
    sudo mkdir -p "/usr/local/lib/$APP_NAME"
fi
sudo cp -r "$LIB_SRC_DIR"/* "/usr/local/lib/$APP_NAME/"


echo " $APP_NAME installed successfully!"
echo "Logs: $LOG_DIR/"
echo "Scripts: $INSTALL_DIR/"
echo "Libraries: /usr/local/lib/$APP_NAME/"

