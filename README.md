# prerequisite

* deb packages:
```sh
apt install debhelper cdbs lintian build-essential fakeroot devscripts pbuilder dh-make debootstrap
```

* gpg key (note you key sub part after slash):
```sh
gpg --gen-key
```

* pbuilder:
```sh
echo "COMPONENTS=\"main restricted universe multiverse\"" | sudo tee -a /etc/pbuilderrc
sudo pbuilder create
sudo pbuilder update
```


# prepare package

Edit build.sh with your vars
edit files in template to match glpi version

# generate package

```sh
./build.sh
```