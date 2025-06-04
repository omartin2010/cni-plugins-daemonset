# CNI plugins daemonset

## Building the cni plugins image image
The [docker-build.sh](./docker-build.sh) creates the docker image that is pushsed on `omgoog/oli-cni-dhcp-daemon:0.1` with an edited version (see [this repo](https://github.com/omartin2010/plugins)) for the CNI base plugins.

## Running the test
The commands in [microk8s-cni-repro.sh](./microk8s-cni-repro.sh]) reproduce the steps needed to pull the rdma nics in the pod with a DHCP allocated IP address.

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
      "pciBusID": "0000:98:00.0",
      "ipam": {
        "type": "static",
        "addresses": [
          {
            "address": "192.168.144.60/32"  <-- VPC assigned IP for RoCE NIC
          }
        ],
        "routes": [
          {
            "dst": "192.168.144.1/32",      <-- VPC assigned IP for RoCE NIC
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


