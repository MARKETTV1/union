#!/bin/sh
# Uni_Stalker Install Script for Enigma2

# Configuration
IP_RECEIVER="192.168.1.100"  # Change this to your receiver's IP
TARGET_DIR="/usr/lib/enigma2/python/Plugins/Extensions"
DOWNLOAD_URL="https://github.com/MARKETTV1/union/raw/refs/heads/main/Uni_Stalker.tar.gz"
TEMP_FILE="/tmp/Uni_Stalker.tar.gz"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if IP is set
if [ "$IP_RECEIVER" = "192.168.1.100" ]; then
    print_error "Please set the correct IP address of your receiver in the script!"
    exit 1
fi

# Check SSH connection
print_status "Checking SSH connection to $IP_RECEIVER..."
ssh root@$IP_RECEIVER "echo 'SSH connection successful'" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    print_error "Cannot connect to receiver via SSH. Please check:"
    print_error "- IP address: $IP_RECEIVER"
    print_error "- SSH service is running on receiver"
    print_error "- Password is correct (usually 'dreambox' or 'root')"
    exit 1
fi

# Check if target directory exists
print_status "Checking target directory..."
ssh root@$IP_RECEIVER "[ -d '$TARGET_DIR' ]" 
if [ $? -ne 0 ]; then
    print_error "Target directory $TARGET_DIR does not exist on the receiver!"
    exit 1
fi

# Check available space
print_status "Checking available space..."
AVAILABLE_SPACE=$(ssh root@$IP_RECEIVER "df $TARGET_DIR | tail -1 | awk '{print \$4}'")
if [ "$AVAILABLE_SPACE" -lt 5000 ]; then
    print_warning "Low disk space available: ${AVAILABLE_SPACE}KB"
fi

# Download and install
print_status "Downloading Uni_Stalker from GitHub..."
ssh root@$IP_RECEIVER "
cd '$TARGET_DIR' && \
wget -q '$DOWNLOAD_URL' -O '$TEMP_FILE'

if [ \$? -ne 0 ]; then
    echo 'Download failed!'
    exit 1
fi

print_status 'Extracting files...'
tar -xzf '$TEMP_FILE' -C '$TARGET_DIR'

if [ \$? -ne 0 ]; then
    echo 'Extraction failed!'
    rm -f '$TEMP_FILE'
    exit 1
fi

print_status 'Setting permissions...'
chmod -R 755 '$TARGET_DIR/Uni_Stalker/'

print_status 'Cleaning up...'
rm -f '$TEMP_FILE'

echo 'Installation completed successfully!'
"

# Check if installation was successful
if [ $? -eq 0 ]; then
    print_status "Uni_Stalker installed successfully!"
    
    # Ask to restart Enigma2
    echo
    read -p "Do you want to restart Enigma2? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Restarting Enigma2..."
        ssh root@$IP_RECEIVER "init 4 && sleep 3 && init 3"
        print_status "Enigma2 restarted!"
    fi
    
    print_status "Installation complete! Check your plugins menu."
else
    print_error "Installation failed!"
    exit 1
fi
