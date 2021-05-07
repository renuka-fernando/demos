#!/bin/bash

env GOOS=linux GOARCH=386 go build -o sample-backend main.go
docker build . -t cakebakery/sample-backend:v1