
#!/bin/bash
echo "#-------------------------------------------#"
echo "#-- RaspRoute 2017 -------------------------#"
echo "#-- by: @cryptobr - on Telegram ------------#"
echo "#-------------------------------------------#"

# Verificando existencia de rede
echo "A rede já e cadastrada ? 1 - sim 2 - nao "
read RESP

# Conectando em rede ja cadastrada
if [ "$RESP" = 1 ]
then
	echo "veja a lista das cadastradas e digite a mesma: "
	ls /etc/wpa_supplicant/
	echo ""
	read REDE
	wpa_supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant/$REDE
	dhclient wlan0
	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

# Cadastrando rede e conectando
else
	echo "Informe o SSID: "
	read SSID
	echo "Informe a senha: "
	read PASS
	echo "country=GB
	ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
	update_config=1

	network={
	ssid="$SSID"
	psk="$PASS"
	}
	" > /etc/wpa_supplicant/$SSID.conf

	wpa_supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant/$REDE
	dhclient wlan0
	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

fi
