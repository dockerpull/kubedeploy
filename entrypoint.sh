#!/bin/bash

set -e

cluster=$1
commit=$GITHUB_SHA
branch=${GITHUB_REF##*/}
deployment="deployment/$branch.yaml"

if [ -z "$cluster" ]; then
  echo '[Error] $cluster is empty. Nothing to do.'
  exit 1
fi

if [ -z "$branch" ]; then
  echo '[Error] $branch is empty. Nothing to do.'
  exit 1
fi

if [ -z "$commit" ]; then
  echo '[Error] $commit is empty. Nothing to do.'
  exit 1
fi

if [ ! -f "$deployment" ]; then
  echo "[Error] Unexpected deployment for branch '$branch'."
  exit 1
fi

echo '[Debug] Authenticate in Kubernetes'
mkdir -p ~/.aws
wget -O ~/.aws/config http://secrets.local.shpil.dev/aws/config
wget -O ~/.aws/credentials http://secrets.local.shpil.dev/aws/credentials
aws eks --region us-east-2 update-kubeconfig --name $cluster

echo '[Debug] Deploy image'
kubectl apply -f $deployment
