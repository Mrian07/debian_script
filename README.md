# Linux Debian-10.04 LTS (Buster)

<br>

### **Performance & Speed**
Pelayan VPN kami dibina untuk kelajuan. Anda akan segera menyedari bahawa pelayan VPN kami dioptimumkan untuk memaksimumkan kelajuan internet anda, sambil mengekalkan privasi anda.

### **No Restrictions**
Nyahsekat mana-mana tapak web atau perkhidmatan, kami tidak menyekat mana-mana port atau tapak web supaya anda boleh bermain apa-apa permainan atau menggunakan sebarang program.

### **Strong Encryption**
Kami memahami betapa pentingnya untuk anda menjadi anonymous dan secure. Semua trafik antara anda dan VPN disulitkan menggunakan teknik penyulitan terbaik seperti AES-256 dan AES-128.

### **Unlimited Bandwidth**
Nikmati kelajuan tanpa had dan trafik tanpa had, sama ada anda ingin menonton filem, memuat turun atau menjalankan sebarang aplikasi.

### **100% Anonymity**
Dengan pelayan VPN yang kami sediakan, tidak ada sebarang trafik pelayaran internet anda akan tersimpan. Yang dilog adalah alamat IP anda dan masa sambungan dibuat.

### **No Data Limitation**
Kami tahu bahawa ISP anda telah menetapkan had data yang boleh anda gunakan, dengan VPN kami terdapat kemungkinan untuk memintas had data tersebut dengan pengubahsuaian dengan sambungan anda.

<br>

```
Package -> Services:-
[ ✅ ] nginx
[ ✅ ] dropbear
[ ✅ ] openvpn
[ ✅ ] shadowsocks
[ ✅ ] v2ray
[ ✅ ] xray
[ ❎ ] wireguard
[ ✅ ] squid
[ ✅ ] stunnel
[ ✅ ] badvpn
[ ✅ ] simple-obfs
[ ✅ ] ohpserver
[ ✅ ] websocket
[ ✅ ] fail2ban
[ ✅ ] torrent-block
[ ✅ ] iptables
```

```
Plugins -> Menus -> Accounts:-
[ ✅ ] dropbear
[ ✅ ] openvpn
[ ❎ ] shadowsocks
[ ❎ ] v2ray
[ ❎ ] xray
[ ❎ ] wireguard
```

```
Plugins -> Menus -> Services:-
[ ❎ ] nginx
[ ❎ ] dropbear
[ ❎ ] openvpn
[ ❎ ] shadowsocks
[ ❎ ] v2ray
[ ❎ ] xray
[ ❎ ] wireguard
[ ❎ ] squid
[ ❎ ] stunnel
[ ❎ ] badvpn-udpgw
[ ❎ ] simple-obfs
[ ❎ ] ohpserver
[ ❎ ] websocket
[ ❎ ] fail2ban
[ ❎ ] torrent-block
[ ❎ ] iptables
```

```
Plugins -> Menus -> Server:-
[ ❎ ] Backup
[ ❎ ] Restore
[ ❎ ] Details
[ ❎ ] Howto
[ ❎ ] Readme
[ ❎ ] CloudFlare
[ ❎ ] DigitalOcean
```
<br>

### **Howto**

<br>

1. Make sure you already have domain, this is needed for package installation and configuration, if you do not have domain yet you can create domian for free from https://freenom.com and change the DNS Name with CloudFlare DNS.

2. Create and Login to your CloudFlare account and add new site follow your domain from Freenom and add DNS record. *Example:-*

    <br>

    | Type | Name | Content | Proxy Status | TTL | Action |
    | ----- | ---- | ---- | ---- | ---- | ---- |
    | A | cybertize.tk | 157.245.61.222 | DNS only | Auto | Edit |
    | A | www.cybertize.tk | 157.245.61.222 | DNS only | Auto | Edit |
    | A | v2ray.cybertize.tk | 157.245.61.222 | DNS only | Auto | Edit |
    | A | xray.cybertize.tk | 157.245.61.222 | DNS only | Auto | Edit |

    <br>

    Make sure your SSL/TLS option on CloudFlare is **Full**\.

3. Copy & paste code below to your terminal.

    ```
    wget -q https://raw.githubusercontent.com/cybertize/buster/fate/install.sh && chmod +x ~/install.sh && ~./install.sh
    ```

<br>

### By creating new account with this [referral link](https://m.do.co/c/6c18acb9480b) you will earn $100 credit into your digitalocean account that valid for 60 days.
