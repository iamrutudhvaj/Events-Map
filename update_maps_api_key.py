#!/usr/bin/env python3
"""
Cross-platform script to update Google Maps API key in AndroidManifest.xml
Works on Windows, macOS, and Linux
"""

import os
import sys
import re
import shutil
from pathlib import Path

def main():
    # Determine the manifest file path relative to the script location
    script_dir = Path(os.path.dirname(os.path.abspath(__file__)))
    manifest_path = script_dir / "android" / "app" / "src" / "main" / "AndroidManifest.xml"
    
    # Check if the manifest file exists
    if not manifest_path.exists():
        print(f"Error: AndroidManifest.xml not found at {manifest_path}")
        sys.exit(1)
    
    # Prompt for the API key
    print("Please enter your Google Maps API key:")
    api_key = input().strip()
    
    # Exit if no key was provided
    if not api_key:
        print("No API key provided. Exiting without making changes.")
        sys.exit(1)
    
    # Create a backup of the original file
    backup_path = str(manifest_path) + ".bak"
    shutil.copy2(manifest_path, backup_path)
    print(f"Created backup at {backup_path}")
    
    # Read the manifest file
    with open(manifest_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Replace the placeholder with the provided API key
    new_content = re.sub(r'android:value="YOUR_API_KEY"', f'android:value="{api_key}"', content)
    
    # Write the updated content back to the file
    with open(manifest_path, 'w', encoding='utf-8') as file:
        file.write(new_content)
    
    # Verify the change
    if f'android:value="{api_key}"' in new_content:
        print("Success! Google Maps API key has been updated in AndroidManifest.xml")
    else:
        print("Error: Failed to update the API key. Please check the file manually.")
        print(f"The original file has been backed up to {backup_path}")

if __name__ == "__main__":
    main()
