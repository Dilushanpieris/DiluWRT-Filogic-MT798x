#!/bin/sh

# ------------------------------------------------------------------
# --- Configuration ---
# ------------------------------------------------------------------

# Theme Packages
PKG1_URL="https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/Themes/luci-app-argon-config_0.9_all.ipk"
PKG1_NAME="luci-app-argon-config_0.9_all.ipk"
PKG2_URL="https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/Themes/luci-theme-argon_2.3.2-r20250207_all.ipk"
PKG2_NAME="luci-theme-argon_2.3.2-r20250207_all.ipk"

# Background Image Files
URL_4K="https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/Themes/4K_DiluWRT.png"
URL_1080P="https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/Themes/MainPage.png"

# Directories
TMP_DIR="/tmp"
TOKEN_FILE="/etc/auth/.github_token"
ARGON_DIR="/www/luci-static/argon"
TARGET_DIR="$ARGON_DIR/background"

# ------------------------------------------------------------------
# --- Pre-Checks and Helper Functions ---
# ------------------------------------------------------------------

# Check for the GitHub token
if [ ! -f "$TOKEN_FILE" ]; then
    echo "Please ensure you have stored your Personal Access Token (PAT) first."
    exit 1
fi

AUTH_HEADER="Authorization: token $(cat "$TOKEN_FILE")"

# Function to handle download, install, and cleanup for a single package
install_package() {
    URL=$1
    FILENAME=$2
    TEMP_PATH="$TMP_DIR/$FILENAME"

    echo "--------------------------------------------------------"
    echo "Starting download for: $FILENAME"
    
    # Download the package using the authorized header
    wget -O "$TEMP_PATH" --no-check-certificate --header="$AUTH_HEADER" "$URL"
    
    if [ $? -eq 0 ]; then
        echo "Download successful. Installing..."
        
        # Install the package
        opkg install "$TEMP_PATH"
        
        if [ $? -eq 0 ]; then
            echo "Installation of $FILENAME complete."
        else
            echo "Error: opkg installation failed for $FILENAME. Check dependencies."
        fi
        
        # Cleanup
        rm -f "$TEMP_PATH"
        echo "Cleaned up temporary file: $TEMP_PATH"
        
    else
        echo "Error: Download failed for $FILENAME. Check the URL and token permissions."
        # Attempt to clean up any partial file
        rm -f "$TEMP_PATH"
        # Continue execution to attempt the next package/step, but log the error
    fi
}

# ------------------------------------------------------------------
# --- STEP 1: Install Argon Theme Packages (CORRECTED ORDER) ---
# ------------------------------------------------------------------

# 1. Install the base Argon Theme package (PKG2)
install_package "$PKG2_URL" "$PKG2_NAME"

# 2. Install the Argon Config package (PKG1)
install_package "$PKG1_URL" "$PKG1_NAME"

echo "--------------------------------------------------------"
echo "Argon Theme packages installation finished."
echo "--------------------------------------------------------"

# ------------------------------------------------------------------
# --- STEP 2: Install Background Image ---
# ------------------------------------------------------------------

echo "Beginning background image installation..."

# 1. Verify Argon Theme Installation (in case opkg failed)
if [ ! -d "$ARGON_DIR" ]; then
    echo "Error: Argon theme directory not found at $ARGON_DIR after installation."
    echo "Skipping background installation."
    exit 1
fi

# 2. Ensure target subdirectory exists and clear its contents
echo "Argon theme directory verified. Creating and clearing target background directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

# Clear existing contents
rm -f "$TARGET_DIR"/*

# 3. Define file options and gather user input
echo "----------------------------------------------------"
echo "Select a background image to install:"
echo "1) 4K_DiluWRT.png (High resolution, approx. 3MB+)"
echo "2) MainPage.png (1080p resolution, recommended for limited space/older devices)"
echo "----------------------------------------------------"

read -p "Enter choice (1 or 2): " CHOICE

case "$CHOICE" in
    1) 
        DOWNLOAD_URL="$URL_4K"
        DOWNLOAD_NAME="4K_DiluWRT.png"
        ;;
    2)
        DOWNLOAD_URL="$URL_1080P"
        DOWNLOAD_NAME="MainPage.png"
        ;;
    *)
        echo "Invalid choice. Skipping background installation."
        exit 1
        ;;
esac

TEMP_PATH="/tmp/$DOWNLOAD_NAME"
FINAL_PATH="$TARGET_DIR/$DOWNLOAD_NAME"

# 4. Download and Install
echo "Starting download for: $DOWNLOAD_NAME"

# Download the selected image using the authorized header
wget -O "$TEMP_PATH" --no-check-certificate --header="$AUTH_HEADER" "$DOWNLOAD_URL"

if [ $? -ne 0 ]; then
    echo "Error: Download failed for $DOWNLOAD_NAME. Check URL and token."
    rm -f "$TEMP_PATH"
    # Exit gracefully without halting the script, as packages were installed.
    exit 1 
fi

echo "Download successful. Installing to $TARGET_DIR..."

# Move the downloaded file to the final destination
mv "$TEMP_PATH" "$FINAL_PATH"

# Set permissions for web access
chmod 644 "$FINAL_PATH"

# ------------------------------------------------------------------
# --- Final Conclusion ---
# ------------------------------------------------------------------

echo "----------------------------------------------------"
echo "All Argon theme components have been installed."
echo "Background file installed at: $FINAL_PATH"
echo "Please reload LuCI and clear your browser cache to see the new theme and background."
echo "----------------------------------------------------"