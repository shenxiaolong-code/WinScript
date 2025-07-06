
echo "enable ping services for remote users"
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
netsh advfirewall firewall add rule name="ICMP Allow incoming V6 echo request" protocol=icmpv6:8,any dir=in action=allow

echo "verify whether ping service is enabled"
netsh advfirewall firewall show rule name="ICMP Allow incoming V4 echo request"
netsh advfirewall firewall show rule name="ICMP Allow incoming V6 echo request"


echo "open port 22"
netsh advfirewall firewall add rule name="Open Port 22" dir=in action=allow protocol=TCP localport=22

echo "verify port 22"
netsh advfirewall firewall show rule name="Open Port 22"

:: close port 22
:: echo "close port 22"
:: netsh advfirewall firewall delete rule name="Open Port 22"