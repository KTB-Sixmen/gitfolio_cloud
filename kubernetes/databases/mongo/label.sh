for ((i = 11; i < 14; ++i))
do
    kubectl label nodes ip-10-0-4-$i.ap-northeast-2.compute.internal node-role.kubernetes.io/worker=""
    kubectl label nodes ip-10-0-4-$i.ap-northeast-2.compute.internal node-role.kubernetes.io/db=""
done