# DuckDNS Autoscript
Đây là hướng dẫn cho việc tạo 1 script chạy tự động trên server.
> [!CAUTION]
> Hướng dẫn này chỉ áp dụng được cho IPv4, không áp dụng được cho IPv6.

## 1. Tạo script `autoduck.sh`
````
#!/bin/bash

ip=$(hostname -I | awk '{print $1}')

domain="<domain>"
token="<token>"

echo url="https://www.duckdns.org/update?domains=$domain&token=$token&ip=$ip" | curl -k -K -
````

## 2. Cấp quyền execute cho script
````
sudo chmod +x autoduck.sh
````

## 3. Tạo service
Tạo service tại `/etc/systemd/system/AutoDuck.service`
````
[Unit]
Description=Auto DuckDNS
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash <path>

[Install]
WantedBy=multi-user.target
````
