```service
[Unit]
Description=qBittorrent-nox service
After=network.target mnt-nos.mount mnt-backup.mount
Requires=mnt-nos.mount mnt-backup.mount
RequiresMountsFor=/mnt/nos /mnt/backup

[Service]
Type=forking
User=taxin
ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=8080
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
### add this in here 👆️👇️
as you can see in the below command that the `sudo` is for permission, the `nvim` is an editor and the next part is path of the file
```bash
sudo nvim /etc/systemd/system/qbittorrent-nox.service
```

**Enable and start the service**:
    
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now qbittorrent-nox
```

### Verify the Status
You can now check if it's running correctly using the alias you likely have or by running:
```bash
systemctl status qbittorrent-nox
```
### restart
```bash
sudo systemctl restart qbittorrent-nox
```
