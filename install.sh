#!/bin/bash

# --------------------------------------------------------------------------

# Arquivo de instalação do sistema Recovery RISO UEFI

# --------------------------------------------------------------------------

    DEPENDENCIAS="apache2 avahi-utils avahi-daemon bash bittorrent coreutils dialog dosfstools findutils grub-efi mount net-tools ntfs-3g os-prober psmisc rtorrent sed ssh util-linux"
    
    DIRPATH=`dirname $0`

    VERSION=`cat $DIRPATH/riso.version`

atualizar_sistema_recovery() {

    clear

    echo -e '\033[36m Atualizando o sistema operacional do RECOVERY RISO UEFI...\n\033[m'

    apt update

    apt autoremove -y

    echo -e '\033[36m O sistema operacional do RECOVERY RISO UEFI foi atualizado com sucesso.\n\033[m'
    
    sleep 5

}
    
    
configurar_boot(){

    clear
    
    echo -e '\033[36m Configurando o sistema de boot e atualizando...\n\033[m'

    sed /'GRUB_DISTRIBUTOR='/d -i /etc/default/grub

    echo 'GRUB_DISTRIBUTOR="Recovery RISO UEFI - '$VERSION'"' >> /etc/default/grub

    sed /'GRUB_TIMEOUT='/d -i /etc/default/grub

    echo 'GRUB_TIMEOUT=-1' >> /etc/default/grub

    sed /'GRUB_BACKGROUND='/d -i /etc/default/grub

    echo 'GRUB_BACKGROUND="/grub.png"' >> /etc/default/grub

    rm -f /etc/grub.d/20_memtest86+

    if [ -e /etc/grub.d/10_linux ]; then
            
    mv /etc/grub.d/10_linux /etc/grub.d/50_linux

    fi

    update-grub

    echo -e '\033[33m O sistema de boot foi configurando e atualizando com sucesso.\n\033[m'
    
    sleep 5
}

configurar_servicos(){

    clear
    
    echo -e '\033[36m Configurando os serviços do sistema RISO UEFI...\n\033[m'

    echo '#!/bin/bash' > /etc/init.d/RISOServiceRemoval

    echo 'rm /etc/avahi/services/*' >> /etc/init.d/RISOServiceRemoval

    echo 'exit 0' >> /etc/init.d/RISOServiceRemoval

    chmod 755 /etc/init.d/RISOServiceRemoval

    update-rc.d RISOServiceRemoval defaults 2> /dev/null

    sed s/'use-ipv6=yes'/'use-ipv6=no'/g -i /etc/avahi/avahi-daemon.conf

    echo -e '\033[36m Os serviços do sistema RISO UEFI foram configurados com sucesso.\n\033[m'
    
    sleep 5

}

criar_arvore_diretorios() {

    clear
    
    echo -e '\033[36m Criando a árvore dos diretórios...\n\033[m'

    mkdir -p /usr/riso

    mkdir -p /usr/riso/imagens

    echo -e '\033[36m A árvore dos diretórios foi criada com sucesso.\n\033[m'
    
    sleep 5
}

instalar_dependencias_pacotes() {

    clear
    
    echo -e '\033[36m Instalando as dependências dos pacotes...\n\033[m'
    
    for i in $DEPENDENCIAS; do

    apt install -y $i;

    if [ "$?" != "0" ]; then

    echo -e '\033[36m - Erro - Falha ao baixar e instalar as dependências:\n\033[m'$i

    return 0

    fi

    done
    
    echo -e '\033[36m As dependências dos pacotes foram instaladas com sucesso.\n\033[m'
    
    sleep 5
}


instalar_recovery() {

    clear

    echo -e '\033[36m Instalando o sistema RECOVERY RISO UEFI...\033[36m' $VERSION
    
    echo -e '\033[36m Atualizando o sistema operacional do RECOVERY RISO UEFI e instalando as dependências dos pacotes...\n\033[m'

    apt update

    apt autoremove -y

    for i in $DEPENDENCIAS; do

    apt install -y $i;

    if [ "$?" != "0" ]; then

    echo -e '\033[36m - Erro - Falha ao baixar e instalar as dependências: $i\n\033[m'

    return 1

    fi

    done

    echo -e '\033[36m O sistema operacional do RECOVERY RISO UEFI e as dependências dos pacotes foram instalados e atualizados com sucesso.\n\033[m'
    
    echo -e '\033[36m Criando a árvore dos diretórios...\n\033[m'

    mkdir -p /usr/riso

    mkdir -p /usr/riso/imagens

    echo -e '\033[36m A árvore dos diretórios foi criada com sucesso.\n\033[m'

    echo -e '\033[36m Instalando os scritps...\n\033[m'

    cp $DIRPATH/riso /usr/riso/riso

    echo '#!/bin/bash' > /usr/bin/riso

    echo '/usr/riso/riso $@' >> /usr/bin/riso

    chmod +x /usr/riso/riso

    chmod +x /usr/bin/riso

    cp $DIRPATH/risos /usr/riso/risos

    echo '#!/bin/bash' > /usr/bin/risos

    echo '/usr/riso/risos $@' >> /usr/bin/risos

    chmod +x /usr/riso/risos

    chmod +x /usr/bin/risos

    echo '#!/bin/bash' > /usr/riso/quitRTorrent.sh

    echo 'pkill rtorrent' >> /usr/riso/quitRTorrent.sh

    chmod +x /usr/riso/quitRTorrent.sh

    cp $DIRPATH/rtorrent.rc /root/.rtorrent.rc

    cp $DIRPATH/riso-EFI.cfg /usr/riso/riso-EFI.cfg

    cp $DIRPATH/riso.version /usr/riso/riso.version

    cp $DIRPATH/grub.png /grub.png

    echo -e '\033[36m Os scritps foram instalados com sucesso.\n\033[m'

    echo -e '\033[36m Configurando o sistema de boot e atualizando...\n\033[m'

    sed /'GRUB_DISTRIBUTOR='/d -i /etc/default/grub

    echo 'GRUB_DISTRIBUTOR="Recovery RISO UEFI '$VERSION'"' >> /etc/default/grub

    sed /'GRUB_TIMEOUT='/d -i /etc/default/grub

    echo 'GRUB_TIMEOUT=-1' >> /etc/default/grub

    sed /'GRUB_BACKGROUND='/d -i /etc/default/grub

    echo 'GRUB_BACKGROUND="/grub.png"' >> /etc/default/grub

    rm -f /etc/grub.d/20_memtest86+

    if [ -e /etc/grub.d/10_linux ]; then
            
    mv /etc/grub.d/10_linux /etc/grub.d/50_linux

    fi

    update-grub

    echo -e '\033[36m O sistema de boot foi configurando e atualizando com sucesso.\n\033[m'

    echo -e '\033[36m Configurando os serviços do sistema RISO UEFI...\n\033[m'

    echo '#!/bin/bash' > /etc/init.d/RISOServiceRemoval

    echo 'rm /etc/avahi/services/*' >> /etc/init.d/RISOServiceRemoval

    echo 'exit 0' >> /etc/init.d/RISOServiceRemoval

    chmod 755 /etc/init.d/RISOServiceRemoval

    update-rc.d RISOServiceRemoval defaults 2> /dev/null

    sed s/'use-ipv6=yes'/'use-ipv6=no'/g -i /etc/avahi/avahi-daemon.conf

    echo -e '\033[36m Os serviços do sistema RISO UEFI foram configurados com sucesso.\n\033[m'

    echo -e '\033[36m O Sistema RECOVERY RISO UEFI\033[m' $VERSION '\033[36m foi instalado com sucesso.\n\033[m'
    
    sleep 5
    
    reboot
}

instalar_scripts(){

    clear

    echo -e '\033[36m Instalando os scritps...\n\033[m'

    cp $DIRPATH/riso /usr/riso/riso

    echo '#!/bin/bash' > /usr/bin/riso

    echo '/usr/riso/riso $@' >> /usr/bin/riso

    chmod +x /usr/riso/riso

    chmod +x /usr/bin/riso

    cp $DIRPATH/risos /usr/riso/risos

    echo '#!/bin/bash' > /usr/bin/risos

    echo '/usr/riso/risos $@' >> /usr/bin/risos

    chmod +x /usr/riso/risos

    chmod +x /usr/bin/risos

    echo '#!/bin/bash' > /usr/riso/quitRTorrent.sh

    echo 'pkill rtorrent' >> /usr/riso/quitRTorrent.sh

    chmod +x /usr/riso/quitRTorrent.sh

    cp $DIRPATH/rtorrent.rc /root/.rtorrent.rc

    cp $DIRPATH/riso-EFI.cfg /usr/riso/riso-EFI.cfg

    cp $DIRPATH/riso.version /usr/riso/riso.version

    cp $DIRPATH/grub.png /grub.png

    echo -e '\033[36m Os scritps foram instalados com sucesso.\n\033[m'
    
    sleep 5
    
}

menu() {

    while : ; do

    OPCAO=$(dialog --stdout\
    --ok-label 'Confirmar'\
    --cancel-label 'Sair'\
    --title "RISO UEFI $VERSION"\
    --menu 'Selecione uma opção:'\
    0 60 0\
    1 'Atualizar o sistema RECOVERY'\
    2 'Configurar o boot'\
    3 'Configurar os serviços'\
    4 'Criar a árvore de diretórios'\
    5 'Instalar as dependências dos pacotes'\
    6 'Instalar o sistema RECOVERY'\
    7 'Instalar os scripts')

    [ $? -ne 0 ] && break

    case $OPCAO in

    1) atualizar_sistema_recovery;;

    2) configurar_boot;;

    3) configurar_servicos;;

    4) criar_arvore_diretorios;;

    5) instalar_dependencias_pacotes;;

    6) instalar_recovery;;

    7) instalar_scripts;;

    esac

    done

}

#Verifica se usuário é o root antes de instalar e caso não seja o root termina a execução.

    if [ $(id -u) -ne "0" ]; then

    echo -e '\033[36;5m Este script deve ser executado pelo usuário root. Execute o script novamente.\n\033[m'

    exit 1

    else

    menu

    fi