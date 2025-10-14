To update the best mirror list for your location
```shell
sudo pacman -S reflector
sudo reflector --country Bangladesh --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```
