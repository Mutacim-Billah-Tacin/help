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

**Enable and start the service**:
    
```bash
sn /etc/systemd/system/qbittorrent-nox.service
sudo systemctl daemon-reload
sudo systemctl enable --now qbittorrent-nox
```

### Verify the Status
You can now check if it's running correctly using the alias you likely have or by running:
```bash
systemctl status qbittorrent-nox
```
## restart
```bash
systemctl restart qbittorrent-nox
```
