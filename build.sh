#!/bin/bash

api_latest_release="https://api.github.com/repos/glpi-project/glpi/releases/latest"
glpi_release_url=$(curl -s $api_latest_release | grep -Po '(?<="browser_download_url": ")[^"]*')
glpi_version=$(curl -s $api_latest_release | grep -Po '(?<="tag_name": ")[^"]*')
glpi_orig_filename="glpi-$version.orig.tar.gz"

echo "url: $glpi_release_url"
echo "version: $glpi_version"
echo "filename: $glpi_orig_filename"

# prepate folders
mkdir tarballs
mkdir sources
mkdir bin_package

# download release
wget --no-check-certificate -O tarballs/$glpi_orig_filename $glpi_release_url

# extract
tar xf tarballs/$glpi_orig_filename sources

# clean
git clean -f