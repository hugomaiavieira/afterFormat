#!/bin/bash
#
# variaveis_ambiente - Cria variáveis ambiente necessárias para os softwares
#                      instalados pelo script installLab.
#
# Autor     : Hugo Henriques Maia Vieira <hugouenf@gmail.com>
# Versão    : 1.1
#
# ------------------------------------------------------------------------------
#
#   Ao executar o script as variáveis ambiente são criadas adicionando linhas
#   ao arquivo /etc/bash.bashrc que é lido ao iniciar o terminal.
#
# ------------------------------------------------------------------------------
#
# Histórico:
#
#   v1.0 15-04-2009, Hugo Maia:
#       - Versão inicial.
#   v1.1 06-10-09, Hugo Maia:
#       - Refatorado retirando variáveis do eclipse e adicionadas variáveis do
#         lingo e do ruby.
#
# Licença: GPL.
#
# TODO: Dividir em ifs verificando o parametro passado.
#-------------------------------------------------------------------------------

if [ "$1" = "ruby_on_rails" ]
then
    sudo echo "export PATH="$PATH:$PATH:/var/lib/gems/1.8/bin"" >> /etc/bash.bashrc
fi

if [ "$1" = "lingo" ]
then
    sudo echo "export LD_LIBRARY_PATH="$HOME/Install/lingo11/bin/linux32:$LD_LIBRARY_PATH"" >> /etc/bash.bashrc
    sudo echo "export LINGO_11_LICENSE_FILE="$HOME/Install/lingo11/license/lndlng11.lic"" >> /etc/bash.bashrc
fi

