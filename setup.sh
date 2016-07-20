add-apt-repository ppa:ubuntu-lxc/lxd-stable # For Go-Lang
add-apt-repository ppa:neovim-ppa/unstable # For nvim
apt update
apt install python-dev python-pip python3-dev python3-pip
apt install nodejs
apt install golang
apt install zsh
apt install vim vim-gtk nvim 
chsh -s /bin/zsh
zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
sh ~/.fzf/install
npm install -g nyaovim
cp -Rf ./vim ~/.vim
cp ./vimrc ~/.vimrc
cp ./tmux.conf ~/.tmux.conf
cp ./zshrc ~/.zshrc
echo 'Enjoy Tmux-Vim-FZF setup'
