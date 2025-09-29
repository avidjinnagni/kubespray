#!/bin/bash

# Récupération des fichiers depuis le serveur master-1 et stockage dans le répertoire courant
VAGRANT_FIRST_MASTER="master-1" # Premier master initialisé
VAGRANT_MASTER="master-2 master-3"
if [ -z "$VAGRANT_FIRST_MASTER" ]
then
    echo "\$VAGRANT_FIRST_MASTER n'est pas définie"
else
    echo "\$VAGRANT_FIRST_MASTER est définie"
    echo "Récupération des fichiers"
    vagrant scp $VAGRANT_FIRST_MASTER:/etc/kubernetes/pki/ca.crt pki-ca.crt
    vagrant scp $VAGRANT_FIRST_MASTER:/etc/kubernetes/pki/ca.key pki-ca.key
    vagrant scp $VAGRANT_FIRST_MASTER:/etc/kubernetes/pki/sa.key .
    vagrant scp $VAGRANT_FIRST_MASTER:/etc/kubernetes/pki/sa.pub .
    vagrant scp $VAGRANT_FIRST_MASTER:/etc/kubernetes/pki/front-proxy-ca.crt .
    vagrant scp $VAGRANT_FIRST_MASTER:/etc/kubernetes/pki/front-proxy-ca.key .
    vagrant scp $VAGRANT_FIRST_MASTER:/etc/kubernetes/pki/etcd/ca.crt .
    vagrant scp $VAGRANT_FIRST_MASTER:/etc/kubernetes/pki/etcd/ca.key .
    vagrant scp $VAGRANT_FIRST_MASTER:/etc/kubernetes/admin.conf .
    if [ -z "$VAGRANT_MASTER" ]   
    then
        echo "\$VAGRANT_MASTER n'est pas définie"
    else
        for host in $VAGRANT_MASTER; do
            echo "Copie des fichiers sur ${host}"
            vagrant scp pki-ca.crt $host:/home/vagrant/
            vagrant scp pki-ca.key $host:/home/vagrant/
            vagrant scp sa.key $host:/home/vagrant/
            vagrant scp sa.pub $host:/home/vagrant/
            vagrant scp front-proxy-ca.crt $host:/home/vagrant/
            vagrant scp front-proxy-ca.key $host:/home/vagrant/
            vagrant scp ca.crt $host:/home/vagrant/
            vagrant scp ca.key $host:/home/vagrant/
            vagrant scp admin.conf $host:/home/vagrant/
            echo "Création du répertoire /etc/kubernetes/"
            vagrant ssh $host -c "sudo mkdir -p /etc/kubernetes/pki/etcd"
            echo "Copie des fichiers dans le repertoire kubernetes"
            vagrant ssh $host -c "sudo mv /home/vagrant/pki-ca.crt /etc/kubernetes/pki/ca.crt"
            vagrant ssh $host -c "sudo mv /home/vagrant/pki-ca.key /etc/kubernetes/pki/ca.key"
            vagrant ssh $host -c "sudo mv /home/vagrant/sa.pub /etc/kubernetes/pki/"
            vagrant ssh $host -c "sudo mv /home/vagrant/sa.key /etc/kubernetes/pki/"
            vagrant ssh $host -c "sudo mv /home/vagrant/front-proxy-ca.crt /etc/kubernetes/pki/"
            vagrant ssh $host -c "sudo mv /home/vagrant/front-proxy-ca.key /etc/kubernetes/pki/"
            vagrant ssh $host -c "sudo mv /home/vagrant/ca.crt /etc/kubernetes/pki/etcd/ca.crt"
            vagrant ssh $host -c "sudo mv /home/vagrant/ca.key /etc/kubernetes/pki/etcd/ca.key"
            vagrant ssh $host -c "sudo mv /home/vagrant/admin.conf /etc/kubernetes/admin.conf"
            echo "Fin de la copie sur ${host}"
        done
    fi
fi    
