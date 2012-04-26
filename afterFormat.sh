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
#   v2.0, 26-04-2012, Hugo Maia Vieira:
#       - Release para versão 12.07 do Ubuntu.
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

opcoes=$( dialog --stdout --separate-output                                                                 \
    --title "afterFormat - Pós Formatação para as versão 12.04 do Ubuntu"                                   \
    --checklist 'Selecione os softwares que deseja instalar:' 0 0 0                                         \
    Desktop         "Muda \"Área de Trabalho\" para \"Desktop\" *(Apenas ptBR)"                         ON  \
    UnityTray       "Habilita ícones de aplicações no tray (como nas versões anteriores) "              ON  \
    PS1             "\$PS1 no formato: usuário ~/diretório/atual (BranchGit)"                           ON  \
    SSH             "SSH server e client"                                                               ON  \
    MySql           "Banco de dados"                                                                    ON  \
    PostgreSQL      "Banco de dados"                                                                    ON  \
    Sqlite3         "Banco de dados"                                                                    ON  \
    Ruby            "rvm + Ruby 1.9.3"                                                                  ON  \
    Python          "Ambiente para desenvolvimento com python"                                          ON  \
    VIM             "Editor de texto + configurações úteis"                                             ON  \
    Gedit           "Plugins oficiais, Gmate + configurações úteis"                                     ON  \
    Refactoring     "Conjunto de scripts para refatoração de código"                                    ON  \
    Git             "Sistema de controle de versão + configurações úteis"                               ON  \
    GitMeldDiff     "Torna o Meld o software para visualização do diff do git"                          ON  \
    StarDict        "Dicionário multi-línguas (inclui dicionário PTbr-En/En-PTbr)"                      ON  \
    Media           "Codecs, flashplayer (32 ou 64 bits), JRE e compactadores de arquivos"              ON  \
    Gimp            "Software para manipulação de imagens"                                              ON  \
    Inkscape        "Software para desenho vetorial"                                                    ON  \
    XChat           "Cliente IRC"                                                                       ON  \
    GoogleChrome    "Navegador web Google Chrome"                                                       ON  \
    Skype           "Cliente para rede Skype"                                                           ON  )

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

function instalar_ps1
{
    # Instala o git, que é dependência para a personalização
    instalar_git
    cat $FOLDER/PS1 >> $HOME/.bashrc
}

function instalar_ssh
{
    sudo apt-get install -y openssh-server openssh-client
}

function instalar_ruby
{
    sudo apt-get install -y libssl-dev libreadline-dev libxml2-dev libxslt-dev

    # Dependências do rvm
    sudo apt-get install -y curl git-core
    # Instala o rvm
    curl -L get.rvm.io | bash -s stable
    source ~/.rvm/scripts/'rvm'
    rvm requirements

    # intala o ruby 1.9.3 no rvm
    rvm install ruby-1.9.3
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

function instalar_gedit
{
	sudo apt-add-repository -y ppa:ubuntu-on-rails/ppa && sudo apt-get update
    sudo apt-get install -y gedit-plugins
    sudo apt-get install --force-yes -y gedit-gmate
}

function instalar_refactoring
{
    wget -O /tmp/refactoring-scripts.tar.gz http://github.com/hugomaiavieira/refactoring-scripts/tarball/master --no-check-certificate
    tar zxvf /tmp/refactoring-scripts.tar.gz -C /tmp
    /tmp/hugomaiavieira-refactoring-scripts*/install.sh
}

function instalar_media
{
    # A referência para a instalação desses pacotes foi o http://ubuntued.info/

    # Adiciona o repositório Medibuntu
    sudo -E wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list && \
    sudo apt-get --quiet update && \
    sudo apt-get -y --quiet --allow-unauthenticated install medibuntu-keyring && \
    sudo apt-get --quiet update

    # Pacotes de codecs de áudio e vídeo
    sudo apt-get install non-free-codecs libdvdcss2 faac faad ffmpeg \
    ffmpeg2theora flac icedax id3v2 lame libflac++6 libjpeg-progs libmpeg3-1 \
    mencoder mjpegtools mp3gain mpeg2dec mpeg3-utils mpegdemux mpg123 mpg321 \
    regionset sox uudeview vorbis-tools x264

    # Pacotes de compactadores de arquivos
    sudo apt-get install arj lha p7zip p7zip-full p7zip-rar rar unrar unace-nonfree

    # Oracle Java JDK e java plugin para navegador
    sudo add-apt-repository ppa:webupd8team/java && sudo apt-get update
    sudo apt-get install oracle-jdk7-installer
}

function instalar_googlechrome
{
    if [ "$arquitetura" = '32-bit' ]
    then
        wget -O /tmp/google-chrome-stable-i386.deb http://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
        sudo dpkg -i /tmp/google-chrome-stable-i386.deb
    elif [ "$arquitetura" = '64-bit' ]
    then
        wget -O /tmp/google-chrome-stable-amd64.deb http://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
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
    sudo apt-get -f install
}

function instalar_stardict
{
    sudo apt-get install -y stardict
    wget -O /tmp/Dicionarios_StarDict.tar.gz http://github.com/downloads/hugomaiavieira/afterFormat/Dicionarios_StarDict.tar.gz --no-check-certificate
    sudo tar zxvf /tmp/Dicionarios_StarDict.tar.gz -C /usr/share/stardict/dic
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
    sudo apt-get install -y mysql-server
}

function instalar_postgresql
{
    sudo apt-get install -y postgresql
}

function instalar_sqlite3
{
    sudo apt-get install -y sqlite3 libsqlite3-dev
}

function instalar_gimp
{
    sudo apt-get install -y gimp
}

function instalar_inkscape
{
    sudo apt-get install -y inkscape
}

function instalar_xchat
{
    sudo apt-get install -y xchat
}

function instalar_unitytray
{
    gsettings set com.canonical.Unity.Panel systray-whitelist "['all']"
}

echo "$opcoes" |
while read opcao
do
    `echo instalar_$opcao | tr "[:upper:]" "[:lower:]"`
done

dialog --title 'Aviso' \
       --msgbox 'Instalação concluída!' \
0 0

