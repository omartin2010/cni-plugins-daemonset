# create the artifact repo
REPO_NAME=oli-cni-dhcp-daemon
LOCATION=us-central1
PROJECT_ID=northam-ce-mlai-tpu
IMAGE_NAME=oli-cni-dhcp-daemon
TAG=0.1

# build the container
docker build -t $IMAGE_NAME:$TAG .
gcloud artifacts repositories create $REPO_NAME \
    --repository-format=docker \
    --location=$LOCATION \
    --description="CNI Modified DHCP plugin for GCE"

gcloud artifacts repositories add-iam-policy-binding $REPO_NAME \
    --location=$LOCATION \
    --member=allUsers \
    --role=roles/artifactregistry.reader

# tag it
FULLY_QUALIFIED_REPO_NAME=$LOCATION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$TAG
docker tag $IMAGE_NAME:$TAG $FULLY_QUALIFIED_REPO_NAME

# Authenticate to gcloud artifacts
gcloud auth configure-docker $LOCATION-docker.pkg.dev
docker push $FULLY_QUALIFIED_REPO_NAME
