AFTER FORMAT
============

Instala automaticamente diversos softwares b&aacute;sicos que sempre s&atilde;o necess&aacute;rios
ap&oacute;s uma formata&ccedil;&atilde;o. O PC deve estar conectado &agrave; internet. O tempo de
instala&ccedil;&atilde;o depender&aacute; da velocidade de sua conex&atilde;o.

**Obs**.: Este script est&aacute; validado apenas para o **Ubuntu 10.10**.
Para outras vers&otilde;es do Ubuntu verifique os branches.


SOFTWARES E CONFIGURA&Ccedil;&Otilde;ES
---------------------------------------

* **Desktop**           - Muda "&Aacute;rea de Trabalho" para "Desktop"
* **Bot&otilde;es**     - Muda os bot&otilde;es minimizar, maximizar e fechar para a direita
* **PS1**               - $PS1 no formato: <span style="padding: 2px; font-family: monospace"><span style="color: #06989A;">usu&aacute;rio</span> <span style="color: #B8A000;">~/diret&oacute;rio/atual</span> <span style="color: #3465a4;">(git_branch_atual)</span> $</span>
* **SSH**               - Instala o ssh cliente e servidor
    * Instala os pacotes: *openssh-server, openssh-client*
* **Ruby1.8.7**           - Ambiente para desenvolvimento com Ruby1.8.7
    * Instala os pacotes: *libssl-dev, libreadline5-dev*
    * Instala o *rvm*
    * Instala o *ruby-1.8.7* no *rvm*
    * Adiciona a versão do ruby ativa na variável PS1.
* **Ruby1.9.2**           - Ambiente para desenvolvimento com Ruby1.9.2
    * Instala os pacotes: *libssl-dev, libreadline5-dev*
    * Instala o *rvm*
    * Instala o *ruby-1.9.2* no *rvm*
    * Adiciona a versão do ruby ativa na variável PS1.
* **Python**            - Ferramentas para desenvolvimento python
    * Instala os pacotes: *ipython, python-dev*
    * Instala o distribute, pip, virtualenv e virtualenvwrapper
    * Configura a vari&aacute;vel WORKON_HOME, usada pelo virtualenvwrapper como diret&oacute;rio que concentra os ambientes virtuais, para ser ~/envs
    * Adiciona a linha `source /usr/local/bin/virtualenvwrapper.sh` no arquivo` `~/bashrc`, para sempre habilitar os comandos do virtualenvwrapper
* **MySql**             - Banco de dados + interface para ruby e python (caso forem escolhidos)
    * Instala os pacotes: *mysql-server-5.1, libmysqlclient16-dev*
* **PostgreSQL**        - Banco de dados + interface para ruby e python (caso forem escolhidos)
    * Instala o pacote: *postgresql*
* **Java**              - Java Development Kit e Java Runtime Environment
    * Instala os pacotes: *openjdk-6-jdk, openjdk-6-jre*
* **SVN**               - Sistema de controle de vers&atilde;o
* **Git**               - Sistema de controle de vers&atilde;o com configura&ccedil;&otilde;es &uacute;teis
    * Instala o pacote: *git-cire*
    * Configura o git para exibir com cores as sa&iacute;das de seus comandos
    * Cria as abrevia&ccedil;&otilde;es
        * br para branch
        * ci para commit
        * co para checkout
        * st status
    * Caso seja escolhida tamb&eacute;m a op&ccedil;&atilde;o Vim, configura o Vim para ser o editor padr&atilde;o do git
* **GitMeldDiff**       - Torna o Meld o software para visualiza&ccedil;&atilde;o do diff do git
* **VIM**               - Editor de texto, com configura&ccedil;&otilde;es &uacute;teis
    * Instala o pacote: *vim*
    * Criar o arquivo `/etc/vim/vimrc.local` com diversas configura&ccedil;&otilde;es &uacute;teis
* **Gedit**             - Plugins oficiais, Gmate e configura&ccedil;&otilde;es &uacute;teis
    * Adiciona o reposit&oacute;rio *ubuntu-on-rails*
    * Instala os pacotes: *gedit-plugins, gedit-gmate*
    * Seleciona os plugins mais &uacute;teis e faz algumas configura&ccedil;&otilde;es no editor
* **StarDict**          - Dicion&aacute;rio multi-l&iacute;nguas
    * Inclui dicion&aacute;rios Ingl&ecirc;s-Portugu&ecirc;s e Portugu&ecirc;s-Ingl&ecirc;s
* **Xournal**           - Software para fazer anota&ccedil;&otilde;es e marcar texto em pdf
* **Media**             - Codecs, flashplayer (32 e 64 bits) e compactadores
    * Instala os pacotes: *ubuntu-restricted-extras, non-free-codecs, libdvdcss2, arj, lha, rar, unace-nonfree, unrar, p7zip, p7zip-full, p7zip-rar*
    * Verifica se o Ubuntu &eacute; de 32 ou 64 bits e instala o pacote w32codecs ou w64codecs
* **Gimp**              - Software para manipula&ccedil;&atilde;o de imagens
* **Inkscape**          - Software para desenho vetorial
* **RecordMyDesktop**   - Ferramenta para grava&ccedil;&atilde;o do video e &aacute;udio do computador (perfeito para fazer screencasts)
* **XChat**             - Cliente IRC
* **Dia**               - Editor de diagramas
* **GoogleChrome**      - Navegador web Google Chrome
    * Instala a vers&atilde;o *estável* do navegador da Google
* **Skype**             - Cliente do Skype: cliente de (video)conferencia
    * Instala o pacote deb oficial direto do site (32 ou 64 bits)
* **VirtualBox**        - Sistema de virtualizacao da Oracle
    * Adiciona o reposit&oacute;rio do VirtualBox
    * Instala o pacote *virtualbox-3.2*
* **Pidgin**            - Cliente de mensagens instant&acirc;neas
* **Jdownloader**       - Baixa automaticamente do rapidshare, megaupload e etc
* **Firefox**           - Complementos para o firefox
    * **FireBug**               - Ferramenta para desenvolvimento web
    * **Video DownloadHelper**  - DownloadHelper &eacute; uma ferramenta para extra&ccedil;&atilde;o de v&iacute;deos e arquivos de imagens dos sites
    * **DownThemAll**           - Acelerador de downloads

EXECUTANDO O SCRIPT
-------------------

Primeiramente, fa&ccedil;a o download do script clicando no link **Download Source** no
topo desta p&aacute;gina e escolhendo a op&ccedil;&atilde;o TAR.

**Obs.:** Nunca rode o script a partir da Área de Trabalho

Em seguida, descompacte o arquivo rodando no terminal (supondo que você baixou o arquivo na pasta Download):

    $ cd Download
    $ tar xzfv hugomaiavieira-afterFormat-*.tar.gz

Finalmente para executar o script afterFormat.sh:

    $ cd hugomaiavieira-afterFormat-*.tar.gz
    $ ./afterFormat.sh


INFORMA&Ccedil;&Atilde;O
------------------------

Ao executar o script todos os softwares ser&atilde;o instalados automaticamente,
sendo que o MySql pedir&aacute; para escolher a senha de root durante a
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

  12 de Outubro de 2010

