```
aws eks --region us-east-1 update-kubeconfig --name rennietchs-eks-demo-cluster
```
```
aws sts get-caller-identity
```
kubectl -n kube-system get configmap aws-auth -o yaml
