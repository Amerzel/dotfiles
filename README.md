# This is my README

# Disable Github SSL Cert
git config --global http.sslverify false

# Vundle Setup
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Ack
curl https://beyondgrep.com/ack-2.22-single-file > ~/bin/ack && chmod 0755 ~/bin/ack