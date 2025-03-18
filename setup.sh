#!/bin/bash

# install packages
sudo DEBIAN_FRONTEND=noninteractive apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y zsh curl git fonts-powerline unzip vim bat

# Nerd Fonts(JetBrainsMono)
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
rm JetBrainsMono.zip
fc-cache -fv

# Oh My Zsh
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Default Shell
sudo chsh -s $(which zsh) $USER

# Oh My Zsh - plugin(Syntax Highlighting, Autosuggestions)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install

# bat
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

# .zshrc
cat << 'EOF' > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:$HOME/.local/bin

ZSH_THEME="agnoster"
plugins=(git colored-man-pages zsh-syntax-highlighting zsh-autosuggestions fzf kubectl docker)
source $ZSH/oh-my-zsh.sh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Language
export LC_ALL=C.UTF-8
EOF

# alias
#alias cat='bat -pp'


######
# Vim

mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git clone https://github.com/preservim/vim-indent-guides.git ~/.vim/bundle/vim-indent-guides

# .vimrc
cat << 'EOF' > ~/.vimrc

" Enable Pathogen
execute pathogen#infect()

" Basic vim settings
set nu
syntax on
set ts=4
set clipboard=unnamed
set hlsearch
set incsearch
set mouse=a
set fileencoding=utf-8
filetype plugin indent on

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0

highlight IndentGuidesOdd  guibg=#4e4e4e ctermbg=239
highlight IndentGuidesEven guibg=#5c5c5c ctermbg=241

" YAML
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab autoindent

" C/CPP Header File
function! s:guard()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename
  execute "normal! o#endif"
  normal! ko
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>guard()

EOF

# cd HOME
cd ~

# zsh Start
echo 
echo "     Installation complete. Starting zsh..."
echo
exec zsh
