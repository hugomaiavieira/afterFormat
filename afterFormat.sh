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
#   v1.1, 08-05-2010, Hugo Maia Vieira:
#       - Retirados e adicionados itens, ajustando para o ubuntu 10.04
#   v1.2, 08-05-2010, Hugo Maia Vieira:
#       - Colocado o pacote de dicionários no downloads do projeto e mudado o
#       script para baixar de lá se for necessário.
#   v1.3, 19-05-2010, Hugo Maia Vieira:
#       - Fechada release depois de serem feitos vários testes e ajustes.
#
# ------------------------------------------------------------------------------
#
# Autor     : Hugo Henriques Maia Vieira <hugomaiavieira@gmail.com>
#
# Licença: GPL.
#

# ==========================    Variáveis    ===================================

# Mandinga para pegar o diretório onde o script foi executado
FOLDER=$(cd $(dirname $0); pwd -P)

ruby18=0
ruby19=0
rails=0
python=0
vim=0

# ====================    Pegando arquitetura do sistema    ====================

uname -a | grep i686 1>& /dev/null # Ubuntu 32 bits
if [ $? = 0 ]
    then
        arquitetura=x86
fi

uname -a | grep x86_64 1>& /dev/null # Ubuntu 64 bits
if [ $? = 0 ]
    then
        arquitetura=x86_64
fi

#================================ Menu =========================================

# Instala o dialog
sudo apt-get install -y dialog > /dev/null

opcoes=$( dialog --stdout --separate-output                                                     \
    --title "afterFormat - Pós Formatação para Ubuntu 10.04 LST"                                \
    --checklist 'Selecione os softwares que deseja instalar:' 0 0 0                             \
    Desktop         "Muda \"Área de Trabalho\" para \"Desktop\" *(Apenas ptBR)"             ON  \
    Botões          "Muda os botões minimizar, maximizar e fechar para a direita"           ON  \
    PS1             "\$PS1 no formato: usuário ~/diretório/atual (BranchGit)"                ON  \
    SSH             "SSH server e client"                                                   ON  \
    Ruby1.8         "Ambiente para desenvolvimento com Ruby1.8"                             ON  \
    Ruby1.9         "Ambiente para desenvolvimento com Ruby1.9"                             ON  \
    Rails           "Ambiente para desenvolvimento com Rails (para cada Ruby)"              ON  \
    Python          "Ferramentas para desenvolvimento python"                               ON  \
    MySql           "Banco de dados + interface para ruby e python (caso forem escolhidos)" ON  \
    PostgreSQL      "Banco de dados + interface para ruby e python (caso forem escolhidos)" OFF \
    Java            "Java Development Kit e Java Runtime Environment"                       ON  \
    SVN             "Sistema de controle de versão"                                         ON  \
    Git             "Sistema de controle de versão com configurações úteis"                 ON  \
    GitMeldDiff     "Torna o Meld o software para visualização do diff do git"              ON  \
    VIM             "Editor de texto, com configurações úteis"                              ON  \
    Gedit           "Plugins oficiais, Gmate e configurações úteis"                         ON  \
    StarDict        "Dicionário multi-línguas (inclui dicionario PTbr-En/En-PTbr)"          ON  \
    Xournal         "Software para fazer anotações e marcar texto em pdf"                   ON  \
    Media           "Codecs, flashplayer (32/64 bits, nativo) e compactadores de arquivos"  ON  \
    Gimp            "Software para manipulação de imagens"                                  ON  \
    Inkscape        "Software para desenho vetorial"                                        ON  \
    RecordMyDesktop "Ferramenta para gravação do video e áudio do computador"               ON  \
    XChat           "Cliente IRC"                                                           ON  \
    Dia             "Editor de diagramas"                                                   ON  \
    Chromium        "Versão opensouce do navegador web Google Chrome"                       ON  \
    GoogleChrome   "Navegador web Google Chrome (versao estavel)"                           ON  \
    Pidgin          "Cliente de mensagens instantâneas"                                     ON  \
    Jdownloader     "Baixa automaticamente do rapidshare, megaupload e etc"                 ON  \
    Firefox         "Complementos para o firefox"                                           ON  )

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

    [ "$opcao" = 'Botões' ] && gconftool-2 --set "/apps/metacity/general/button_layout" --type string ":minimize,maximize,close"

    [ "$opcao" = 'PS1' ] && echo 'export PS1="\[\033[36m\]\u \[\033[33m\]\w \[\033[34m\]\`branch=\$(git branch 2> /dev/null | grep \"\* .*\" | grep -Pwo \".*\") && test -n \$branch && echo \"(\$branch) \"\`\[\033[00m\]$ "' >> $HOME/.bashrc

    [ "$opcao" = 'SHH' ] && sudo apt-get install -y openssh-server openssh-client

    if [ "$opcao" = 'Ruby1.8' ]
    then
        sudo apt-get install -y ruby1.8 rubygems1.8 ruby1.8-dev libopenssl-ruby1.8 irb1.8
        sudo ./variaveis_ambiente.sh "ruby_on_rails1.8"
        echo "alias sudo='sudo env PATH=\$PATH'" >> $HOME/.bashrc
        # rvm
        sudo apt-get install -y curl
        bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-latest )
        echo "if [[ -s \$HOME/.rvm/scripts/rvm ]] ; then source \$HOME/.rvm/scripts/rvm ; fi" >> $HOME/.bashrc
        ruby18=1
    fi

    if [ "$opcao" = 'Ruby1.9' ]
    then
        sudo apt-get install -y ruby1.9.1-full rubygems1.9.1 ruby1.9.1-dev libopenssl-ruby1.9.1 irb1.9
        sudo ./variaveis_ambiente.sh "ruby_on_rails1.9"
        if [ "$ruby18" -ne 1 ]
        then
            echo "alias sudo='sudo env PATH=\$PATH'" >> $HOME/.bashrc
            # rvm
            sudo apt-get install -y curl
            bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-latest )
            echo "if [[ -s \$HOME/.rvm/scripts/rvm ]] ; then source \$HOME/.rvm/scripts/rvm ; fi" >> $HOME/.bashrc
        fi
        ruby19=1
    fi

    if [ "$opcao" = 'Rails' ]
    then
        if [ "$ruby18" -eq 1 ] || [ "$ruby19" -eq 1 ]
        then
            if [ "$ruby18" -eq 1 ]
            then
                sudo apt-get install -y bcrypt libxml2 libxml2-dev libxslt1-dev
                sudo gem1.8 install rake
                sudo gem1.8 install rails
                sudo gem1.8 install haml
                sudo gem1.8 install formtastic
                sudo gem1.8 install inherited_resources
                sudo gem1.8 install database_cleaner
                sudo gem1.8 install bcrypt-ruby
                sudo gem1.8 install will_paginate
                sudo gem1.8 install factory_girl
                sudo gem1.8 install brazilian-rails
                sudo gem1.8 install gherkin
                sudo gem1.8 install cucumber-rails
                sudo gem1.8 install webrat
                sudo gem1.8 install rspec-rails
                sudo gem1.8 install mongrel
                sudo gem1.8 install capistrano
                sudo gem1.8 install authlogic
                sudo gem1.8 install remarkable_rails
                rails=1
            fi
            if [ "$ruby19" -eq 1 ]
            then
                sudo apt-get install -y bcrypt libxml2 libxml2-dev libxslt1-dev
                sudo gem1.9.1 install rake
                sudo gem1.9.1 install rails
                sudo gem1.9.1 install haml
                sudo gem1.9.1 install formtastic
                sudo gem1.9.1 install inherited_resources
                sudo gem1.9.1 install database_cleaner
                sudo gem1.9.1 install bcrypt-ruby
                sudo gem1.9.1 install will_paginate
                sudo gem1.9.1 install factory_girl
                sudo gem1.9.1 install brazilian-rails
                sudo gem1.9.1 install gherkin
                sudo gem1.9.1 install cucumber-rails
                sudo gem1.9.1 install webrat
                sudo gem1.9.1 install rspec-rails
                sudo gem1.9.1 install mongrel
                sudo gem1.9.1 install capistrano
                sudo gem1.9.1 install authlogic
                sudo gem1.9.1 install remarkable_rails
                rails=1
            fi
        else
            dialog --title 'Aviso' \
            --msgbox 'O ambiente de desenvolvimento Rails só pode ser instalado em conjunto com \nalguma versão do Ruby.\n\nPara isto, após o script terminar de rodar, rode-o novamente o marcando apenas a opção Rails e a(s) versão(ões) do Ruby que deseja instalar.' \
            0 0
        fi
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
        python=1
    fi

    if [ "$opcao" = 'MySql' ]
    then
        sudo apt-get install -y mysql-server-5.1 libmysqlclient16-dev
        test "$python" -eq 1 && sudo apt-get install -y python-mysqldb
        test "$ruby18" -eq 1 && sudo apt-get install -y libmysql-ruby1.8
        test "$ruby19" -eq 1 && sudo apt-get install -y libmysql-ruby1.9.1
        test "$rails"  -eq 1 && test "$ruby18" -eq 1 && sudo gem1.8 install mysql
        test "$rails"  -eq 1 && test "$ruby19" -eq 1 && sudo gem1.9.1 install mysql
    fi

    if [ "$opcao" = 'PostgreSQL' ]
    then
        sudo apt-get install -y postgresql
        test "$python" -eq 1 && sudo apt-get install -y python-pgsql
        test "$ruby18" -eq 1 && sudo apt-get install -y libpgsql-ruby1.8
        test "$ruby19" -eq 1 && sudo apt-get install -y libpgsql-ruby1.9
        test "$rails"  -eq 1 && test "$ruby18" -eq 1 && sudo gem1.8 install pg
        test "$rails"  -eq 1 && test "$ruby19" -eq 1 && sudo gem1.9.1 install pg
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
        sudo apt-get install --force-yes -y ubuntu-restricted-extras non-free-codecs libdvdcss2
        sudo apt-get install --force-yes -y arj lha rar unace-nonfree unrar p7zip p7zip-full p7zip-rar

        if [ "$arquitetura" = "x86" ]
        then
            sudo apt-get install --force-yes -y w32codecs
        fi

        if [ "$arquitetura" = "x86_64" ]
        then
            sudo apt-get install --force-yes -y w64codecs
            # PPA para Flashplayer 64 bits
            sudo add-apt-repository ppa:sevenmachines/flash
            # Removendo qualquer versão do Flashplayer 32 bits para que não haja conflitos
            sudo apt-get purge -y flashplugin-nonfree gnash gnash-common mozilla-plugin-gnash swfdec-mozilla
            # Instalando o dito cujo.
            sudo apt-get install -y flashplugin64-nonfree
        fi
    fi

    if [ "$opcao" = 'Chromium' ]
    then
        sudo ./repositorios.sh "chromium"
        sudo apt-get install --force-yes -y chromium-browser
    fi

    if [ "$opcao" = 'GoogleChrome' ]
    then

        if [ "$arquitetura" = 'x86' ]
        then
            wget -O /tmp/google-chrome-stable-i386.deb http://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
            sudo dpkg -i /tmp/google-chrome-stable-i386.deb
        fi

        if [ "$arquitetura" = 'x86_64' ]
        then
            wget -O /tmp/google-chrome-stable-amd64.deb http://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            sudo dpkg -i /tmp/google-chrome-stable-amd64.deb
        fi

    fi

    if [ "$opcao" = 'StarDict' ]
    then
        sudo apt-get install -y stardict
        wget -O /tmp/Dicionarios_StarDict.tar.gz http://github.com/downloads/hugomaiavieira/afterFormat/Dicionarios_StarDict.tar.gz
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

    if [ "$opcao" = 'Firefox' ]
    then
        wget -O /tmp/firefox-firebug.xpi https://addons.mozilla.org/pt-BR/firefox/downloads/latest/1843/addon-1843-latest.xpi?src=addondetail
        # A versão 1.1.8 (atual neste momento) não é compatível com o Firefox 3.6.3 padrão do Ubuntu 10.04
        #wget -O /tmp/firefox-webDeveloper.xpi https://addons.mozilla.org/pt-BR/firefox/downloads/latest/60/addon-60-latest.xpi?src=addondetail
        wget -O /tmp/firefox-downloadHelper.xpi https://addons.mozilla.org/pt-BR/firefox/downloads/latest/3006/addon-3006-latest.xpi?src=addondetail
        wget -O /tmp/firefox-downThemAll.xpi https://addons.mozilla.org/en-US/firefox/downloads/latest/201/addon-201-latest.xpi?src=addondetail
        sudo mv /tmp/firefox-* /usr/lib/firefox-3*/extensions
        dialog --title 'Complementos do Firefox' \
            --msgbox 'Aceite a instalação dos complementos e em seguida o encerre o Firefox.' \
        0 0
        sudo firefox
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

    [ "$opcao" = 'Java' ]               && sudo apt-get install -y openjdk-6-jdk openjdk-6-jre
    [ "$opcao" = 'SVN' ]                && sudo apt-get install -y subversion
    [ "$opcao" = 'Gimp' ]               && sudo apt-get install -y gimp
    [ "$opcao" = 'Xournal' ]            && sudo apt-get install -y xournal
    [ "$opcao" = 'Inkscape' ]           && sudo apt-get install -y inkscape
    [ "$opcao" = 'RecordMyDesktop' ]    && sudo apt-get install -y gtk-recordmydesktop
    [ "$opcao" = 'XChat' ]              && sudo apt-get install -y xchat
    [ "$opcao" = 'Dia' ]                && sudo apt-get install -y dia
    [ "$opcao" = 'Pidgin' ]             && sudo apt-get install -y pidgin

    if [ "$opcao" = 'Jdownloader' ]
    then
        sudo ./repositorios.sh "jdownloader"
        sudo apt-get install --force-yes -y jdownloader
    fi
done

dialog --title 'Aviso' \
        --msgbox 'Instalação concluída!' \
0 0

