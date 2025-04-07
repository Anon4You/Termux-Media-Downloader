#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Header
echo -e "${GREEN}"
echo "┌────────────────────────────────────────────────────┐"
echo "│      Termux Media Downloader Installation          │"
echo "│               by Alienkrishn                       │"
echo "│        GitHub: github.com/Anon4You                 │"
echo "└────────────────────────────────────────────────────┘"
echo -e "${NC}"

# Check if running in Termux
if ! [ -x "$(command -v termux-setup-storage)" ]; then
  echo -e "${RED}Error: This script must be run in Termux${NC}"
  exit 1
fi

# Update and install required packages
echo -e "${YELLOW}[*] Updating packages...${NC}"
apt update -y && apt upgrade -y

echo -e "${YELLOW}[*] Installing dependencies...${NC}"
apt install -y python ffmpeg curl

echo -e "${YELLOW}[*] Installing yt-dlp...${NC}"
pip install --upgrade yt-dlp

# Setup storage if needed
echo -e "${YELLOW}[*] Checking storage permissions...${NC}"
if [ ! -d "$HOME/storage" ]; then
    echo -e "${BLUE}[*] Setting up storage access...${NC}"
    yes | termux-setup-storage
    sleep 2  # Give it time to complete
    mkdir -p ~/storage/shared/Youtube_Downloads
  else
    mkdir -p ~/storage/shared/Youtube_Downloads
fi

# Install main script
echo -e "${YELLOW}[*] Downloading and installing Termux Media Downloader...${NC}"
curl -L "https://raw.githubusercontent.com/Anon4You/Termux-Media-Downloader/main/tmd.sh" -o $PREFIX/bin/tmd
chmod +x $PREFIX/bin/tmd

# Create config directory
echo -e "${YELLOW}[*] Setting up configuration directory...${NC}"
mkdir -p $HOME/.config/tmd_config

# Completion message
echo -e "${GREEN}"
echo "┌────────────────────────────────────────────────────┐"
echo "│          Installation Completed Successfully!      │"
echo "│                                                    │"
echo "│   To start using the media downloader, run:        │"
echo -e "│         ${YELLOW}tmd${GREEN}                                        │"
echo "│                                                    │"
echo "│   This will create the configuration file and      │"
echo "│   set your preferred download directory.           │"
echo "│                                                    │"
echo "│   Default download location:                       │"
echo -e "│   ${YELLOW}/sdcard/Youtube_Downloads${GREEN}                        │"
echo "└────────────────────────────────────────────────────┘"
echo -e "${NC}"
