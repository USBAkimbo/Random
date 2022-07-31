# Quit by just running "e"
alias e=exit

# Make ll do an ls -la
alias ll="ls -la"

# Get public IP
alias myip='curl ipinfo.io/ip'

# Re-create latest build of ReVanced
# https://github.com/reisxd/revanced-builder/wiki/How-to-use-revanced-builder-on-Android
alias revanced="rm -rf revanced-builder-cli/ && rm -f cli.zip && wget https://github.com/reisxd/revanced-builder/archive/refs/heads/cli.zip && unzip cli.zip && cd revanced-builder-cli && npm i && node ."