# DuckDNS Update Service
Hướng dẫn này cho phép tạo 1 service nhằm chạy DuckDNS Update Script tự động hoàn toàn

> [!CAUTION]
> Service này chỉ phù hợp đối với server hay thay đổi địa chỉ IP.<br>
> Nếu server của bạn không (hay ít) thay đổi địa chỉ IP hoặc dùng public IP, bạn có thể bỏ qua phần này

## 1. Tạo DuckDNS Update Service
Tạo `DuckDNS Update Service` tại `/etc/systemd/system/DuckDNS.service` với nội dung sau
````bash
[Unit]
Description=DuckDNS Update Service
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash /home/<username>/duckdns/duck.sh
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
````

## 2. Restart `systemd` và start service
Bạn cần restart `systemd`, start và enable DuckDNS Update Service
+ Restart `systemd`
````
$sudo systemd daemon-reload
````

+ Enable và start service
````
$ sudo systemctl enable DuckDNS
$ sudo systemctl start DuckDNS
````

## 3. Hoàn thành
Vậy là bạn đã hoàn thành hướng dẫn này.<br>
Từ giờ, bạn có thể update IP tự động ngay sau khi chạy server.
