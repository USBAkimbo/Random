clear
echo ===============
echo Starting update
echo ===============

pkg update -y
pkg upgrade -y
apt autoremove -y
pip install -U yt-dlp

echo ===============
echo Update complete
echo ===============