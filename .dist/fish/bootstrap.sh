
#!/bin/bash
which -s fish || brew install fish

if grep -qF "fish" /etc/shells;then
    echo 'fish is already in /etc/shells'
else
    echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
fi

if [[ $SHELL != *"fish" ]]; then
    chsh -s /usr/local/bin/fish
fi

curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

[ -e ~/.config/fish/config.fish ] && rm ~/.config/fish/config.fish
[ -e ~/.config/fish/fishfile ] && rm ~/.config/fish/fishfile
ln -s $(pwd)/.dist/fish/config.fish ~/.config/fish/config.fish
ln -s $(pwd)/.dist/fish/fishfile ~/.config/fish/fishfile
