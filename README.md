# K8s Clusters

This repository is containing different Kubernetes cluster scenarios with ability to easy provision them using K3d or instantly install predefined set of application on current context in kubeconfig.

## Available clusters

| Name    | Components              |
| ------- | ----------------------- |
| knative | knative                 |
| firefly | robusta, argocd, pihole |
| voyager | openebs, prometheus, grafana, traefik, kube-ns-suspender |
| paps | node-problem-detector, heimdall, kube-ns-suspender, kubernetes-dashboard, argus, teleport, uptime-kube | 
| multi-cluster | traefik, rancher, autok3s, vcluster |
| teleport | traefik, teleport |
| stackgres | traefik, stackgres, prometheus | 