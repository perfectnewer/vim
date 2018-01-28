git submodule add $1 pack/plugins/start/
# update
git submodule update --recursive --remote
git clone --recursive https://github.com/aisk/.vim.git ~/.vim
