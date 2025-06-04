# CNI plugins daemonset

## Building the cni plugins image image
The [docker-build.sh](./docker-build.sh) creates the docker image that is pushsed on `omgoog/oli-cni-dhcp-daemon:0.1` with an edited version (see [this repo](https://github.com/omartin2010/plugins)) for the CNI base plugins.

## Running the test
The commands in [microk8s-cni-repro.sh](./microk8s-cni-repro.sh]) reproduce the steps needed to pull the rdma nics in the container.

