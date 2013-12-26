#!/bin/bash
#
# afterFormat.sh - Instala todos os softwares selecionados. O PC deve estar
#                  conectado à internet. O tempo de instalação dependerá da
#                  velocidade de sua conexão.
#
# ------------------------------------------------------------------------------
#
# Histórico:
#
#   v1.0, 19-11-2009, Hugo Maia:
#       - Versão inicial.
#   v1.1, 08-05-2010, Hugo Maia Vieira:
#       - Retirados e adicionados itens, ajustando para o ubuntu 10.04
#   v1.2, 08-05-2010, Hugo Maia Vieira:
#       - Colocado o pacote de dicionários no downloads do projeto e mudado o
#       script para baixar de lá se for necessário.
#   v1.3, 19-05-2010, Hugo Maia Vieira:
#       - Fechada release depois de serem feitos vários testes e ajustes.
#   v2.0, 12-10-2010, Hugo Maia Vieira:
#       - Release para versões 10.x do Ubuntu.
#   v2.1, 26-04-2012, Hugo Maia Vieira:
#       - Release para versão 12.04 do Ubuntu.
#   v3.0, 21-07-2013, Hugo Maia Vieira:
#       - Release para versão 13.04 do Ubuntu e 15 do Linux Mint. Removidos
#         alguns itens. Adicionado o rbenv, nodejs e terminator.
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

# Pegando arquitetura do sistema. Valores de retorno: '32-bit' ou '64-bit'
arquitetura=`file /bin/bash | cut -d' ' -f3`

vim=0

#================================ Menu =========================================

# Instala o dialog
sudo apt-get install -y dialog > /dev/null

opcoes=$( dialog --stdout --separate-output                                                     \
    --title "afterFormat - Pós Formatação para a versão 13.04 do Ubuntu e 15 do Linux Mint"     \
    --checklist 'Selecione os softwares que deseja instalar:' 0 0 0                             \
    Desktop         "Muda \"Área de Trabalho\" para \"Desktop\" *(Apenas ptBR)"             ON  \
    PS1             "\$PS1 no formato: usuário ~/diretório/atual (BranchGit)"               ON  \
    SSH             "SSH server e client"                                                   ON  \
    Terminator      "Terminal mais podereso"                                                ON  \
    MySql           "Banco de dados"                                                        ON  \
    PostgreSQL      "Banco de dados"                                                        ON  \
    Sqlite3         "Banco de dados"                                                        ON  \
    Nodejs          "Nodejs e npm (node packaged modules)"                                  ON  \
    Rbenv           "rbenv + Ruby (atual)"                                                  ON  \
    Rvm             "rvm + Ruby e Rails (atuais)"                                           OFF \
    Python          "Ambiente para desenvolvimento com python"                              OFF \
    VIM             "Editor de texto + configurações úteis"                                 OFF \
    Refactoring     "Conjunto de scripts para refatoração de código"                        ON  \
    Git             "Sistema de controle de versão + configurações úteis"                   ON  \
    GitMeldDiff     "Torna o Meld o software para visualização do diff do git"              ON  \
    Gimp            "Software para manipulação de imagens"                                  ON  \
    Inkscape        "Software para desenho vetorial"                                        ON  \
    GoogleChrome    "Navegador web Google Chrome"                                           ON  \
    Skype           "Cliente para rede Skype"                                               ON  \
    Zsh             "Shell + oh-my-zsh (framework para configurações úteis do zsh)"         OFF \
    SublimeText     "Editor texto"                                                          ON  )

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
}

function instalar_ps1
{
    # Instala o git, que é dependência para a personalização
    instalar_git
    cat $FOLDER/PS1 >> $HOME/.bashrc
}

function instalar_zsh
{
    sudo apt-get install zsh
    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    sudo usermod -s /bin/zsh $USER
}

function instalar_ssh
{
    sudo apt-get install -y openssh-server openssh-client
}

function instalar_dependencias_ruby
{
    sudo apt-get install -y libssl-dev libreadline-dev libxml2-dev libxslt-dev libyaml-dev
}

function instalar_rbenv
{
    instalar_dependencias_ruby

    # Dependências para instalar o rbenv
    sudo apt-get install -y git-core

    # Instala o rbenv
    git clone git://github.com/sstephenson/rbenv.git ~/.rbenv

    # Adiciona source no bash
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    source ~/.bashrc

    # adiciona source no zshell
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(rbenv init -)"' >> ~/.zshrc
    source ~/.zshrc

    # Instala o ruby-build como plugin do rbenv
    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

    # intala o ruby 2 mais atual
    rbenv install `rbenv install -l | grep -P "2.0.0-p\d+" | tail -n 1`
}

function instalar_rvm
{
    instalar_dependencias_ruby

    # Dependências do rvm
    sudo apt-get install -y curl git-core

    # adiciona source no bash
    echo "source $HOME/.rvm/scripts/rvm" >> $HOME/.bashrc
    # adiciona source no zsh
    echo "source $HOME/.rvm/scripts/rvm" >> $HOME/.zshrc

    # instala o rvm, ruby e rails atuais e estaveis
    curl -L https://get.rvm.io | bash -s stable --autolibs=3 --rails
}

function instalar_python
{
    sudo apt-get install -y ipython python-dev

    wget -O /tmp/distribute_setup.py http://python-distribute.org/distribute_setup.py
    sudo python /tmp/distribute_setup.py

    sudo easy_install pip
    sudo pip install virtualenv

    sudo pip install virtualenvwrapper
    mkdir -p $HOME/.virtualenvs
    echo "export WORKON_HOME=\$HOME/.virtualenvs" >> $HOME/.bashrc
    echo "source /usr/local/bin/virtualenvwrapper.sh"  >> $HOME/.bashrc
}

function instalar_vim
{
    sudo apt-get install -y vim
    sudo cp $FOLDER/vimrc.local /etc/vim/
    vim=1
}

function instalar_refactoring
{
    wget -O /tmp/refactoring-scripts.tar.gz http://github.com/hugomaiavieira/refactoring-scripts/tarball/master --no-check-certificate
    tar zxvf /tmp/refactoring-scripts.tar.gz -C /tmp
    /tmp/hugomaiavieira-refactoring-scripts*/install.sh
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

function instalar_skype
{
    # Baixando dependências
    sudo apt-get install -y libqtgui4 libqt4-dbus libqt4-network libqt4-xml libasound2

    if [ "$arquitetura" = '32-bit' ]
    then
        wget -O /tmp/skype-i386.deb http://www.skype.com/go/getskype-linux-beta-ubuntu-32
        sudo dpkg -i /tmp/skype-i386.deb
    elif [ "$arquitetura" = '64-bit' ]
    then
        wget -O /tmp/skype-amd64.deb http://www.skype.com/go/getskype-linux-beta-ubuntu-64
        sudo dpkg -i /tmp/skype-amd64.deb
    fi

    # Já que algumas dependências não instalam por bem, instalarão a força
    sudo apt-get --force-yes -y -f install
}

function instalar_git
{
    sudo apt-get install -y git-core
    # Cores
    git config --global color.ui auto
    # Alias
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.co checkout
    git config --global alias.st status
    git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
    # Editor
    [ "$vim" -eq 1 ] && git config --global core.editor vim
}

function instalar_gitmelddiff
{
    git --version 2> /dev/null
    if ! [ "$?" -eq 127 ]
    then
        sudo apt-get install -y meld
        touch $HOME/.config/git_meld_diff.py
        echo "#!/bin/bash" >> $HOME/.config/git_meld_diff.py
        echo "meld \"\$5\" \"\$2\"" >> $HOME/.config/git_meld_diff.py
        chmod +x $HOME/.config/git_meld_diff.py
        git config --global diff.external $HOME/.config/git_meld_diff.py
    else
        dialog --title 'Aviso' \
        --msgbox 'Para tornar o Meld o software para visualização do diff do git, o git deve estar instalado. Para isto, rode novamente o script marcando as opções Git e GitMeldDiff.' \
        0 0
    fi
}

function instalar_mysql
{
    sudo apt-get install -y mysql-server libmysqlclient-dev
}

function instalar_postgresql
{
    sudo apt-get install -y postgresql libpq-dev
}

function instalar_sqlite3
{
    sudo apt-get install -y sqlite3 libsqlite3-dev
}

function instalar_nodejs
{
    sudo add-apt-repository ppa:chris-lea/node.js && sudo apt-get update
    sudo apt-get install -y nodejs
}

function instalar_gimp
{
    sudo apt-get install -y gimp
}

function instalar_inkscape
{
    sudo apt-get install -y inkscape
}

function instalar_sublimetext
{
    sudo add-apt-repository ppa:webupd8team/sublime-text-2 && sudo apt-get update
    sudo apt-get install -y sublime-text
    # seta o sublime como editor padrão
    cat /etc/gnome/defaults.list | grep gedit >> ~/.local/share/applications/mimeapps.list
    sed -i s,gedit,sublime-text, ~/.local/share/applications/mimeapps.list
}

echo "$opcoes" |
while read opcao
do
    `echo instalar_$opcao | tr "[:upper:]" "[:lower:]"`
done

dialog --title 'Aviso' \
       --msgbox 'Instalação concluída!' \
0 0
