#!/bin/bash
#
# afterFormat.sh - Instala todos os softwares selecionados. O PC deve estar
#                  conectado à internet. O tempo de instalação dependerá da
#                  velocidade de sua conexão.
#
# ------------------------------------------------------------------------------
#
# The MIT License
#
# Copyright (c) 2012 Hugo Henriques Maia Vieira
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# ==========================    Variáveis    ===================================

# Mandinga para pegar o diretório onde o script foi executado
FOLDER=$(dirname $(readlink -f $0))

FINAL_MSG=''

# Pegando arquitetura do sistema. Valores de retorno: '32-bit' ou '64-bit'
arquitetura=`file /bin/bash | cut -d' ' -f3`

vim=0

#================================ Menu =========================================

# Instala o dialog
sudo apt-get install -y dialog > /dev/null

opcoes=$( dialog --stdout --separate-output                                                     \
    --title "afterFormat - Pós Formatação para a versão 13.04 do Ubuntu e 15 do Linux Mint"     \
    --checklist 'Selecione os softwares que deseja instalar:' 0 0 0                             \
    Desktop           "Muda \"Área de Trabalho\" para \"Desktop\" *(Apenas ptBR)"             ON  \
    SSH               "SSH server e client"                                                   ON  \
    Terminator        "Terminal mais podereso"                                                ON  \
    MySql             "Banco de dados"                                                        OFF \
    PostgreSQL        "Banco de dados"                                                        ON  \
    Nodejs            "Nodejs e npm (node packaged modules)"                                  ON  \
    Rbenv             "rbenv + Ruby (atual)"                                                  ON  \
    Java              "Java Development Kit"                                                  ON  \
    VIM               "Editor de texto + configurações úteis"                                 ON  \
    Git               "Sistema de controle de versão + configurações úteis"                   ON  \
    Inkscape          "Software para desenho vetorial"                                        ON  \
    GoogleChrome      "Navegador web Google Chrome"                                           ON  \
    Skype             "Cliente para rede Skype"                                               ON  \
    Zsh               "Shell + oh-my-zsh (framework para configurações úteis do zsh)"         ON  \
    SourceCodeProFont "Família de fontes Monospaced para código"                              ON  \
    Direnv            "Switcher de ambiente para shell"                                       ON  \
    Smartgit          "Interface gráfica para o git"                                          ON  \
    CinnamonApplets   "Applets para o Linux Mint com Cinnamon"                                ON  \
    Spotify           "App do Spotify"                                                        ON  \
    Awscli            "Interface linha de comando da AWS"                                     ON  \
    SublimeText       "Editor de texto"                                                       ON  )

#=============================== Processamento =================================

# Termina o programa se apertar cancelar
[ "$?" -eq 1 ] && exit 1

function instalar_desktop
{
    mv $HOME/Área\ de\ Trabalho $HOME/Desktop
    sed "s/"Área\ de\ Trabalho"/"Desktop"/g" $HOME/.config/user-dirs.dirs  > /tmp/user-dirs.dirs.modificado
    mv /tmp/user-dirs.dirs.modificado $HOME/.config/user-dirs.dirs
    xdg-user-dirs-gtk-update
    xdg-user-dirs-update
}

function instalar_terminator
{
    sudo apt-get install -y terminator
    FINAL_MSG="$FINAL_MSG\n\nInstalação do Terminator\n========================\n\nInstale esse plugin que é bem útil: https://github.com/mchelem/terminator-editor-plugin"
}

function instalar_zsh
{
    # dependências do zsh
    sudo apt-get install -y libc6-dev libncursesw5-dev
    wget -O /tmp/zsh-5.2.tar.gz http://ufpr.dl.sourceforge.net/project/zsh/zsh/5.2/zsh-5.2.tar.gz
    tar -zxvf /tmp/zsh-5.2.tar.gz -C /tmp
    cd /tmp/zsh-5.2/
    ./configure && make
    sudo make install
    # define o zsh como shell default do usuário atual
    sudo sh -c 'echo $(which zsh) >> /etc/shells'
    sudo usermod --shell $(which zsh) $USER
    cd -

    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
}

function instalar_dependencias_ruby
{
    sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev # libxml2-dev libxslt-dev libyaml-dev
}

function instalar_rbenv
{
    instalar_dependencias_ruby

    # Dependências para instalar o rbenv
    sudo apt-get install -y git-core

    # Instala o rbenv
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv

    # Isso é papel do dotfiles
    # Adiciona source no bash
    # echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    # echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    # source ~/.bashrc
    # adiciona source no zshell
    # echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
    # echo 'eval "$(rbenv init -)"' >> ~/.zshrc
    # source ~/.zshrc

    # Instala o ruby-build como plugin do rbenv
    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

    # intala o ruby 2 mais atual
    rbenv install `rbenv install -l | grep -P "^(\s)*2\.\d\.\d$" | tail -n 1`
}

function instalar_java
{
    sudo apt-get install -y openjdk-7-jdk
}

function instalar_inkscape
{
    sudo apt-get install -y inkscape
}

function instalar_skype
{
    wget -O /tmp/skype.deb https://get.skype.com/go/getskype-linux-beta-ubuntu-64
    sudo dpkg -i /tmp/skype.deb
}

function instalar_vim
{
    sudo apt-get install -y vim
    sudo cp $FOLDER/vimrc.local /etc/vim/
    vim=1
}

function instalar_googlechrome
{
    if [ "$arquitetura" = '32-bit' ]
    then
        wget -O /tmp/google-chrome-stable-i386.deb https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
        sudo dpkg -i /tmp/google-chrome-stable-i386.deb
    elif [ "$arquitetura" = '64-bit' ]
    then
        wget -O /tmp/google-chrome-stable-amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo dpkg -i /tmp/google-chrome-stable-amd64.deb
    fi
}

function instalar_git
{
    sudo apt-get install -y git-core
}

function instalar_mysql
{
    sudo apt-get install -y mysql-server libmysqlclient-dev
}

function instalar_postgresql
{
    local VERSION=$(tail -n 1 /etc/apt/sources.list.d/official-package-repositories.list | cut -d " " -f 3)

    sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ $VERSION-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install -y postgresql libpq-dev
    sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"
}

function instalar_nodejs
{
    # https://github.com/nodesource/distributions#installation-instructions
    curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

function instalar_sublimetext
{
    sudo add-apt-repository -y ppa:webupd8team/sublime-text-3 && sudo apt-get update
    sudo apt-get install -y sublime-text-installer
}

function instalar_source_code_pro_font
{
    git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git ~/.fonts/adobe-fonts/source-code-pro
    fc-cache -f -v ~/.fonts/adobe-fonts/source-code-pro
}

function instalar_direnv
{
    local tag=$(curl -s https://api.github.com/repos/direnv/direnv/releases/latest | python -c 'import json, sys; parsed = json.load(sys.stdin); print parsed["tag_name"]')
    sudo wget -O /usr/local/bin/direnv "https://github.com/direnv/direnv/releases/download/$tag/direnv.linux-amd64"
    sudo chmod +x /usr/local/bin/direnv
}

function instalar_smartgit
{
    wget -O /tmp/smartgit.deb http://www.syntevo.com/static/smart/download/smartgit/smartgit-8_0_3.deb
    sudo dpkg -i /tmp/smartgit.deb
}

function instalar_cinnamonapplets
{
    APPLETS_PATH=$HOME/.local/share/cinnamon/applets
    # Multi-Core System Monitor
    # https://cinnamon-spices.linuxmint.com/applets/view/79
    sudo apt-get install -y gir1.2-gtop-2.0 # dependencie
    git clone --depth 1 https://github.com/ccadeptic23/Multi-Core-System-Monitor.git $APPLETS_PATH/multicore-sys-monitor@ccadeptic23

    # CPU Temperature Indicator
    # https://cinnamon-spices.linuxmint.com/applets/view/106
    sudo apt-get install -y lm-sensors # dependencie
    git clone --depth 1 https://github.com/fevimu/cinnamon-applet-cpu-temperature.git $APPLETS_PATH/temperature@fevimu
}

function instalar_spotify
{
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update
    sudo apt-get install -y spotify-client
}

function instalar_awscli
{
    sudo apt-get install -y python-pip
    pip install --upgrade pip
    sudo pip install setuptools
    sudo pip install awscli
}

echo "$opcoes" |
while read opcao
do
    `echo instalar_$opcao | tr "[:upper:]" "[:lower:]"`
done

dialog --title 'Aviso' \
       --msgbox 'Instalação concluída!' \
0 0

echo -e "$FINAL_MSG"
