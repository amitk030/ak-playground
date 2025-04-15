#!/bin/bash

deployment_name="nginx-deployment"
expected_replicas=3
expected_image="nginx:latest"
expected_label="app=nginx"

kubectl get deployment "$deployment_name" &> /dev/null
if [ $? -ne 0 ]; then
  echo "Deployment '$deployment_name' does not exist."
  exit 1
fi

replicas=$(kubectl get deployment "$deployment_name" -o jsonpath='{.spec.replicas}')
if [ "$replicas" -ne "$expected_replicas" ]; then
  echo "Deployment '$deployment_name' does not have $expected_replicas replicas. Found: $replicas"
  exit 1
fi

image=$(kubectl get deployment "$deployment_name" -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$image" != "$expected_image" ]; then
  echo "Deployment '$deployment_name' is not using the expected image '$expected_image'. Found: $image"
  exit 1
fi

label=$(kubectl get deployment "$deployment_name" -o jsonpath="{.spec.template.metadata.labels.app}")
if [ "$label" != "nginx" ]; then
  echo "Deployment '$deployment_name' does not have the expected label '$expected_label'. Found: app=$label"
  exit 1
fi

echo "Deployment '$deployment_name' meets all the specified conditions."