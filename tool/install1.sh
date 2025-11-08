#!/bin/bash
set -e

APP_NAME="tool"
INSTALL_DIR="/usr/local/bin"
LIB_DIR="/usr/local/lib/$APP_NAME"
LOG_DIR="/var/log/$APP_NAME"
BACKUP_DIR="/backup"
BIN_SRC_DIR="$(pwd)/bin"
LIB_SRC_DIR="$(pwd)/lib"

echo "Installing $APP_NAME suite..."

# Check for required dependencies
REQUIRED_CMDS=("tar" "sudo" "tee" "date")
for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: Required command '$cmd' not found. Please install it first."
        exit 1
    fi
done

# Create log directory
echo "Creating log directory at $LOG_DIR..."
sudo mkdir -p "$LOG_DIR"
sudo chown "$USER:adm" "$LOG_DIR"
sudo chmod 750 "$LOG_DIR"



# Create backup directory
echo "Ensuring backup directory exists at $BACKUP_DIR..."
if [ ! -d "$BACKUP_DIR" ]; then
    sudo mkdir -p "$BACKUP_DIR"
    sudo chown "$USER:$USER" "$BACKUP_DIR"
    sudo chmod 755 "$BACKUP_DIR"
else
    echo "Backup directory already exists."
fi

# Install binaries
echo "Installing scripts to $INSTALL_DIR..."
for file in "$BIN_SRC_DIR"/*; do
    fname=$(basename "$file")
    echo "➡️ Installing $fname ..."
    sudo cp "$file" "$INSTALL_DIR/$fname"
    sudo chmod +x "$INSTALL_DIR/$fname"
done

# Copy library files
echo "Copying libraries to $LIB_DIR..."
sudo mkdir -p "$LIB_DIR"
sudo cp -r "$LIB_SRC_DIR"/* "$LIB_DIR/"
sudo chmod -R 755 "$LIB_DIR"

# Ensure /usr/local/bin is in PATH
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo "Adding $INSTALL_DIR to PATH..."
    echo "export PATH=\$PATH:$INSTALL_DIR" >> ~/.bashrc
    export PATH=$PATH:$INSTALL_DIR
fi

# Create symlink for main command
if [ ! -f "$INSTALL_DIR/$APP_NAME" ]; then
    echo "Linking main command '$APP_NAME' ..."
    if [ -f "$INSTALL_DIR/tool" ]; then
        sudo ln -sf "$INSTALL_DIR/tool" "$INSTALL_DIR/$APP_NAME"
    fi
fi

echo
echo "$APP_NAME installed successfully!"
echo "-------------------------------------------"
echo "Executable Path : $INSTALL_DIR/"
echo "Libraries Path  : $LIB_DIR/"
echo "Log Directory   : $LOG_DIR/"
echo "Backup Directory: $BACKUP_DIR/"
echo
echo "Try running '$APP_NAME' to start the tool!"

