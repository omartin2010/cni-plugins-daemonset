# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

# Deploy pod with DHCP IP
kubectl apply -f https://raw.githubusercontent.com/omartin2010/cni-plugins-daemonset/refs/heads/main/pod.yaml

# Shell in pod
kubectl exec -it ubuntu-oli -- /bin/bash
# install net tools in pod
apt update && apt install iproute2 iputils-ping openssh-client -y
ip --brief address # Verify that IP address is there for rdma-2-in

