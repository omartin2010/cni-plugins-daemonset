# create the artifact repo
REPO_NAME=oli-cni-dhcp-daemon
LOCATION=us-central1
PROJECT_ID=northam-ce-mlai-tpu
IMAGE_NAME=oli-cni-dhcp-daemon
TAG=0.1

# build the container
docker build -t $IMAGE_NAME:$TAG .

# tag it
FULLY_QUALIFIED_REPO_NAME=omgoog/$IMAGE_NAME:$TAG
docker tag $IMAGE_NAME:$TAG $FULLY_QUALIFIED_REPO_NAME

# Authenticate to docker (docker login)
docker push $FULLY_QUALIFIED_REPO_NAME