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

vim=0

# ====================    Pegando arquitetura do sistema    ====================

if [ `uname -m` = 'i686' ]; then    # Ubuntu 32 bits
    arquitetura='x86'
else                                # Ubuntu 64 bits
    arquitetura='x86_64'
fi

#================================ Menu =========================================

# Instala o dialog
sudo apt-get install -y dialog > /dev/null

opcoes=$( dialog --stdout --separate-output                                                                 \
    --title "afterFormat - Pós Formatação para as versões 10.x do Ubuntu"                                   \
    --checklist 'Selecione os softwares que deseja instalar:' 0 0 0                                         \
    Desktop         "Muda \"Área de Trabalho\" para \"Desktop\" *(Apenas ptBR)"                         ON  \
    Botões          "Muda os botões minimizar, maximizar e fechar para a direita"                       ON  \
    PS1             "\$PS1 no formato: usuário ~/diretório/atual (BranchGit)"                           ON  \
    Monaco          "Adiciona fonte Monaco (padrão do TextMate) e seleciona para o Gedit e o Terminal " ON  \
    SSH             "SSH server e client"                                                               ON  \
    MySql           "Banco de dados"                                                                    ON  \
    PostgreSQL      "Banco de dados"                                                                    ON  \
    Ruby1.9.2       "rvm com Ruby1.9.2"                                                                 ON  \
    Python          "Ferramentas para desenvolvimento python"                                           ON  \
    Java            "Java Development Kit e Java Runtime Environment"                                   ON  \
    VIM             "Editor de texto + configurações úteis"                                             ON  \
    Gedit           "Plugins oficiais, Gmate + configurações úteis"                                     ON  \
    Refactoring     "Conjunto de scripts para refatoração de código"                                    ON  \
    SVN             "Sistema de controle de versão"                                                     ON  \
    Git             "Sistema de controle de versão + configurações úteis"                               ON  \
    GitMeldDiff     "Torna o Meld o software para visualização do diff do git"                          ON  \
    StarDict        "Dicionário multi-línguas (inclui dicionário PTbr-En/En-PTbr)"                      ON  \
    Xournal         "Software para fazer anotações e marcar texto em pdf"                               ON  \
    Media           "Codecs, flashplayer (32/64 bits, nativo) e compactadores de arquivos"              ON  \
    Gimp            "Software para manipulação de imagens"                                              ON  \
    Inkscape        "Software para desenho vetorial"                                                    ON  \
    RecordMyDesktop "Ferramenta para gravação do video e áudio do computador"                           ON  \
    XChat           "Cliente IRC"                                                                       ON  \
    Dia             "Editor de diagramas"                                                               ON  \
    GoogleChrome    "Navegador web Google Chrome"                                                       ON  \
    Skype           "Cliente para rede Skype"                                                           ON  \
    VirtualBox      "Sistema de virtualização da Oracle (não Open Source)"                              ON  \
    Pidgin          "Cliente de mensagens instantâneas"                                                 ON  )

#=============================== Processamento =================================

# Termina o programa se apertar cancelar
[ "$?" -eq 1 ] && exit 1

echo "$opcoes" |
while read opcao
do
    if [ "$opcao" = 'Desktop' ]
    then
        mv $HOME/Área\ de\ Trabalho $HOME/Desktop
        sed "s/"Área\ de\ Trabalho"/"Desktop"/g" $HOME/.config/user-dirs.dirs  > /tmp/user-dirs.dirs.modificado
        mv /tmp/user-dirs.dirs.modificado $HOME/.config/user-dirs.dirs
        xdg-user-dirs-gtk-update
        xdg-user-dirs-update
    fi

    [ "$opcao" = 'Botões' ] && gconftool-2 --set "/apps/metacity/general/button_layout" --type string ":minimize,maximize,close"

    [ "$opcao" = 'PS1' ] && cat $FOLDER/PS1 >> $HOME/.bashrc

    [ "$opcao" = 'SSH' ] && sudo apt-get install -y openssh-server openssh-client

    if [ "$opcao" = 'Monaco' ]
    then
        sudo mkdir /usr/share/fonts/macfonts
        sudo wget -O /usr/share/fonts/macfonts/Monaco_Linux.ttf http://github.com/downloads/hugomaiavieira/afterFormat/Monaco_Linux.ttf --no-check-certificate
        sudo fc-cache -f -v
        # Configura para o terminal
        `gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font -t bool false`
        `gconftool-2 --set /apps/gnome-terminal/profiles/Default/font -t str Monaco\ 10`
        # Configura para o Gedit
        `gconftool-2 --set /apps/gedit-2/preferences/editor/font/use_default_font -t bool false`
        `gconftool-2 --set /apps/gedit-2/preferences/editor/font/editor_font -t str Monaco\ 10`
    fi

    if [ "$opcao" = 'Ruby1.9.2' ]
    then
        sudo apt-get install -y libssl-dev libreadline5-dev

        # instala o rvm
        sudo apt-get install -y curl
        bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-latest )
        echo "[ -s \$HOME/.rvm/scripts/rvm ] && source \$HOME/.rvm/scripts/rvm" >> $HOME/.bashrc
        [ -s $HOME/.rvm/scripts/rvm ] && source $HOME/.rvm/scripts/rvm

        # intala o ruby 1.9.2 no rvm
        rvm install ruby-1.9.2
    fi

    if [ "$opcao" = 'Python' ]
    then
        sudo apt-get install -y ipython python-dev

        wget -O /tmp/distribute_setup.py http://python-distribute.org/distribute_setup.py
        sudo python /tmp/distribute_setup.py

        sudo easy_install pip
        sudo pip install virtualenv

        sudo pip install virtualenvwrapper
        mkdir -p $HOME/.virtualenvs
        echo "export WORKON_HOME=\$HOME/.virtualenvs" >> $HOME/.bashrc
        echo "source /usr/local/bin/virtualenvwrapper.sh"  >> $HOME/.bashrc
    fi

    if [ "$opcao" = 'VIM' ]
    then
        sudo apt-get install -y vim
        sudo cp $FOLDER/vimrc.local /etc/vim/
        vim=1
    fi

    if [ "$opcao" = 'Gedit' ]
    then
        sudo ./repositorios.sh "gmate"
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
    fi

    if [ "$opcao" = 'Refactoring' ]
    then
        wget -O /tmp/refactoring-scripts.tar.gz http://github.com/hugomaiavieira/refactoring-scripts/tarball/master --no-check-certificate
        tar zxvf /tmp/refactoring-scripts.tar.gz -C /tmp
        /tmp/hugomaiavieira-refactoring-scripts*/install.sh
    fi

    if [ "$opcao" = 'Media' ]
    then
        sudo ./repositorios.sh "media"
        sudo apt-get install --force-yes -y ubuntu-restricted-extras non-free-codecs libdvdcss2
        sudo apt-get install --force-yes -y arj lha rar unace-nonfree unrar p7zip p7zip-full p7zip-rar

        if [ "$arquitetura" = "x86" ]
        then
            sudo apt-get install --force-yes -y w32codecs
        elif [ "$arquitetura" = "x86_64" ]
        then
            sudo apt-get install --force-yes -y w64codecs
            # Removendo qualquer versão do Flashplayer 32 bits para que não haja conflitos
            sudo apt-get purge -y flashplugin-nonfree gnash gnash-common mozilla-plugin-gnash swfdec-mozilla
            # Instalando o Flashplayer 64 bits
            sudo apt-get install -y flashplugin64-nonfree
        fi
    fi

    if [ "$opcao" = 'GoogleChrome' ]
    then

        if [ "$arquitetura" = 'x86' ]
        then
            wget -O /tmp/google-chrome-stable-i386.deb http://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
            sudo dpkg -i /tmp/google-chrome-stable-i386.deb
        elif [ "$arquitetura" = 'x86_64' ]
        then
            wget -O /tmp/google-chrome-stable-amd64.deb http://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            sudo dpkg -i /tmp/google-chrome-stable-amd64.deb
        fi

    fi

    if [ "$opcao" = 'Skype' ]
    then

        # Baixando dependências
        sudo apt-get install -y libqtgui4 libqt4-dbus libqt4-network libqt4-xml libasound2

        if [ "$arquitetura" = 'x86' ]
        then
            wget -O /tmp/skype-i386.deb http://www.skype.com/go/getskype-linux-beta-ubuntu-32
            sudo dpkg -i /tmp/skype-i386.deb
        elif [ "$arquitetura" = 'x86_64' ]
        then
            wget -O /tmp/skype-amd64.deb http://www.skype.com/go/getskype-linux-beta-ubuntu-64
            sudo dpkg -i /tmp/skype-amd64.deb
        fi

        # Já que algumas dependências não instalam por bem, instalarão a força
        sudo apt-get -f install

    fi

    if [ "$opcao" = 'VirtualBox' ]
    then

        sudo ./repositorios.sh "virtualbox"
        sudo apt-get install -y virtualbox-3.2

    fi

    if [ "$opcao" = 'StarDict' ]
    then
        sudo apt-get install -y stardict
        wget -O /tmp/Dicionarios_StarDict.tar.gz http://github.com/downloads/hugomaiavieira/afterFormat/Dicionarios_StarDict.tar.gz --no-check-certificate
        sudo tar zxvf /tmp/Dicionarios_StarDict.tar.gz -C /usr/share/stardict/dic
    fi

    if [ "$opcao" = 'GitMeldDiff' ]
    then
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
    fi

    if [ "$opcao" = 'Git' ]
    then
        sudo apt-get install -y git-core
        # Cores
        git config --global color.ui auto
        # Alias
        git config --global alias.br branch
        git config --global alias.ci commit
        git config --global alias.co checkout
        git config --global alias.st status
        # Editor
        [ "$vim" -eq 1 ] && git config --global core.editor vim
    fi

    [ "$opcao" = 'MySql' ]              && sudo apt-get install -y mysql-server-5.1 libmysqlclient16-dev
    [ "$opcao" = 'PostgreSQL' ]         && sudo apt-get install -y postgresql
    [ "$opcao" = 'Java' ]               && sudo apt-get install -y openjdk-6-jdk openjdk-6-jre
    [ "$opcao" = 'SVN' ]                && sudo apt-get install -y subversion
    [ "$opcao" = 'Gimp' ]               && sudo apt-get install -y gimp
    [ "$opcao" = 'Xournal' ]            && sudo apt-get install -y xournal
    [ "$opcao" = 'Inkscape' ]           && sudo apt-get install -y inkscape
    [ "$opcao" = 'XChat' ]              && sudo apt-get install -y xchat
    [ "$opcao" = 'Dia' ]                && sudo apt-get install -y dia
    [ "$opcao" = 'Pidgin' ]             && sudo apt-get install -y pidgin

done

dialog --title 'Aviso' \
        --msgbox 'Instalação concluída!' \
0 0
