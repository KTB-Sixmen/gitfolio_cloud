kubectl get nodes -o name | xargs -I {} kubectl label {} node-role.kubernetes.io/worker=""
kubectl label nodes ip-10-0-4-5.ap-northeast-2.compute.internal node-role.kubernetes.io/worker-

kubectl label nodes ip-10-0-4-5.ap-northeast-2.compute.internal node-role.kubernetes.io/master=""
kubectl label nodes ip-10-0-4-8.ap-northeast-2.compute.internal node-role.kubernetes.io/ingress=""
