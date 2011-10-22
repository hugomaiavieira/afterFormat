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
#
# ------------------------------------------------------------------------------
#
# The MIT License
#
# Copyright (c) 2010 Hugo Henriques Maia Vieira
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
FOLDER=$(cd $(dirname $0); pwd -P)

# Pegando arquitetura do sistema. Valores de retorno: '32-bit' ou '64-bit'
arquitetura=`file /bin/bash | cut -d' ' -f3`

vim=0

#================================ Menu =========================================

# Instala o dialog
sudo apt-get install -y dialog > /dev/null

opcoes=$( dialog --stdout --separate-output                                                                 \
    --title "afterFormat - Pós Formatação para as versão 11.04 do Ubuntu"                                   \
    --checklist 'Selecione os softwares que deseja instalar:' 0 0 0                                         \
    Desktop         "Muda \"Área de Trabalho\" para \"Desktop\" *(Apenas ptBR)"                         ON  \
    UnityTray       "Habilita ícones de aplicações no tray (como nas versões anteriores) "              ON  \
    PS1             "\$PS1 no formato: usuário ~/diretório/atual (BranchGit)"                           ON  \
    Monaco          "Adiciona fonte Monaco (padrão do TextMate) e seleciona para o Gedit e o Terminal"  ON  \
    SSH             "SSH server e client"                                                               ON  \
    MySql           "Banco de dados"                                                                    ON  \
    PostgreSQL      "Banco de dados"                                                                    ON  \
    Sqlite3         "Banco de dados"                                                                    ON  \
    Ruby1.9.2       "rvm com Ruby1.9.2"                                                                 ON  \
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

function instalar_monaco
{
    sudo mkdir /usr/share/fonts/macfonts
    sudo wget -O /usr/share/fonts/macfonts/Monaco_Linux.ttf http://github.com/downloads/hugomaiavieira/afterFormat/Monaco_Linux.ttf --no-check-certificate
    sudo fc-cache -f -v
    # Configura para o terminal
    `gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font -t bool false`
    `gconftool-2 --set /apps/gnome-terminal/profiles/Default/font -t str Monaco\ 10`
    # Configura para o Gedit
    `gconftool-2 --set /apps/gedit-2/preferences/editor/font/use_default_font -t bool false`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/font/editor_font -t str Monaco\ 10`
}

function instalar_ruby1.9.2
{
    sudo apt-get install -y libssl-dev libreadline5-dev libxml2-dev libxslt-dev

    # Dependências do rvm
    sudo apt-get install -y curl git-core
    # Instala o rvm
    bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
    echo "[ -s \$HOME/.rvm/scripts/rvm ] && source \$HOME/.rvm/scripts/rvm" >> $HOME/.bashrc
    [ -s $HOME/.rvm/scripts/rvm ] && source $HOME/.rvm/scripts/rvm

    # intala o ruby 1.9.2 no rvm
    rvm install ruby-1.9.2
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
	sudo add-apt-repository ppa:ubuntu-on-rails/ppa && sudo apt-get update
    sudo apt-get install -y gedit-plugins
    sudo apt-get install --force-yes -y gedit-gmate
    # Preferências do gedit
    `gconftool-2 --set /apps/gedit-2/plugins/active-plugins -t list --list-type=str [changecase,time,rubyonrailsloader,terminal,docinfo,filebrowser,smart_indent,rails_hotkeys,snippets,trailsave,smartspaces,rails_extract_partial,pastie,sort,text_tools,align,codecomment,colorpicker,sessionsaver,wordcompletion,gemini,rails_hotcommands,spell]`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/auto_indent/auto_indent -t bool true`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/bracket_matching/bracket_matching -t bool true`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/colors/scheme -t str ryanlight`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/current_line/highlight_current_line -t bool true`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/cursor_position/restore_cursor_position -t bool true`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/line_numbers/display_line_numbers -t bool true`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/right_margin/display_right_margin -t bool true`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/right_margin/right_margin_position -t int 80`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/save/create_backup_copy -t bool false`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/tabs/insert_spaces -t bool true`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/tabs/tabs_size -t int 4`
    `gconftool-2 --set /apps/gedit-2/preferences/editor/wrap_mode/wrap_mode -t str GTK_WRAP_NONE`
    `gconftool-2 --set /apps/gedit-2/preferences/ui/bottom_panel/bottom_panel_visible -t bool true`
    `gconftool-2 --set /apps/gedit-2/preferences/ui/side_pane/side_pane_visible -t bool true`
    wget -O /tmp/batraquio.tar.gz http://github.com/hugomaiavieira/batraquio/tarball/master --no-check-certificate
    tar zxvf /tmp/batraquio.tar.gz -C /tmp
    /tmp/hugomaiavieira-batraquio*/install.sh --yes
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
    sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list &&
        sudo apt-get update &&
        sudo apt-get -y --allow-unauthenticated install medibuntu-keyring &&
        sudo apt-get update

    # Pacotes de compactadores de ficheiros, OpenJDK, flash e codecs de áudio e vídeo
    sudo apt-get install faac faad ffmpeg ffmpeg2theora flac icedax id3v2 lame \
        libflac++6 libjpeg-progs libmpeg3-1 mencoder mjpegtools mp3gain \
        mpeg2dec mpeg3-utils mpegdemux mpg123 mpg321 regionset sox uudeview \
        vorbis-tools x264 arj lha p7zip p7zip-full p7zip-rar rar unace-nonfree
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
    sudo apt-get install -y mysql-server-5.1 libmysqlclient16-dev
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

function instalar_xournal
{
    sudo apt-get install -y xournal
}

function instalar_inkspace
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

