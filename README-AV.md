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

# Upgrade version
ansible-playbook -i inventory/cluster/hosts.ini --become --user=root --become-user=root -b upgrade-cluster.yml -vv --private-key=~/.ssh/id_ed25519.pub -e kube_version=v1.33.5 

# Remove node 
ansible-playbook -i inventory/cluster/hosts.ini  remove-node.yml -b --become-user=root -e "node=master-3" -vv --private-key=~/.ssh/id_ed25519.pub

# Adding node
ansible-playbook -i inventory/cluster/hosts.ini --become --user=root --become-user=root -b scale.yml -vv --private-key=~/.ssh/id_ed25519.pub -e kube_version=v1.33.5 


# Sync Kubespray github fork
https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork

# TROUBLESHOOTING
## Error when installing kubectl version not available in checksums
We realize that sometime we have errors regarding downling or caching options. This is usually caused by a missing of checksum in roles/kubespray-defaults/vars/main/checksums
Ex. kubespray/roles/download/tasks/download_file.yml': line 16, column 5

