# DuckDNS Setup

## Về repository
Đây là repository hướng dẫn setup DuckDNS cho các nhiệm vụ bao gồm:
+ Tạo 1 script cho phép cập nhật địa chỉ ip (local IP) từ server lên DuckDNS server
+ Tạo 1 service cho phép thực hiện script đã tạo ở trên sau khi server khởi động
+ Setup certbot cấp Let's Encrypt certificate cho các dịch vụ như https, ftps,...

> [!WARNING]
> *Lưu ý: Hướng dẫn được tạo ra bằng chatGPT + thử nghiệm trên server ảo nên một số thứ trong hướng dẫn không hoàn toàn chính xác*

## Hướng dẫn cơ bản
### 1. Setup `duck.sh` cập nhật server IP
DuckDNS về bản chất là 1 DNS server, nơi DuckDNS domain đi kèm một IP tương ứng. Việc setup này cho phép hệ thống tự cập nhật địa chỉ IP của server trên DuckDNS server.

Đầu tiên, tạo 1 file `duck.sh` tại folder /home/*username của bạn*/duckdns/ (bạn cần tạo folder `duckdns`)
> [!WARNING]
> Bạn có thể thay đổi sang một folder khác theo ý thích. Tuy nhiêm bạn cần cập nhật path cho các hướng dẫn sau này

Thêm nội dung vào file `duck.sh`
````bash
#!/bin/bash

ip=$(hostname -I)
domain="<domain>"
token="<token>"

echo url="https://www.duckdns.org/update?domains=$domain&token=$token&ip=$ip" | curl -k -K -
````
Trong đó
+ `domain` là DuckDNS domain trên DuckDNS server (*domain*.duckdns.org)
+ `token` là token được cấp cho mỗi tài khoản (lấy tại [duckdns.org](duckdns.org))

Cấp quyền cho file `duck.sh`
````bash
$ sudo chmod +x duck.sh
````
> [!TIP]
> Bạn có thể test file để xem có hoạt động hay không<br>
> Nếu kết quả trả về là `OK` thì file `duck.sh` đã hoạt động hoàn hảo

### 2. Tạo DuckDNS Update Service
DuckDNS Update Service là 1 dịch vụ tạo ra nhằm chạy file `duck.sh` tự động sau khi server mới khởi động<br>
Service này phù hợp cho các hệ thống hay thay đổi địa chỉ IP
> [!WARNING]
> Bạn không cần service này nếu địa chỉ IP server không (hoặc ít) thay đổi

Đầu tiên, tạo service tại `/etc/systemd/system/DuckDNS.service` với nội dung sau
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

Sau đó restart systemd, enable và start DuckDNS Update Service
````bash
# Restart systemd
$ sudo systemctl daemon-reload

# Enable service
$ sudo systemctl enable DuckDNS

# Start service
$ sudo systemctl start DuckDNS
````

Vậy là DuckDNS Update Service đã hoàn thành!!<br>
Từ giờ, việc cập nhật IP đã tự động hoàn toàn.

#### 3. Setup Certbot
Đối với các dịch vụ HTTPS, FTPS hoặc các dịch vụ cần certificate, việc tạo 1 certificate cho DuckDNS domain là cần thiết

Đầu tiên, setup certbot vào server của bạn.

Sau đó tạo script cập nhật DuckDNS `certbot.sh`. Script này cho phép cập nhật domain từ DuckDNS server để Certbot tạo certificate
````bash
#!/bin/bash

DOMAIN="_acme-challenge.example.duckdns.org"
TOKEN="YOUR_DUCKDNS_TOKEN"

curl -s "https://www.duckdns.org/update?domains=example&token=$TOKEN&txt=$CERTBOT_VALIDATION"
````
Sau đó cấp quyền execute cho `certbot.sh`
````
$ sudo chmod +x certbot.sh
````
> [!WARNING]
> Bạn cần thay token của bạn vào `certbot.sh`

Tiếp đó, tạo chứng chỉ bằng Certbot
````
sudo certbot certonly --manual --preferred-challenges dns --manual-auth-hook ./certbot.sh -d example.duckdns.org
````
**Và bạn đã có chứng chỉ từ Let's Encrypt!!!**<br>
Bạn có thể dùng chứng chỉ đã cấp cho các dịch vụ cần SSL

> [!TIP]
> Đối với renew chứng chỉ (do chứng chỉ chỉ có hiệu lực khoảng 2 tháng)**
> ````
> sudo certbot renew --manual-auth-hook ./certbot.sh
> ````

## Hoàn thành
Vậy là bạn đã setup DuckDNS cho server của bạn!!!<br>
Chúc bạn may mắn,<br>
*Phatcraft.*

> Các hướng dẫn cho từng phần nằm ở trong các file `.txt` trong repository<br>
> Bạn có thể xem nếu cần thiết
