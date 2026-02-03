1. Make sure ssh key is created
2. create the virtual machines with vagrant
3. Prepare kubespray deployment


Editer les fichier all.yml, k8s-cluster.yml, addons.yml 

python3 -m venv .venv
source .venv/bin/activate # activation de l'environnement virtuel
python3 -m pip install --upgrade pip
python3 -m pip --version
python3 -m pip install -r requirements.txt 


# OPTIONAL
ansible all -i inventory/cluster/hosts.ini --become --become-user=root -m shell -a "sudo systemctl stop firewalld && sudo systemctl disable firewalld" -vv
ansible all -i inventory/cluster/hosts.ini --become --become-user=root -m shell -a "echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf" -vv
ansible all -i inventory/cluster/hosts.ini --become --become-user=root -m shell -a "sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab && sudo swapoff -a" -vv

# INSTALL
ansible-playbook -i inventory/cluster/hosts.ini --become --user=root --become-user=root cluster.yml -vv --private-key=~/.ssh/id_ed25519.pub

#deactivate the virtual environment
source .venv/bin/deactivate


ansible-playbook -i inventory/cluster/hosts.ini --become --user=root --become-user=root -b upgrade-cluster.yml -vv --private-key=~/.ssh/id_ed25519.pub -e kube_version=v1.33.5 

# Remove node 
ansible-playbook -i inventory/cluster/hosts.ini  remove-node.yml -b --become-user=root -e "node=master-3" -vv --private-key=~/.ssh/id_ed25519.pub


# TROUBLESHOOTING

Error: Kubespray gives fatal "module (kube) is missing interpreter line" error

This is caused by the kube.py located in the library folder.

To solve it:

cd ./library
rm -f kube.py
ln -s ../plugins/modules/kube.py .


-e download_cache_dir="/tmp/kubespray_cache"