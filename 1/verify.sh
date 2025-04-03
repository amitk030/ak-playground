#!/bin/bash

verify_pod() {
  pod_status=$(kubectl get pod nginx-pod -o jsonpath='{.status.phase}' 2>/dev/null)

  if [[ "$pod_status" == "Running" ]]; then
    echo "Pod 'nginx-pod' is running."
    container_image=$(kubectl get pod nginx-pod -o jsonpath='{.spec.containers[0].image}')
    if [[ "$container_image" == "nginx" ]]; then
      echo "The container in 'nginx-pod' is using the 'nginx' image."
      exit 0
    else
      echo "The container in 'nginx-pod' is not using the 'nginx' image."
      exit 1
    fi
  else
    echo "Pod 'nginx-pod' is not running or does not exist."
    exit 1
  fi
}

verify_pod