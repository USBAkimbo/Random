# Update Termux config by pulling from this repo
alias config-update="curl https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/setup.sh | bash"

# Quit by just running "e"
alias e=exit

# Make ll list all files in human readable format
alias ll="ls -lha"

# Get public IP
alias myip='curl ipinfo.io/ip'

# cd to download folder
alias dl="cd /storage/emulated/0/Download"

# Re-create latest build of ReVanced
# https://github.com/reisxd/revanced-builder/wiki/How-to-use-revanced-builder-on-Android
alias revanced="rm -rf revanced-builder-cli/ && rm -f cli.zip && wget https://github.com/reisxd/revanced-builder/archive/refs/heads/cli.zip && unzip cli.zip && cd revanced-builder-cli && npm i && node ."