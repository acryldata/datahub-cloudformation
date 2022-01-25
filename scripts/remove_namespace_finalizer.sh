et -x
set -eou pipefail
namespace=$1
if [ -z "$namespace" ]
then
  echo "This script requires a namespace argument input. None found. Exiting."
  exit 1
fi
export KUBECONFIG=/home/ec2-user/.kube/config
kubectl get namespace $namespace -o json | jq '.spec = {"finalizers":[]}' > rm_ns_finalizer.json
kubectl proxy &
sleep 5
curl -H "Content-Type: application/json" -X PUT --data-binary @rm_ns_finalizer.json http://localhost:8001/api/v1/namespaces/$namespace/finalize
pkill -9 -f "kubectl proxy"
rm rm_ns_finalizer.json
[ec2-user@ip-10-20-6-148 ~]$
