#!/bin/bash

DEBFULLNAME="Alexandre DELAUNAY"
DEBMAIL="delaunay.alexandre@gmail.com"
gpg_key=C584C02F
export DEBMAIL DEBFULLNAME

api_latest_release="https://api.github.com/repos/glpi-project/glpi/releases/latest"
glpi_release_url=$(curl -s $api_latest_release | grep -Po '(?<="browser_download_url": ")[^"]*')
glpi_version=$(curl -s $api_latest_release | grep -Po '(?<="tag_name": ")[^"]*')
glpi_orig_filename="glpi_$glpi_version.orig.tar.gz"
cliupdate_file_url="https://raw.githubusercontent.com/glpi-project/glpi/$glpi_version/tools/cliupdate.php"

echo "url: $glpi_release_url"
echo "version: $glpi_version"
echo "filename: $glpi_orig_filename"


# prepare folders
mkdir -p sources
mkdir -p packages


# download release
wget --no-check-certificate -O sources/$glpi_orig_filename $glpi_release_url

# download update script
wget --no-check-certificate -O sources/cliupdate.php $cliupdate_file_url


# extract
cd sources
tar xf $glpi_orig_filename
mv glpi glpi-$glpi_version



# bootstrap debian package
cd glpi-$glpi_version
dh_make --yes -c gpl2  --single \
 --file ../../sources/$glpi_orig_filename
cd debian
rm -rf *ex *EX README*

# insert cliupdate
mv ../../cliupdate.php .


# copy and fill templates
cp -R ../../../templates/* .
find . -type f -exec sed -i -e "s/__FULLNAME__/$DEBFULLNAME/" -e "s/__MAIL__/$DEBMAIL/" {} \;


#generate deb
cd ..
debuild -k0x$gpg_key -S -sa --lintian-opts -i
cd ..
sudo pbuilder build *.dsc


# move deb files
sudo mv /var/cache/pbuilder/result/* ../packages


# clean (removed untracked files and folders)
#git clean -f -d