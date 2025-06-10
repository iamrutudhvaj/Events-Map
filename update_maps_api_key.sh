#!/bin/bash
# Cross-platform script to update Google Maps API key
# Works on macOS (bash/zsh) and Windows (with Git Bash or WSL)

# Determine the manifest file path relative to the script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST_PATH="${SCRIPT_DIR}/android/app/src/main/AndroidManifest.xml"

# Check if the manifest file exists
if [ ! -f "$MANIFEST_PATH" ]; then
    echo "Error: AndroidManifest.xml not found at $MANIFEST_PATH"
    exit 1
fi

# Prompt for the API key
echo "Please enter your Google Maps API key:"
read API_KEY

# Exit if no key was provided
if [ -z "$API_KEY" ]; then
    echo "No API key provided. Exiting without making changes."
    exit 1
fi

# Create a backup of the original file
cp "$MANIFEST_PATH" "${MANIFEST_PATH}.bak"
echo "Created backup at ${MANIFEST_PATH}.bak"

# Replace the placeholder with the provided API key
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
    # macOS or Linux (using sed)
    sed -i.tmp "s/android:value=\"YOUR_API_KEY\"/android:value=\"$API_KEY\"/" "$MANIFEST_PATH"
    rm "${MANIFEST_PATH}.tmp"
else
    # Windows (using PowerShell)
    # This will be executed by Git Bash on Windows
    powershell.exe -Command "(Get-Content '$MANIFEST_PATH') -replace 'android:value=\"YOUR_API_KEY\"', 'android:value=\"$API_KEY\"' | Set-Content '$MANIFEST_PATH'"
fi

# Verify the change
if grep -q "android:value=\"$API_KEY\"" "$MANIFEST_PATH"; then
    echo "Success! Google Maps API key has been updated in AndroidManifest.xml"
else
    echo "Error: Failed to update the API key. Please check the file manually."
    echo "The original file has been backed up to ${MANIFEST_PATH}.bak"
fi
