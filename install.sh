
wget -O /tmp/Uni_Stalker.tar.gz https://github.com/MARKETTV1/union/raw/refs/heads/main/Uni_Stalker.tar.gz

cd /tmp/

tar -xzf Uni_Stalker.tar.gz -C /usr/lib/enigma2/python/Plugins/Extensions/

killall -9 enigma2
