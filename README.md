AFTER FORMAT
============

Instala automaticamente diversos softwares b&aacute;sicos que sempre s&atilde;o necess&aacute;rios
ap&oacute;s uma formata&ccedil;&atilde;o. O PC deve estar conectado &agrave; internet. O tempo de
instala&ccedil;&atilde;o depender&aacute; da velocidade de sua conex&atilde;o.

**Obs**.: Este script est&aacute; validado apenas para o **Ubuntu 10.04 LST**.
Para outras vers&otilde;es do Ubuntu verifique os branches.


SOFTWARES INSTALADOS
--------------------

* **Desktop**           - Muda "&Aacute;rea de Trabalho" para "Desktop
* **Bot&otilde;es**     - Muda os bot&otilde;es minimizar, maximizar e fechar para a direita
* **PS1**               - $PS1 no formato: <span style="padding: 2px; font-family: monospace"><span style="color: #06989A;">usu&aacute;rio</span> <span style="color: #B8A000;">~/diret&oacute;rio/atual</span> <span style="color: #3465a4;">(BranchGit)</span> $</span>
* **SSH**               - Instala o ssh cliente e servidor
* **Ruby1.8**           - Ambiente para desenvolvimento com Ruby1.8
    * Instala os pacotes: *ruby1.8, rubygems1.8, ruby1.8-dev, libopenssl-ruby1.8, irb1.8*
    * Adiciona o diretório `/var/lib/gems/1.8/bin` na variável *$PATH*
    * Instala o *rvm*
    * Adiciona a linha `alias sudo='sudo env PATH=\$PATH'` ao arquivo `~/.bashrc` para possibilitar a chamada de comandos como `rake` com o `sudo`
* **Ruby1.9**           - Ambiente para desenvolvimento com Ruby1.9
    * Instala os pacotes: *ruby1.8, rubygems1.8, ruby1.8-dev, libopenssl-ruby1.8, irb1.8*
    * Adiciona o diretório `/var/lib/gems/1.8/bin` na variável *$PATH*
    * Instala o *rvm*
    * Adiciona a linha `alias sudo='sudo env PATH=\$PATH'` ao arquivo `~/.bashrc` para possibilitar a chamada de comandos como `rake` com o `sudo`
* **Rails**             - Ambiente para desenvolvimento com Rails (para cada Ruby escolhido)
    * Instala os pacotes: *bcrypt, libxml2, libxml2-dev, libxslt1-dev*
    * Instala as gems: *rake, rails, haml, formtastic, inherited_resources, database_cleaner, bcrypt-ruby, will_paginate, factory_girl, brazilian-rails, gherkin, cucumber-rails, webrat, rspec-rails, mongrel, capistrano, authlogic, remarkable_rails*
* **Python**            - Ferramentas para desenvolvimento python
    * Instala os pacotes: *ipython, python-dev*
    * Instala o distribute, pip, virtualenv e virtualenvwrapper
    * Configura a variável WORKON_HOME, usada pelo virtualenvwrapper como diretório que concentra os ambientes virtuais, como ~/envs
    * Adiciona a linha `source /usr/local/bin/virtualenvwrapper.sh` no arquivo` `~/bashrc`, para sempre habilitar os comandos do virtualenvwrapper
* **MySql**             - Banco de dados + interface para ruby e python (caso forem escolhidos)
* **PostgreSQL**        - Banco de dados + interface para ruby e python (caso forem escolhidos)
* **Java**              - Java Development Kit e Java Runtime Environment
* **SVN**               - Sistema de controle de vers&atilde;o
* **Git**               - Sistema de controle de vers&atilde;o com configura&ccedil;&otilde;es úteis
* **GitMeldDiff**       - Torna o Meld o software para visualiza&ccedil;&atilde;o do diff do git
* **VIM**               - Editor de texto, com configura&ccedil;&otilde;es úteis
* **Gedit**             - Plugins oficiais, Gmate e configura&ccedil;&otilde;es úteis
* **EnvyNG**            - Software para instala&ccedil;&atilde;o de drivers Nvidia e ATI
* **StarDict**          - Dicion&aacute;rio multi-l&iacute;nguas
* **Xournal**           - Software para fazer anota&ccedil;&otilde;es e marcar texto em pdf
* **Media**             - Codecs, flashplayer e compactadores
    * **instala os pacotes**:
* **Inkscape**          - Software para desenho vetorial
* **RecordMyDesktop**   - Ferramenta para grava&ccedil;&atilde;o do video e &aacute;udio do computador (perfeito para fazer screencasts)
* **XChat**             - Cliente IRC
* **Dia**               - Editor de diagramas
* **Chromium**          - Vers&atilde;o opensouce do navegador web Google Chrome
* **Pidgin**            - Cliente de mensagens instant&acirc;neas
* **Jdownloader**       - Baixa automaticamente do rapidshare, megaupload e etc
* **Firefox**           - Complementos para o firefox
    * **FireBug**               - Ferramenta para desenvolvimento web
    * **Video DownloadHelper**  - DownloadHelper &eacute; uma ferramenta para extra&ccedil;&atilde;o de v&iacute;deos e arquivos de imagens dos sites
    * **DownThemAll**           - Acelerador de downloads


EXECUTANDO O SCRIPT
-------------------

Para executar o script afterFormat.sh, estando no diretório onde se oncontra o
arquivo, basta rodar o seguinte comando no terminal:

    $ ./afterFormat.sh


INFORMA&Ccedil;&Atilde;O
----------

Ao executar o script todos os softwares ser&atilde;o instalados automaticamente,
sendo que o MySql pedirá para escolher a senha de root durante a
instala&ccedil;&atilde;o. Os softwares s&atilde;o instalados na ordem em que aparecem na
lista.


CONFIGURANDO O STARDICT
-----------------------

V&aacute; em Aplicativos->Acess&oacute;rios->StarDict

1. No canto inferior direito clique no &iacute;cone "Prefer&ecirc;ncias". V&aacute; em
    Dicion&aacute;rio->Leitura e sele&ccedil;&atilde;o, marque "Somente ler se uma tecla ..." e
    escolha uma tecla modificadora (a tecla Win &eacute; a tecla com o logo do
    Windowns). Clique em fechar.

2. No canto inferior direito clique no &iacute;cone "Administrar dicion&aacute;rios". Na
    aba Administrar Dic desmarque todas as entradas "QQWry", "Man" e
    "Dict.cn". Clique em fechar

Para utilizar, basta abrir o StarDict e digitar a palavra ou em qualquer
lugar (documento pdf, odp, no navegador e etc) selecione uma palavra e
aperte a tecla modificadora escolhida no passo 1.


AUTOR
-----

  Hugo Henriques Maia Vieira <hugomaiavieira@gmail.com>

  18 de Maio de 2010

