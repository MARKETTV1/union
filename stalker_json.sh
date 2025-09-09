clear
echo "=============================================="
echo "             list stalker.json"
echo "             update: 09/09/2025"
echo "=============================================="
echo ""

wget -O /usr/lib/enigma2/python/Plugins/Extensions/Uni_Stalker/Servers/Stalker.json https://raw.githubusercontent.com/MARKETTV1/union/refs/heads/main/Stalker.json && killall -9 enigma2
