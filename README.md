AFTER FORMAT
============

Instala automaticamente diversos softwares básicos que sempre são necessários
após uma formatação. O PC deve estar conectado à internet. O tempo de
instalação dependerá da velocidade de sua conexão.

**Obs**.: Este script está validado apenas as versões **11.04 do Ubuntu**.
Para outras versões do Ubuntu verifique os branches.


SOFTWARES E CONFIGURAÇÕES
-------------------------

* **Desktop**           - Muda "Área de Trabalho" para "Desktop"
* **PS1**               - $PS1 no formato:
    * Sem ruby instalado: **usuário ~/diretório/atual (git_branch_atual) $**
    * Com ruby instalado: **(versao_do_ruby_ativa@gemset_ativa) usuário ~/diretório/atual (git_branch_atual) $**
* **SSH**               - Instala o ssh cliente e servidor
    * Instala os pacotes: *openssh-server, openssh-client*
* **Ruby1.9.2**           - Ambiente para desenvolvimento com Ruby1.9.2
    * Instala os pacotes: *libssl-dev, libreadline5-dev*
    * Instala o *rvm*
    * Instala o *ruby-1.9.2* no *rvm*
* **Python**            - Ambiente para desenvolvimento com python
    * Instala os pacotes: *ipython, python-dev*
    * Instala o distribute, pip, virtualenv e virtualenvwrapper
    * Configura a variável WORKON_HOME, usada pelo virtualenvwrapper como diretório que concentra os ambientes virtuais, para ser ~/envs
    * Adiciona a linha `source /usr/local/bin/virtualenvwrapper.sh` no arquivo ~/bashrc, para sempre habilitar os comandos do virtualenvwrapper
* **MySql**             - Banco de dados + interface para ruby e python (caso forem escolhidos)
    * Instala os pacotes: *mysql-server-5.1, libmysqlclient16-dev*
* **PostgreSQL**        - Banco de dados + interface para ruby e python (caso forem escolhidos)
    * Instala o pacote: *postgresql*
* **Git**               - Sistema de controle de versão + configurações úteis
    * Instala o pacote: *git-core*
    * Configura o git para exibir com cores as saídas de seus comandos
    * Cria as abreviações
        * br para branch
        * ci para commit
        * co para checkout
        * st status
    * Caso seja escolhida também a opção Vim, configura o Vim para ser o editor padrão do git
* **GitMeldDiff**       - Torna o Meld o software para visualização do diff do git
* **VIM**               - Editor de texto + configurações úteis
    * Instala o pacote: *vim*
    * Criar o arquivo `/etc/vim/vimrc.local` com diversas configurações úteis
* **Gedit**             - Plugins oficiais, Gmate + configurações úteis
    * Adiciona o repositório *ubuntu-on-rails*
    * Instala os pacotes: *gedit-plugins, gedit-gmate*
    * Seleciona os plugins mais úteis e faz algumas configurações no editor
    * Instala o Batraquio (coleção de snippets e tools para desenvolvimento com BDD usando)
* **Refactoring**       - Conjunto de scripts para refatoração de código
    * Instala os scripts, criando links simbólicos e ativando os comandos: change-file-name, find-replace, html-characters e remove-temps
* **StarDict**          - Dicionário multi-línguas
    * Inclui dicionários Inglês-Português e Português-Inglês
* **Media**             - Codecs, flashplayer (32 ou 64 bits) e compactadores
    * Instala diversos pacotes de codecs, compactadores de arquivos, JRE e verifica se o sistema é 32 ou 64 bits e instala o flashplayer correspondente.
* **Gimp**              - Software para manipulação de imagens
* **Inkscape**          - Software para desenho vetorial
* **XChat**             - Cliente IRC
* **GoogleChrome**      - Navegador web Google Chrome
    * Instala a versão *estável* do navegador da Google
* **Thunderbird**       - Gerenciador de e-mails
    * Instala o pacote *thunderbird*
* **Skype**             - Cliente do Skype: cliente de (video)conferencia
    * Instala o pacote deb oficial direto do site (32 ou 64 bits)


EXECUTANDO O SCRIPT
-------------------

Primeiramente, faça o download do script clicando no link **Download** no
topo desta página. Na tela que abrirá, clique em **Download .tar.gz**.

**Obs.: Nunca rode o script a partir da Área de Trabalho**

Em seguida, descompacte o arquivo rodando no terminal (supondo que você baixou o arquivo na pasta Download):

    $ cd Download
    $ tar xzfv hugomaiavieira-afterFormat-*.tar.gz

Dê permissão de execução ao script:

    $ cd hugomaiavieira-afterFormat-*
    $ chmod +x afterFormat.sh

Finalmente para executar:

    $ ./afterFormat.sh


INFORMAÇÃO
-----------

Ao executar o script todos os softwares serão instalados automaticamente,
sendo que o MySql pedirá para escolher a senha de root durante a
instalação. Os softwares são instalados na ordem em que aparecem na
lista.


CONFIGURANDO O STARDICT
-----------------------

Vá em Aplicativos->Acessórios->StarDict

1. No canto inferior direito clique no ícone "Preferências". Vá em
    Dicionário->Leitura e seleção, marque "Somente ler se uma tecla ..." e
    escolha uma tecla modificadora (a tecla Win é a tecla com o logo do
    Windowns). Clique em fechar.

2. No canto inferior direito clique no ícone "Administrar dicionários". Na
    aba Administrar Dic desmarque todas as entradas "QQWry", "Man" e
    "Dict.cn". Clique em fechar

Para utilizar, basta abrir o StarDict e digitar a palavra ou em qualquer
lugar (documento pdf, odp, no navegador e etc) selecione uma palavra e
aperte a tecla modificadora escolhida no passo 1.


AUTOR
-----

  Hugo Henriques Maia Vieira <hugomaiavieira@gmail.com>

  30 de Abril de 2011

