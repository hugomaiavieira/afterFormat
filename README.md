AFTER FORMAT
============

Instala automaticamente diversos softwares b&aacute;sicos que sempre s&atilde;o necess&aacute;rios
ap&oacute;s uma formata&ccedil;&atilde;o. O PC deve estar conectado &agrave; internet. O tempo de
instala&ccedil;&atilde;o depender&aacute; da velocidade de sua conex&atilde;o.

**Obs**.: Este script est&aacute; validado apenas para o **Ubuntu 10.04 LST**


SOFTWARES INSTALADOS
--------------------

* **Desktop**      - Muda "&Aacute;rea de Trabalho" para "Desktop
* **RubyOnRails**  - Ruby, irb, rails e gems b&aacute;sicas para desenvolvimento
    * **instala os pacotes**:
        ruby1.8, rubygems1.8, ruby1.8-dev, libpq-dev, libopenssl-ruby1.8,
        libxml2, libxml2-dev, libxslt1.1, libxslt1-dev, libxml-ruby,
        libxslt-ruby irb
    * **instala as gems**:
        rakerails, mongrel, brazilian-rails, cucumber, webrat, rspec,
        rspec-rails, nokogiri, capistrano, authlogic, remarkable_rails
* **MySql**        - Banco de dados
* **PostgreSQL**   - Banco de dados
* **Java**         - Java Development Kit e Java Runtime Environment
* **SVN**          - Sistema de controle de vers&atilde;o
* **Git**          - Sistema de controle de vers&atilde;o
* **GitMeldDiff**  - Torna o Meld o software para visualiza&ccedil;&atilde;o do diff do git
* **Python**       - IPython, setuptools, virtualenv
* **VIM**          - Editor de texto, com configura&ccedil;&otilde;es b&aacute;sicas
* **Gedit**        - Plugins oficiais, Gmate e configura&ccedil;&otilde;es b&aacute;sicas
* **EnvyNG**       - Software para instala&ccedil;&atilde;o de drivers Nvidia e ATI
* **StarDict**     - Dicion&aacute;rio multi-l&iacute;nguas
* **Xournal**      - Software para fazer anota&ccedil;&otilde;es e marcar texto em pdf
* **Media**        - Codecs, flashplayer e compactadores
    * **instala os pacotes**:
      flashplugin-installer, ubuntu-restricted-extras, non-free-codecs,
      libdvdcss2, default-jre, w32codecs, arj, lha, rar, unace-nonfree,
      unrar, p7zip, p7zip-full, p7zip-rar
* **Inkscape**     - Software para desenho vetorial
* **XChat**        - Cliente IRC
* **Dia**          - Editor de diagramas
* **Chromium**     - Vers&atilde;o opensouce do navegador web Google Chrome
* **Firefox**      - Complementos para o firefox. FireBug e Web Developer
* **Pidgin**       - Cliente de mensagens instant&acirc;neas


EXECUTANDO O SCRIPT
-------------------

Para executar o script afterFormat.sh, primeiramente d&ecirc; a ele permiss&atilde;o de
execu&ccedil;&atilde;o, rodando o seguinte comando no terminal:

    $ chmod +x afterFormat.sh

Em seguida pode executar fazendo:

    $ ./afterFormat.sh

Se n&atilde;o quiser dar permiss&atilde;o de execu&ccedil;&atilde;o ao arquivo, pode rodar o script da
seguinte forma:

    $ bash afterFormat.sh


INFORMA&Ccedil;&Atilde;O
----------

Ao executar o script todos os softwares ser&atilde;o instalados automaticamente,
sendo que o Java, Lingo, MySql e PostgreSQL pedir&atilde;o alguns dados durante a
instala&ccedil;&atilde;o. Como os softwares s&atilde;o instalados na ordem em que aparecem na
lista, ap&oacute;s a instala&ccedil;&atilde;o dos softwares que necessitam da inser&ccedil;&atilde;o de dados,
voc&ecirc; poder&aacute; se afastar do PC pois tudo ir&aacute; seguir automaticamente.


CONFIGURANDO O STARDICT
-----------------------

V&aacute; em Aplicativos->Acess&oacute;rios->StarDict

1. No canto inferior direito clique no &iacute;cone "Prefer&ecirc;ncias". V&aacute; em
    Dicion&aacute;rio->Leitura e sele&ccedil;&atilde;o, marque "Somente ler se uma tecla ..." e
    escolha uma tecla modificadora (a tecla Win e a tecla com o logo do
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

  19 de Novembro de 2009

