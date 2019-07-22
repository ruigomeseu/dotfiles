export ZSH=~/.oh-my-zsh

if [ ! -d $ZSH ]; then
  git clone https://github.com/robbyrussell/oh-my-zsh.git $ZSH
  chsh -s $(which zsh)
fi

spaceship=$ZSH/custom/themes/spaceship-prompt

if [ ! -d $spaceship ]; then
  git clone https://github.com/denysdovhan/spaceship-prompt.git $spaceship
  ln -s "$spaceship/spaceship.zsh-theme" "$ZSH/custom/themes/spaceship.zsh-theme"
fi
