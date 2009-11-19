#!/bin/bash
#
# repositorios - Adiciona repositórios necessários para a instalação de alguns
#                pacotes.
#
# Autor     : Hugo Henriques Maia Vieira <hugouenf@gmail.com>
# Versão    : 1.0
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
#
# Licença: GPL.
#
# TODO: Dividir em ifs verificando o parametro passado. Colocar um apt-get update para cada um.
#-------------------------------------------------------------------------------

if [ "$1" = "gmate" ]
then
    sudo echo "deb http://ppa.launchpad.net/ubuntu-on-rails/ppa/ubuntu karmic main" >> /etc/apt/sources.list
    sudo echo "deb-src http://ppa.launchpad.net/ubuntu-on-rails/ppa/ubuntu karmic main" >> /etc/apt/sources.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 81C0BE11
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

