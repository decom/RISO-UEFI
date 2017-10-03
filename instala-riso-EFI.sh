#!/bin/bash

# --------------------------------------------------------------------------

# Arquivo de instalação do sistema Recovery RISO UEFI

# --------------------------------------------------------------------------

    DEPENDENCIAS="apache2 avahi-utils avahi-daemon bash bittorrent coreutils dialog dosfstools findutils grub-efi mount net-tools ntfs-3g os-prober psmisc rtorrent sed ssh util-linux"
    
    DIRPATH=`dirname $0`

    VERSION=`cat ${DIRPATH}/riso-EFI.version`

atualizar_sistema_operacional_riso() {

    dialog --sleep 5  --infobox " Atualizando o sistema operacional do RISO UEFI ${VERSION}. " 10 50

    apt update && apt autoremove -y && apt autoclean -y

    dialog --sleep 5  --infobox " O sistema operacional do RISO UEFI ${VERSION} foi atualizado com sucesso." 10 50
    
}
    
    
configurar_boot(){

    dialog --sleep 5  --infobox " Configurando o sistema de boot e atualizando." 10 50

    sed /'GRUB_DISTRIBUTOR='/d -i /etc/default/grub

    echo 'GRUB_DISTRIBUTOR="Recovery RISO UEFI - '${VERSION}'"' >> /etc/default/grub

    sed /'GRUB_TIMEOUT='/d -i /etc/default/grub

    echo 'GRUB_TIMEOUT=-1' >> /etc/default/grub

    sed /'GRUB_BACKGROUND='/d -i /etc/default/grub

    echo 'GRUB_BACKGROUND="/grub.png"' >> /etc/default/grub

    rm -f /etc/grub.d/20_memtest86+

    if [ -e /etc/grub.d/10_linux ]; then
            
    mv /etc/grub.d/10_linux /etc/grub.d/50_linux

    fi

    update-grub

    dialog --sleep 5  --infobox " O sistema de boot foi configurado e atualizado com sucesso." 10 50
    
}

configurar_servicos(){

    dialog --sleep 5  --infobox " Configurando os serviços do sistema RISO UEFI ${VERSION}." 10 50

    echo '#!/bin/bash' > /etc/init.d/RISOServiceRemoval

    echo 'rm /etc/avahi/services/*' >> /etc/init.d/RISOServiceRemoval

    echo 'exit 0' >> /etc/init.d/RISOServiceRemoval

    chmod 755 /etc/init.d/RISOServiceRemoval

    update-rc.d RISOServiceRemoval defaults 2> /dev/null

    sed s/'use-ipv6=yes'/'use-ipv6=no'/g -i /etc/avahi/avahi-daemon.conf

    dialog --sleep 5  --infobox " Os serviços do sistema RISO UEFI ${VERSION} foram configurados com sucesso." 10 50
    
}

criar_arvore_diretorios() {

    dialog --sleep 5  --infobox " Criando a árvore dos diretórios." 10 50

    mkdir -p /usr/riso

    mkdir -p /usr/riso/imagens

    dialog --sleep 5  --infobox " A árvore dos diretórios foi criada com sucesso." 10 50
    
}

instalar_dependencias_pacotes() {

    clear
    
    dialog --sleep 5  --infobox " Instalando as dependências dos pacotes." 10 50
    
    for i in ${DEPENDENCIAS}; do

    apt install -y $i;

    if [ "$?" != "0" ]; then

    dialog --sleep 5  --infobox " - Erro - Falha ao baixar e instalar as dependências: $i" 10 50

    return 0

    fi

    done
    
    dialog --sleep 5  --infobox " As dependências dos pacotes foram instaladas com sucesso." 10 50
    
}


instalar_riso() {

    dialog --sleep 5 --infobox "Instalando o sistema RISO UEFI ${VERSION}." 10 50
    
    
    dialog --sleep 5 --infobox "Atualizando o sistema operacional do RISO UEFI ${VERSION} e instalando as dependências dos pacotes." 10 50
   

    apt update && apt autoremove -y && apt autoclean -y

    for i in ${DEPENDENCIAS}; do

    apt install -y $i;

    if [ "$?" != "0" ]; then

    dialog --sleep 5 --infobox "- Erro - Falha ao baixar e instalar as dependências: $i" 10 50
    

    return 1

    fi

    done

    dialog --sleep 5 --infobox "O sistema operacional do RISO UEFI ${VERSION} foi atualizado e as dependências dos pacotes foram instaladas com sucesso." 10 50
    
    
    dialog --sleep 5 --infobox "Criando a árvore dos diretórios." 10 50
    

    mkdir -p /usr/riso

    mkdir -p /usr/riso/imagens

    dialog --sleep 5 --infobox "A árvore dos diretórios foi criada com sucesso." 10 50
    

    dialog --sleep 5 --infobox "Instalando os scritps." 10 50
    
    cp ${DIRPATH}/riso /usr/riso/riso

    echo '#!/bin/bash' > /usr/bin/riso

    echo '/usr/riso/riso $@' >> /usr/bin/riso

    chmod +x /usr/riso/riso

    chmod +x /usr/bin/riso

    cp ${DIRPATH}/risos /usr/riso/risos

    echo '#!/bin/bash' > /usr/bin/risos

    echo '/usr/riso/risos $@' >> /usr/bin/risos

    chmod +x /usr/riso/risos

    chmod +x /usr/bin/risos

    echo '#!/bin/bash' > /usr/riso/quitRTorrent.sh

    echo 'pkill rtorrent' >> /usr/riso/quitRTorrent.sh

    chmod +x /usr/riso/quitRTorrent.sh

    cp ${DIRPATH}/rtorrent.rc /root/.rtorrent.rc

    cp ${DIRPATH}/riso-EFI.cfg /usr/riso/riso-EFI.cfg

    cp ${DIRPATH}/riso-EFI.version /usr/riso/riso-EFI.version

    cp ${DIRPATH}/grub.png /grub.png

    dialog --sleep 5 --infobox "Os scritps foram instalados com sucesso." 10 50
    

    dialog --sleep 5 --infobox "Configurando o sistema de boot e atualizando." 10 50
    

    sed /'GRUB_DISTRIBUTOR='/d -i /etc/default/grub

    echo 'GRUB_DISTRIBUTOR="RISO UEFI '${VERSION}'"' >> /etc/default/grub

    sed /'GRUB_TIMEOUT='/d -i /etc/default/grub

    echo 'GRUB_TIMEOUT=-1' >> /etc/default/grub

    sed /'GRUB_BACKGROUND='/d -i /etc/default/grub

    echo 'GRUB_BACKGROUND="/grub.png"' >> /etc/default/grub

    rm -f /etc/grub.d/20_memtest86+

    if [ -e /etc/grub.d/10_linux ]; then
            
    mv /etc/grub.d/10_linux /etc/grub.d/50_linux

    fi

    update-grub

    dialog --sleep 5 --infobox "O sistema de boot foi configurando e atualizando com sucesso." 10 50

    dialog --sleep 5 --infobox "Configurando os serviços do sistema RISO UEFI ${VERSION}." 10 50
    
    echo '#!/bin/bash' > /etc/init.d/RISOServiceRemoval

    echo 'rm /etc/avahi/services/*' >> /etc/init.d/RISOServiceRemoval

    echo 'exit 0' >> /etc/init.d/RISOServiceRemoval

    chmod 755 /etc/init.d/RISOServiceRemoval

    update-rc.d RISOServiceRemoval defaults 2> /dev/null

    sed s/'use-ipv6=yes'/'use-ipv6=no'/g -i /etc/avahi/avahi-daemon.conf

    dialog --sleep 5 --infobox "Os serviços do sistema RISO UEFI ${VERSION} foram configurados com sucesso." 10 50
    
    dialog --sleep 5 --infobox "O sistema RISO UEFI ${VERSION} foi instalado com sucesso." 10 50    
    
    
    reboot
}

instalar_scripts(){

    
    dialog --sleep 5 --infobox "Instalando os scritps." 10 50 

    cp ${DIRPATH}/riso /usr/riso/riso

    echo '#!/bin/bash' > /usr/bin/riso

    echo '/usr/riso/riso $@' >> /usr/bin/riso

    chmod +x /usr/riso/riso

    chmod +x /usr/bin/riso

    cp ${DIRPATH}/risos /usr/riso/risos

    echo '#!/bin/bash' > /usr/bin/risos

    echo '/usr/riso/risos $@' >> /usr/bin/risos

    chmod +x /usr/riso/risos

    chmod +x /usr/bin/risos

    echo '#!/bin/bash' > /usr/riso/quitRTorrent.sh

    echo 'pkill rtorrent' >> /usr/riso/quitRTorrent.sh

    chmod +x /usr/riso/quitRTorrent.sh

    cp ${DIRPATH}/rtorrent.rc /root/.rtorrent.rc

    cp ${DIRPATH}/riso-EFI.cfg /usr/riso/riso-EFI.cfg

    cp ${DIRPATH}/riso-EFI.version /usr/riso/riso-EFI.version

    cp ${DIRPATH}/grub.png /grub.png
 
    dialog --sleep 5  --infobox "Os scritps foram instalados com sucesso." 10 50
    
    
}

menu() {

    while : ; do

    OPCAO=$(dialog --stdout --clear\
    --ok-label 'Confirmar'\
    --cancel-label 'Sair'\
    --title "RISO UEFI ${VERSION}"\
    --menu 'Selecione uma opção:'\
    0 60 0\
    1 'Atualizar o sistema operacional do RISO'\
    2 'Configurar o boot'\
    3 'Configurar os serviços'\
    4 'Criar a árvore de diretórios'\
    5 'Instalar as dependências dos pacotes'\
    6 'Instalar o RISO'\
    7 'Instalar os scripts')

    [ $? -ne 0 ] && break

    case ${OPCAO} in

    1) atualizar_sistema_operacional_riso;;

    2) configurar_boot;;

    3) configurar_servicos;;

    4) criar_arvore_diretorios;;

    5) instalar_dependencias_pacotes;;

    6) instalar_riso;;

    7) instalar_scripts;;
   
    esac

    done

}

#Verifica se usuário é o root antes de instalar e caso não seja o root termina a execução.

    if [ $(id -u) -ne "0" ]; then

    dialog --sleep 5  --infobox " Este script deve ser executado pelo usuário root. Execute-o novamente." 10 50

    exit 1

    else

    menu

    fi