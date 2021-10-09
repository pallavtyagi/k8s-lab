eksctl create nodegroup \
  --cluster k8s-lab-cluster \
  --region ap-south-1 \
  --name ng-2 \
  --node-type t3.large \
  --nodes 1 \
  --nodes-min 1 \
  --nodes-max 2 \
  --ssh-access 
