
wget -O /tmp/Uni_Stalker.tar.gz https://github.com/MARKETTV1/union/raw/refs/heads/main/Uni_Stalker.tar.gz

cd /tmp/

tar -xzf Uni_Stalker.tar.gz -C /usr/lib/enigma2/python/Plugins/Extensions/

rm /tmp/Uni_Stalker.tar.gz

opkg update && opkg install python3-psutil
killall -9 enigma2
