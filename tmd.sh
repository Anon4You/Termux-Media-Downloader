#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Config directory
CONFIG_DIR="$HOME/.config/tmd_config"
DOWNLOAD_DIR="/sdcard/Youtube_Downloads"
CONFIG_FILE="$CONFIG_DIR/config"
HISTORY_FILE="$CONFIG_DIR/history.log"
FORMAT_FILE="$CONFIG_DIR/format"

# Default settings
DEFAULT_FORMAT="bestvideo[height<=1080]+bestaudio/best[height<=1080]"
THUMBNAILS=true
METADATA=true
SPONSORBLOCK=true

# Load config if exists
load_config() {
    [ -d "$CONFIG_DIR" ] || mkdir -p "$CONFIG_DIR"
    [ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
    [ -f "$FORMAT_FILE" ] && FORMAT=$(cat "$FORMAT_FILE") || FORMAT="$DEFAULT_FORMAT"
}

# Create default config
create_config() {
    mkdir -p "$CONFIG_DIR"
    cat > "$CONFIG_FILE" <<- EOM
DOWNLOAD_DIR="$DOWNLOAD_DIR"
THUMBNAILS="$THUMBNAILS"
METADATA="$METADATA"
SPONSORBLOCK="$SPONSORBLOCK"
EOM
    echo "$DEFAULT_FORMAT" > "$FORMAT_FILE"
    touch "$HISTORY_FILE"
}

# Show header with author info
header() {
    clear
    echo -e "${PURPLE}"
    echo "┌────────────────────────────────────────────────────┐"
    echo "│          TERMUX MEDIA DOWNLOADER (yt-dlp)          │"
    echo "└────────────────────────────────────────────────────┘"
    echo -e "${NC}"
    echo -e "${CYAN}               Created by Alienkrishn${NC}"
    echo -e "${YELLOW}          GitHub: https://github.com/Anon4You${NC}"
    echo ""
}

# Download media function
download_media() {
    local url="$1" playlist="$2" audio_only="$3"
    local cmd="yt-dlp --ignore-errors --newline --no-continue "
    cmd+="--output '$DOWNLOAD_DIR/%(title)s.%(ext)s' -f '$FORMAT' "
    
    [ "$playlist" = true ] && cmd+="--yes-playlist " || cmd+="--no-playlist "
    [ "$audio_only" = true ] && cmd+="--extract-audio --audio-format mp3 --audio-quality 0 "
    [ "$THUMBNAILS" = true ] && cmd+="--embed-thumbnail "
    [ "$METADATA" = true ] && cmd+="--add-metadata "
    [ "$SPONSORBLOCK" = true ] && cmd+="--sponsorblock-remove all "
    cmd+="'$url'"
    
    echo -e "${YELLOW}Starting download...${NC}\n${BLUE}Command:${NC} $cmd"
    echo -e "[$(date)] Downloading: $url\n[$(date)] Command: $cmd" >> "$HISTORY_FILE"
    
    eval "$cmd" | while read -r line; do
        case "$line" in
            *[Dd]ownloading*) echo -e "${BLUE}$line${NC}" ;;
            *[Ee]rror*) echo -e "${RED}$line${NC}" ;;
            *) echo "$line" ;;
        esac
    done
    
    command -v termux-notification &>/dev/null && \
        termux-notification -t "Download Complete" -c "Finished downloading: $url"
    
    echo -e "${GREEN}Download completed!\nFile saved to: $DOWNLOAD_DIR${NC}"
}

# Change download directory
change_directory() {
    header
    echo -e "Current directory: ${YELLOW}$DOWNLOAD_DIR${NC}"
    read -p "Enter new directory path or leave blank to keep current: " new_dir
    
    [ -n "$new_dir" ] && {
        DOWNLOAD_DIR="$new_dir"
        mkdir -p "$DOWNLOAD_DIR"
        sed -i "s|^DOWNLOAD_DIR=.*|DOWNLOAD_DIR=\"$DOWNLOAD_DIR\"|" "$CONFIG_FILE"
        echo -e "${GREEN}Download directory updated!${NC}"
    } || echo -e "${YELLOW}Directory not changed.${NC}"
    sleep 1
}

# Change format/quality
change_format() {
    header
    echo -e "${BLUE}Available format options:${NC}"
    echo -e "1. Best quality (up to 1080p) [default]"
    echo -e "2. Best quality (up to 720p)"
    echo -e "3. Best quality (up to 480p)"
    echo -e "4. Audio only (best quality)"
    echo -e "5. Custom format (advanced)"
    read -p "Select format option: " format_choice
    
    case "$format_choice" in
        1) FORMAT="bestvideo[height<=1080]+bestaudio/best[height<=1080]" ;;
        2) FORMAT="bestvideo[height<=720]+bestaudio/best[height<=720]" ;;
        3) FORMAT="bestvideo[height<=480]+bestaudio/best[height<=480]" ;;
        4) FORMAT="bestaudio" ;;
        5)
            echo -e "${YELLOW}Enter custom format string:${NC}"
            read -p "> " custom_format
            FORMAT="$custom_format"
            ;;
        *) echo -e "${RED}Invalid option, keeping current format.${NC}" ;;
    esac
    
    echo "$FORMAT" > "$FORMAT_FILE"
    echo -e "${GREEN}Format updated to: $FORMAT${NC}"
    sleep 1
}

# Toggle setting
toggle_setting() {
    local setting="$1"
    local new_value=$([ "${!setting}" = true ] && echo false || echo true)
    eval "$setting=$new_value"
    sed -i "s|^$setting=.*|$setting=$new_value|" "$CONFIG_FILE"
    echo -e "${GREEN}$setting set to $new_value${NC}"
    sleep 1
}

# Enhanced history management
view_history() {
    while true; do
        header
        echo -e "${BLUE}Download History Management${NC}"
        echo -e "${CYAN}1. View full history\n2. Search history\n3. Clear history"
        echo -e "4. Export history\n5. Delete entry\n6. Back to main menu${NC}"
        read -p "Select option: " history_choice

        case "$history_choice" in
            1)
                header
                echo -e "${BLUE}Full Download History:${NC}"
                [ -s "$HISTORY_FILE" ] && cat -n "$HISTORY_FILE" || echo "No history found."
                ;;
            2)
                header
                echo -e "${BLUE}Search History${NC}"
                read -p "Enter search term: " search_term
                [ -s "$HISTORY_FILE" ] && {
                    echo -e "${YELLOW}Matching entries:${NC}"
                    grep -n -i "$search_term" "$HISTORY_FILE"
                } || echo "No history found."
                ;;
            3)
                header
                echo -e "${RED}Clear History${NC}"
                read -p "Confirm clear all history? (y/n): " confirm
                [ "$confirm" = "y" ] && {
                    > "$HISTORY_FILE"
                    echo -e "${GREEN}History cleared.${NC}"
                } || echo -e "${YELLOW}Cancelled.${NC}"
                ;;
            4)
                header
                echo -e "${BLUE}Export History${NC}"
                default_export="$DOWNLOAD_DIR/yt-dlp_history_$(date +%Y%m%d).log"
                read -p "Enter export path [$default_export]: " export_path
                export_path="${export_path:-$default_export}"
                [ -s "$HISTORY_FILE" ] && {
                    cp "$HISTORY_FILE" "$export_path"
                    echo -e "${GREEN}Exported to: ${YELLOW}$export_path${NC}"
                } || echo "No history to export."
                ;;
            5)
                header
                echo -e "${RED}Delete Entry${NC}"
                [ -s "$HISTORY_FILE" ] && {
                    cat -n "$HISTORY_FILE"
                    echo ""
                    read -p "Enter line number to delete: " line_num
                    [[ "$line_num" =~ ^[0-9]+$ ]] && {
                        sed -i "${line_num}d" "$HISTORY_FILE"
                        echo -e "${GREEN}Entry deleted.${NC}"
                    } || echo -e "${RED}Invalid number.${NC}"
                } || echo "No history found."
                ;;
            6) return ;;
            *) echo -e "${RED}Invalid option!${NC}" ;;
        esac
        read -p "Press Enter to continue..."
    done
}

# Show menu
show_menu() {
    header
    echo -e "${BLUE}Current Settings:${NC}"
    echo -e "Download Directory: ${YELLOW}$DOWNLOAD_DIR${NC}"
    echo -e "Format: ${YELLOW}$FORMAT${NC}"
    echo -e "Thumbnails: ${YELLOW}$THUMBNAILS${NC}"
    echo -e "Metadata: ${YELLOW}$METADATA${NC}"
    echo -e "SponsorBlock: ${YELLOW}$SPONSORBLOCK${NC}\n"
    
    echo -e "${GREEN}1. Download single video/audio\n2. Download playlist\n3. Batch download"
    echo -e "4. Change directory\n5. Change format\n6. Toggle thumbnails"
    echo -e "7. Toggle metadata\n8. Toggle SponsorBlock\n9. View history\n0. Exit${NC}\n"
    
    read -p "Select option: " choice
}

# Initialize
init() {
    [ -f "$CONFIG_FILE" ] || create_config
    load_config
    mkdir -p "$DOWNLOAD_DIR"
}

# Main function
main() {
    init
    while true; do
        show_menu
        case "$choice" in
            1)
                header
                read -p "Enter video URL: " url
                echo -e "Download as:\n1. Video\n2. Audio only"
                read -p "Select option: " media_type
                download_media "$url" false $([ "$media_type" = "2" ] && echo true || echo false)
                ;;
            2)
                header
                read -p "Enter playlist URL: " url
                echo -e "Download as:\n1. Videos\n2. Audio only"
                read -p "Select option: " media_type
                download_media "$url" true $([ "$media_type" = "2" ] && echo true || echo false)
                ;;
            3)
                header
                read -p "Enter file path with URLs: " file_path
                [ -f "$file_path" ] && {
                    while IFS= read -r url; do
                        [ -n "$url" ] && download_media "$url" false false
                    done < "$file_path"
                } || echo -e "${RED}File not found: $file_path${NC}"
                ;;
            4) change_directory ;;
            5) change_format ;;
            6) toggle_setting "THUMBNAILS" ;;
            7) toggle_setting "METADATA" ;;
            8) toggle_setting "SPONSORBLOCK" ;;
            9) view_history ;;
            0)
                echo -e "${GREEN}Exiting...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option!${NC}"
                sleep 1
                ;;
        esac
        read -p "Press Enter to continue..."
    done
}

# Start the script
main
