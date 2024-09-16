#!/bin/bash

set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to download a file
download_file() {
    if command_exists curl; then
        curl -L -o "$2" "$1"
    else
        echo "Error: curl is not installed. Please install curl to proceed."
        exit 1
    fi
}

# Detect Mac architecture
if [[ $(uname -m) == 'arm64' ]]; then
    NODE_ARCH="arm64"
else
    NODE_ARCH="x64"
fi

# Input phase for URL
read -p "Enter the URL you want to open in the browser windows: " target_url

# Validate URL (basic check)
if [[ ! $target_url =~ ^https?:// ]]; then
    echo "Invalid URL. Please enter a URL starting with http:// or https://"
    exit 1
fi

# Ask for the limit
read -p "Enter the upper limit of browser windows (default is 20): " upper_limit
upper_limit=${upper_limit:-20}

# Validate upper_limit is a positive integer
if ! [[ "$upper_limit" =~ ^[1-9][0-9]*$ ]]; then
    echo "Invalid input. Using default limit of 20."
    upper_limit=20
fi

echo "Using URL: $target_url"
echo "Upper limit of browser windows: $upper_limit"
echo "Detected architecture: $NODE_ARCH"

# 1. Download the GitHub repo
echo "Downloading the GitHub repo..."
repo_url="https://github.com/neelr/bruinbash/archive/refs/heads/master.zip"
download_file "$repo_url" "bruinbash.zip"

# Extract the zip file
unzip bruinbash.zip
cd bruinbash-master

# 2. Download and install Node.js and Yarn
echo "Downloading Node.js for $NODE_ARCH..."
node_url="https://nodejs.org/dist/v18.16.0/node-v18.16.0-darwin-${NODE_ARCH}.tar.gz"
download_file "$node_url" "node.tar.gz"

echo "Extracting Node.js..."
tar -xzf node.tar.gz
mv node-v18.16.0-darwin-${NODE_ARCH} node

echo "Setting up Node.js..."
export PATH="$PWD/node/bin:$PATH"

echo "Installing Yarn..."
npm install -g yarn

# 3. Install dependencies and run the script
echo "Installing project dependencies..."
yarn install --ignore-engines

if [ $? -ne 0 ]; then
    echo "Failed to install dependencies. Trying with npm..."
    npm install --no-package-lock
fi

echo "Running the script..."
node index.js "$target_url" --limit "$upper_limit"

# Cleanup
echo "Cleaning up..."
cd ..
rm -rf bruinbash.zip bruinbash-master

echo "Script execution completed."