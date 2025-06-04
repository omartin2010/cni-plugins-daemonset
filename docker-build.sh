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

# create the artifact repo
REPO_NAME=oli-cni-dhcp-daemon
LOCATION=us-central1
PROJECT_ID=<PROJECT_ID>
IMAGE_NAME=oli-cni-dhcp-daemon
TAG=0.1

# build the container
docker build -t $IMAGE_NAME:$TAG .

# tag it
FULLY_QUALIFIED_REPO_NAME=omgoog/$IMAGE_NAME:$TAG
docker tag $IMAGE_NAME:$TAG $FULLY_QUALIFIED_REPO_NAME

# Authenticate to docker (docker login)
docker push $FULLY_QUALIFIED_REPO_NAME