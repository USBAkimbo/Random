clear
echo ===============
echo Starting update
echo ===============

pkg update
pkg upgrade -y
youtube-dl -U
pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U

echo ===============
echo Update complete
echo ===============