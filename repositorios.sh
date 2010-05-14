#!/bin/bash
#
# repositorios - Adiciona repositórios necessários para a instalação de alguns
#                pacotes.
#
# Autor     : Hugo Henriques Maia Vieira <hugouenf@gmail.com>
#
# ------------------------------------------------------------------------------
#
#   Ao executar o script os repositórios serão adicionados adicionando linhas
#   ao arquivo /etc/apt/sources.list. São adicionandas chaves publicas dos
#   repositórios e é feito um update da base de pacotes dos repositórios.
#
# ------------------------------------------------------------------------------
#
# Histórico:
#
#   v1.0 15-04-2009, Hugo Maia:
#       - Versão inicial com os repositórios ubuntu-on-rails e medibuntu.
#   v1.1 09-05-2010, Hugo Maia Vieira:
#       - Adicionado repositórios do jdownloader.
#
# Licença: GPL.
#
#-------------------------------------------------------------------------------

if [ "$1" = "gmate" ]
then
    sudo add-apt-repository ppa:ubuntu-on-rails/ppa
    sudo apt-get update
fi

if [ "$1" = "chromium" ]
then
    sudo add-apt-repository ppa:chromium-daily
    sudo apt-get update
fi

if [ "$1" = "media" ]
then
    sudo wget http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list --output-document=/etc/apt/sources.list.d/medibuntu.list
    sudo apt-get update
    sudo apt-get -y --allow-unauthenticated install medibuntu-keyring
    sudo apt-get update
fi

if [ "$1" = "jdownloader" ]
then
    sudo add-apt-repository ppa:jd-team/jdownloader
    sudo apt-get update
fi

