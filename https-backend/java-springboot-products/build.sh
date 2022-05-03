#!/bin/bash
IMAGE_NAME=renukafernando/products-https
VERSION=v1.0.2

mvn clean package;
mkdir -p target/dependency && (cd target/dependency || exit; jar -xf ../*.jar)
docker build -t $IMAGE_NAME:$VERSION .