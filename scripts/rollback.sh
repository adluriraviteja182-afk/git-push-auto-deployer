#!/bin/bash
set -e

NAMESPACE="${K8S_NAMESPACE:-production}"
DEPLOYMENT="git-auto-deployer"

echo "Rolling back $DEPLOYMENT in namespace $NAMESPACE..."

kubectl rollout undo deployment/$DEPLOYMENT -n $NAMESPACE

echo "Waiting for rollback to complete..."
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE --timeout=60s

CURRENT_IMAGE=$(kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o jsonpath="{.spec.template.spec.containers[0].image}")

echo "Rollback complete. Now running: $CURRENT_IMAGE"