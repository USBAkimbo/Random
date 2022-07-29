clear
echo ===============
echo Starting update
echo ===============

pkg update -y
pkg upgrade -y
apt autoremove -y
pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U

echo ===============
echo Update complete
echo ===============