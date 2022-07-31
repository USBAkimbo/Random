# Quit by just running "e"
alias e=exit

# Re-create latest build of ReVanced
# https://github.com/reisxd/revanced-builder/wiki/How-to-use-revanced-builder-on-Android
alias revanced='rm -r revanced-builder-cli/ && rm cli.zip && wget https://github.com/reisxd/revanced-builder/archive/refs/heads/cli.zip && unzip cli.zip && cd revanced-builder-cli && npm i && node .'