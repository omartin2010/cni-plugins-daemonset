sudo snap install microk8s --classic --channel=1.32
sudo microk8s enable community
sudo microk8s enable multus

# Required on microk8s, maybe also on other distros of the kubelet
sudo touch /var/snap/microk8s/current/var/lock/no-cert-reissue
alias k='microk8s kubectl'
alias kubectl='microk8s kubectl'
sudo usermod -a -G microk8s $USER
newgrp microk8s

# Install a few utilities to test
sudo apt update && sudo apt install iproute2 iputils-ping openssh-client -y

kubectl apply -f https://raw.githubusercontent.com/omartin2010/cni-plugins-daemonset/refs/heads/main/oli-daemon-set.yaml

# Deploy NAD
kubectl apply -f https://raw.githubusercontent.com/omartin2010/cni-plugins-daemonset/refs/heads/main/nad.yaml
kubectl apply -f https://raw.githubusercontent.com/omartin2010/cni-plugins-daemonset/refs/heads/main/pod.yaml

# Shell in pod
kubectl exec -it ubuntu-oli -- /bin/bash
# install net tools in pod
apt update && apt install iproute2 iputils-ping openssh-client -y
ip --brief address # Verify that IP address is there for rdma-2-in

