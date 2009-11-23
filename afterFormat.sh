#!/bin/bash
#
# instalar.sh - Instala todos os softwares selecionados. O PC deve estar
#               conectado à internet. O tempo de instalação dependerá da
#               velocidade de sua conexão.
#
# ------------------------------------------------------------------------------
#
# Histórico:
#
#   v1.0, 19-11-2009, Hugo Maia:
#       - Versão inicial.
#
# ------------------------------------------------------------------------------
#
# Autor     : Hugo Henriques Maia Vieira <hugouenf@gmail.com>
#
# Licença: GPL.
#
# TODO: Colocar o pacote de dicionarios no downloads do projeto e mudar o script
#       para baixar de lá se for necessário.

# ==========================    Variáveis    ===================================

# Mandinga para pegar o diretório onde o script foi executado
FOLDER=$(cd $(dirname $0); pwd -P)

#================================ Menu =========================================

# Instala o dialog
echo "Espere um momento..."
sudo apt-get install -y dialog > /dev/null

opcoes=$( dialog --stdout --separate-output                                         \
    --title "afterFormat - Pós Formatação para Ubuntu Karmic Koala"                                  \
    --checklist 'Selecione os softwares que deseja instalar:' 0 0 0                  \
    Desktop     "Muda \"Área de Trabalho\" para \"Desktop\" *(Apenas ptBR)"     ON  \
    RubyOnRails "Ruby, irb, rails e gems básicas para desenvolvimento"          ON  \
    MySql       "Banco de dados"                                                ON  \
    PostgreSQL  "Banco de dados"                                                OFF \
    Lingo       "Software para programação linear"                              ON  \
    Java        "Java Development Kit e Java Runtime Environment"               ON  \
    SVN         "Sistema de controle de versão"                                 ON  \
    Git         "Sistema de controle de versão"                                 ON  \
    Python      "IPython, setuptools, virtualenv"                               ON  \
    KDbg        "Interface gráfica para o gdb, o GNU debugger"                  ON  \
    VIM         "Editor de texto, com configurações básicas"                    ON  \
    Gedit       "Plugins oficiais, Gmate e configurações básicas"               ON  \
    EnvyNG      "Software para instalação de drivers Nvidia e ATI"              OFF \
    StarDict    "Dicionário multi-línguas"                                      ON  \
    Xournal     "Software para fazer anotações e marcar texto em pdf"           ON  \
    Media       "Codecs, flashplayer e compactadores"                           ON  \
    Inkscape    "Software para desenho vetorial"                                ON  \
    K3b         "Software para gravação de CD e DVD"                            ON  \
    Wireshark   "Analisador de tráfico de rede"                                 ON  \
    XChat       "Cliente IRC"                                                   ON  \
    Dia         "Editor de diagramas"                                           ON  \
    Opera       "Navegador web"                                                 ON  \
    Chromium    "Versão opensouce do navegador web Google Chrome"               ON  \
    Firefox     "Complementos para o firefox. FireBug, Web Developer e Adblock" ON  \
    Skype       "Skype"                                                         ON  \
    Pidgin      "Cliente de mensagens instantâneas"                             ON  )

#=============================== Processamento =================================

# Termina o programa se apertar cancelar
[ "$?" -eq 1 ] &&  exit 1

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

    if [ "$opcao" = 'RubyOnRails' ]
    then
        sudo apt-get install -y ruby1.8 rubygems rubygems1.8 ruby1.8-dev libpq-dev libopenssl-ruby1.8 libxml2 libxml2-dev libxslt1.1 libxslt1-dev libxml-ruby libxslt-ruby irb
        sudo gem install rake
        sudo gem install rails
        sudo gem install mongrel
        sudo gem install brazilian-rails
        sudo gem install cucumber
        sudo gem install webrat
        sudo gem install rspec
        sudo gem install rspec-rails
        sudo gem install nokogiri
        sudo gem install capistrano
        sudo gem install authlogic
        sudo gem install remarkable_rails
        cd /usr/bin
        sudo ln ruby1.8 ruby
        cd $FOLDER
        ruby_on_rails=1
        sudo ./variaveis_ambiente.sh "ruby_on_rails"
    fi

    if [ "$opcao" = 'MySql' ]
    then
        sudo apt-get install -y mysql-server-5.0
        sudo apt-get install libmysqlclient15-dev
        test $ruby_on_rails -eq 1 && sudo gem install mysql
    fi

    if [ "$opcao" = 'PostgreSQL' ]
    then
        sudo apt-get install -y postgresql
        test $ruby_on_rails -eq 1 && gem install ruby-pg
    fi

    if [ "$opcao" = 'Lingo' ]
    then
        DIRETORIO_LINGO=$(dialog --stdout       \
        --title 'Escolha onde instalar o Lingo' \
        --fselect ~/ 0 0)

        # Termina a instalação do lingo se apertar cancelar
        if ! [ "$?" -eq 1 ]
        then
            wget -P $FOLDER http://www.lindo.com/downloads/LINGO-LINUX-IA32-11.0.tar.gz 2> /dev/null
            # Termina a instalação do lingo se não conseguir baixa-lo
            if ! [ "$?" -eq 1 ]
            then
                test ! -d $DIRETORIO_LINGO && mkdir -p $DIRETORIO_LINGO
                tar zxvf $FOLDER/LINGO-LINUX-IA32-11.0.tar.gz -C $DIRETORIO_LINGO
                chmod -R 755 $DIRETORIO_LINGO/lingo11/bin/*
                export LD_LIBRARY_PATH="$DIRETORIO_LINGO/lingo11/bin/linux32:$LD_LIBRARY_PATH"
                export LINGO_11_LICENSE_FILE="$DIRETORIO_LINGO/lingo11/license/lndlng11.lic"
                cd $DIRETORIO_LINGO/lingo11/license
                source create_demo_license.sh
                cd /usr/bin/
                sudo ln $DIRETORIO_LINGO/lingo11/bin/linux32/lingo11 lingo
                cd $FOLDER
                sudo ./variaveis_ambiente.sh "lingo"
            else
                dialog --title 'Aviso' \
                --msgbox 'O lingo não pôde ser instalado, pois o link para download está quebrado.\n\nPor favor, informe este erro pelo e-mail: hugouenf@gmail.com' \
                0 0
            fi
        fi
    fi

    if [ "$opcao" = 'VIM' ]
    then
        sudo apt-get install -y vim
        sudo cp $FOLDER/vimrc /etc/vim/
    fi

    if [ "$opcao" = 'Gedit' ]
    then
        sudo ./repositorios.sh "gmate"
        sudo apt-get install -y gedit-plugins
        sudo apt-get install -y gedit-gmate
        # Preferências do gedit
        `gconftool-2 --set /apps/gedit-2/plugins/active-plugins -t list --list-type=str [docinfo,rails_extract_partial,rubyonrailsloader,spell,smart_indent,terminal,rails_hotkeys,indent,filebrowser,snippets,time,modelines,completion,trailsave,sort,align,colorpicker,smartspaces,sessionsaver,bracketcompletion,changecase,rails_hotcommands,codecomment]`
        `gconftool-2 --set /apps/gedit-2/preferences/editor/auto_indent/auto_indent -t bool true`
        `gconftool-2 --set /apps/gedit-2/preferences/editor/bracket_matching/bracket_matching -t bool true`
        `gconftool-2 --set /apps/gedit-2/preferences/editor/colors/scheme -t str textmate`
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
    fi

    if [ "$opcao" = 'Media' ]
    then
        sudo ./repositorios.sh "media"
        sudo apt-get install -y flashplugin-installer
        sudo apt-get install -y ubuntu-restricted-extras non-free-codecs libdvdcss2 default-jre w32codecs
        sudo apt-get install -y arj lha rar unace-nonfree unrar p7zip p7zip-full p7zip-rar
    fi

    if [ "$opcao" = 'Chromium' ]
    then
        sudo ./repositorios.sh "chromium"
        sudo apt-get install -y chromium-browser
    fi

    if [ "$opcao" = 'StarDict' ]
    then
        sudo apt-get install -y stardict
        sudo tar zxvf $FOLDER/Dicionarios_StarDict.tar.gz -C /usr/share/stardict/dic
    fi

    if [ "$opcao" = 'Firefox' ]
    then
        wget -O /tmp/firebug.xpi https://addons.mozilla.org/pt-BR/firefox/downloads/latest/1843/addon-1843-latest.xpi?src=addondetail
        firefox -install-global-extension /tmp/firebug.xpi
        wget -O /tmp/webDeveloper.xpi https://addons.mozilla.org/pt-BR/firefox/downloads/latest/60/addon-60-latest.xpi?src=addondetail
        firefox -install-global-extension /tmp/webDeveloper.xpi
        wget -O /tmp/adblock.xpi https://addons.mozilla.org/pt-BR/firefox/downloads/latest/1865/addon-1865-latest.xpi?src=addondetail
        firefox -install-global-extension /tmp/adblock.xpi
    fi


    if [ "$opcao" = 'Opera' ]
    then
    echo "Fazendo download do opera ..."
    wget -O /tmp/opera.deb http://opera.fahrtenbuch.de/linux/1001/final/en/i386/opera_10.01.4682.gcc4.qt3_i386.deb 2> /dev/null
        if ! [ "$?" -eq 1 ]
        then
            sudo dpkg -i /tmp/opera.deb
        else
            dialog --title 'Aviso' \
            --msgbox 'O opera não pôde ser instalado, pois o link para download está quebrado.\n\nPor favor, informe este erro pelo e-mail: hugouenf@gmail.com' \
            0 0
        fi
    fi

    [ "$opcao" = 'Java' ]       && sudo apt-get install -y sun-java6-jdk sun-java6-jre
    [ "$opcao" = 'Git' ]        && sudo apt-get install -y git-core
    [ "$opcao" = 'SVN' ]        && sudo apt-get install -y subversion
    [ "$opcao" = 'Python' ]     && sudo apt-get install -y ipython python-setuptools python-virtualenv
    [ "$opcao" = 'EnvyNG' ]     && sudo apt-get install -y envyng-core envyng-gtk envyng-qt
    [ "$opcao" = 'Xournal' ]    && sudo apt-get install -y xournal
    [ "$opcao" = 'Inkscape' ]   && sudo apt-get install -y inkscape
    [ "$opcao" = 'K3b' ]        && sudo apt-get install -y k3b
    [ "$opcao" = 'KDbg' ]       && sudo apt-get install -y kdbg
    [ "$opcao" = 'Wireshark' ]  && sudo apt-get install -y wireshark
    [ "$opcao" = 'XChat' ]      && sudo apt-get install -y xchat
    [ "$opcao" = 'Dia' ]        && sudo apt-get install -y dia
    [ "$opcao" = 'Skype' ]      && sudo apt-get install -y skype
    [ "$opcao" = 'Pidgin' ]     && sudo apt-get install -y pidgin
done

