# CNI plugins daemonset

### Building the CNI plugins image
The [docker-build.sh](./docker-build.sh) creates a docker image that was pushed on `omgoog/oli-cni-dhcp-daemon:0.1` with a patched version of the container plugins repo (see [commit/diff](https://github.com/containernetworking/plugins/commit/77133955f30384ab54d8a6cd4fb965ff9c72e77f) to the [container networking plugins repo](https://github.com/containernetworking/plugins)). The forked [repo is here](https://github.com/omartin2010/plugins): `https://github.com/omartin2010/plugins`.

### Running the tests
The commands in [microk8s-cni-repro.sh](./microk8s-cni-repro.sh) reproduce the steps needed to pull the rdma nics in the pod with a DHCP allocated IP address.

It is also possible to have an IP address statically assigned - but requires careful management of IP addresses assigned by the platform to the RDMA NICs. If that were the case, the [nad.yaml](./nad.yaml) file in this repo would look like the file below. __You will need to replace the IPs below for the right IP and CIDR for the subnet__. 
```
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: rdma-2-static-via
  namespace: default
spec:
  config: |
    {
      "cniVersion": "0.3.1",
      "name": "static-route-network",
      "type": "host-device",
      "pciBusID": "0000:98:00.0",  <-- PCI bus ID for the RoCE NIC - see below for details
      "ipam": {
        "type": "static",
        "addresses": [
          {
            "address": "192.168.144.60/32"  <-- VPC assigned IP for RoCE NIC
          }
        ],
        "routes": [
          {
            "dst": "192.168.144.1/32",      <-- VPC assigned IP for gateway on subnet
            "gw": "0.0.0.0"                 <-- needs to be 0.0.0.0 to use device
          },
          {
            "dst": "192.168.144.0/21",      <-- VPC subnet CIDR for RoCE VPC Subnet
            "gw": "0.0.0.0"                 <-- needs to be 0.0.0.0 to use device
          }
        ]
      }
    }
```
### PCI Bus ID for the RoCE NICs
You can obtain pciBusID values for Mellanox NICs on the virtual machine with the command `lspci | grep -i mellanox`".
You will get an output similar to:
```
91:00.0 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
92:00.0 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
98:00.0 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
99:00.0 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
c6:00.0 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
c7:00.0 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
cd:00.0 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
ce:00.0 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
```
From there, if you know which specific NIC you want to use, you can get the IP address of the NIC with the following command (__prepending__ `0000` to the PCI ID above ):
``` 
PCI_ID=0000:91:00.0       # (one of the IDs above - prepended with 0000)
IP_ADDR=$(ip -4 addr show "$(ls /sys/bus/pci/devices/${PCI_ID}/net)" | \
  grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo $IP_ADDR
192.168.135.193    # for example
```



