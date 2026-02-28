# Setup DuckDNS và Update IP Script
Hướng dẫn này sẽ giúp setup 1 DuckDNS domain và tạo 1 script nhằm update IP lên DuckDNS server

## 1. Đăng ký tài khoản trên DuckDNS
Đầu tiên, bạn cần tạo tài khoản trên [DuckDNS](https://www.duckdns.org).<br>
Sau khi đã có tài khoản DuckDNS, bạn có thể tạo subdomain của bạn free (tối đa 5 subdomain).<br>
Sau khi tạo subdomain, bạn có thể thay đổi IP trên DuckDNS.

## 2. Tạo DuckDNS Update Script
DuckDNS Update script là 1 Linux script cho phép cập nhật địa chỉ local IP lên DuckDNS server
> [!CAUTION]
> Nếu bạn dùng public IP, bạn cần xem hướng dẫn chính thức của DuckDNS tại [đây](https://www.duckdns.org/install.jsp)

### 2.1. Tạo file script
Tạo file `/home/*username*/duckdns/duck.sh` với nội dung sau
````bash
#!/bin/bash

ip=$(hostname -I | awk '{print $1}')
ip6=$(hostname -I | awk '{print $2}')
domain="<domain>"
token="<token>"

# Get Ipv4
echo url="https://www.duckdns.org/update?domains=$domain&token=$token&ip=$ip" | curl -k -K -

# Get Ipv6
echo url="https://www.duckdns.org/update?domains=$domain&token=$token&ipv6=$ip6" | curl -k -K -
````
Trong đó:
+ `<domain>` là DuckDNS domain với cấu trúc `<domain>.duckdns.org`
+ `<token>` là token đươc cấp cho mỗi tài khoản trên [DuckDNS](https://www.duckdns.org)

> [!WARNING]
> Bạn có thể để file ở bất kỳ `path` nào bạn muốn<br>
> Tuy nhiên, bạn cần cập nhật `path` cho các hướng dẫn sau này 

### 2.2. Cấp quyền execute cho file `duck.sh`
Bạn cần cấp quyền execute nhằm đảm bảo file `duck.sh` chạy được
````
$ sudo chmod +x duck.sh
````

## 3. Hoàn thành
Vậy là bạn đã hoàn thành việc setup DuckDNS và Update IP script<br>
Bạn có thể test thử nhằm đảm bảo mọi thứ hoạt động.<br>

+ Kiểm tra domain có trả đúng IP hay không
````
$ nslookup <domain>.duckdns.org
````

+ Ping bằng domain
````
$ ping <domain>.duckdns.org
````
