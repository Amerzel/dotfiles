# James Whiteneck's Dotfiles

# Setup
```
clone this repository into $HOME/.dotfiles
$HOME/.dotfiles/setup.sh
```

## Some Commands Typically Run After Setup
### NVM
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
```

### Vundle Setup
```
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### Ack
```
curl https://beyondgrep.com/ack-2.22-single-file > ~/bin/ack && chmod 0755 ~/bin/ack
```

### ZSH Plugins
```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
chmod g-w,o-w .oh-my-zsh/custom/plugins/zsh-autosuggestions
chmod g-w,o-w .oh-my-zsh/custom/plugins/zsh-syntax-highlighting
chmod g-w,o-w .oh-my-zsh/custom/plugins/zsh-z
```

### Homebrew Packages
```
brew install diff-so-fancy
brew cask install insomnia
```
