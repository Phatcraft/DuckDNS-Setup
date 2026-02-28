# DuckDNS Certbot
Hướng dẫn này cho phép tạo certificate cho DuckDNS domain thông qua Certbot.<br>
Việc tạo certificate cho phép dùng cho các dịch vụ cần SSL (HTTPS, FTPS,...)

## 1. Cài đặt Certbot
Bạn cần cài đặt Certbot thông qua các package `apt` hoặc `dnf`

## 2. Tạo file `certbot.sh`
File này được tạo ra nhằm hỗ trợ việc tạo certificate bằng DNS Challenge.<br>
Nội dung file:
````bash
#!/bin/bash

DOMAIN="_acme-challenge.example.duckdns.org"
TOKEN="<token>"

curl -s "https://www.duckdns.org/update?domains=<domain>&token=$TOKEN&txt=$CERTBOT_VALIDATION"
````
Trong đó:
+ `<domain>` là DuckDNS domain theo cấu trúc `<domain>.duckdns.org`
+ `<token>` là token của mỗi tài khoản trên DuckDNS

> [!CAUTION]
> Script này chỉ hoạt động ổn định cho Local IP nhưng vẫn chưa thử nghiệm đối với public IP

## 3. Tạo chứng chỉ 
Bạn có thể tạo chứng chỉ của Let's Encrypt
````bash
$ sudo certbot certonly --manual --preferred-challenges dns --manual-auth-hook ./certbot.sh -d example.duckdns.org
````
> Bạn cần thay đổi domain thành DuckDNS domain của bạn

Từ giờ, bạn có thể dùng chứng chỉ cho các dịch vụ cần SSL.<br>
Chứng chỉ này đã được công nhận bởi Let's Encrypt và đều được công nhận bởi tất cả các browser hiện nay.

## 4. Renew chứng chỉ
Dù chứng chỉ này đã được công nhận, thời hạn của chứng chỉ này chỉ kéo dài khoảng 3-4 tháng.<br>
Bạn cần renew chứng chỉ để sử dụng bình thường.

Bạn có thể renew thông qua certbot
````bash
$ sudo certbot renew --manual-auth-hook ./certbot.sh
````

## 5. Hoàn thành
Vậy là bạn đã hoàn thành việc tạo certificate cho server!!!
