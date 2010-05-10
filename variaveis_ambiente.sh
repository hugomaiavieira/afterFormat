#!/bin/bash
#
# variaveis_ambiente - Cria variáveis ambiente necessárias para os softwares
#                      instalados pelo script installLab.
#
# Autor     : Hugo Henriques Maia Vieira <hugouenf@gmail.com>
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
#   v1.2 08-05-10, Hugo Maia Vieira:
#       - Refatorado retirando a variável do lingo.
#   v1.3 09-05-10, Hugo Maia Vieira:
#       - Corrigido bug.
#
# Licença: GPL.
#
#-------------------------------------------------------------------------------

if [ "$1" = "ruby_on_rails" ]
then
    sudo echo "export PATH=\"\$PATH:/var/lib/gems/1.8/bin\"" >> /etc/bash.bashrc
fi

