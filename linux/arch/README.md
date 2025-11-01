To update the best mirror list for your location
```shell
sudo pacman -S reflector
sudo reflector --country Bangladesh --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```
## AUR setup  
change the DLAGENTS from /etc/makepkg.conf  
```conf
DLAGENTS=(
  'ftp::/usr/bin/aria2c -c -x16 -s16 -j32 -m10 -k1M --timeout=15 --retry-wait=2 --file-allocation=none --enable-http-pipelining=true --enable-http-keep-alive=true --summary-interval=0 -o %o %u'
  'http::/usr/bin/aria2c -c -x16 -s16 -j32 -m10 -k1M --timeout=15 --retry-wait=2 --file-allocation=none --enable-http-pipelining=true --enable-http-keep-alive=true --summary-interval=0 -o %o %u'
  'https::/usr/bin/aria2c -c -x16 -s16 -j32 -m10 -k1M --timeout=15 --retry-wait=2 --file-allocation=none --enable-http-pipelining=true --enable-http-keep-alive=true --summary-interval=0 -o %o %u'
  'rsync::/usr/bin/rsync -z %u %o'
  'scp::/usr/bin/scp -C %u %o'
)
```
