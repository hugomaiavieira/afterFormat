#!/bin/bash
#
# repositorios - Adiciona repositórios necessários para a instalação de alguns
#                pacotes.
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
#   v1.2 12-10-2010, Hugo Maia Vieira:
#       - Removido repositório do Chromium e adicionado teste para adicionar o
#         ppa do flash para 64bits.
#
#-------------------------------------------------------------------------------
#
# The MIT License
#
# Copyright (c) 2010 Hugo Henriques Maia Vieira
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#-------------------------------------------------------------------------------

if [ "$1" = "gmate" ]
then
    sudo add-apt-repository ppa:ubuntu-on-rails/ppa
    sudo apt-get update
fi

if [ "$1" = "media" ]
then
    sudo wget http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list --output-document=/etc/apt/sources.list.d/medibuntu.list
    sudo apt-get update
    sudo apt-get -y --allow-unauthenticated install medibuntu-keyring

    # PPA para Flashplayer 64 bits
    uname -a | grep x86_64 1>& /dev/null
    [ $? = 0 ] && sudo add-apt-repository ppa:sevenmachines/flash

    sudo apt-get update
fi

if [ "$1" = "jdownloader" ]
then
    sudo add-apt-repository ppa:jd-team/jdownloader
    sudo apt-get update
fi

if [ "$1" = "virtualbox" ]
then
    sudo echo deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) non-free > /etc/apt/sources.list.d/virtualbox.list
    sudo apt-key add oracle_vbox.asc
    sudo apt-get update
fi

