\# Headlamp Kubernetes Dashboard Installation



\## Overview



Headlamp was deployed on the local K3s Kubernetes cluster to provide a graphical interface for Kubernetes resource management.



Headlamp allows visual monitoring and management of Kubernetes resources, including:



\* Nodes

\* Pods

\* Deployments

\* Namespaces

\* Services

\* Persistent storage resources



\## Installation Method



Headlamp was installed using Helm.



\### Add Headlamp Helm repository



```bash

helm repo add headlamp https://headlamp-k8s.github.io/headlamp/

```



\### Update Helm repositories



```bash

helm repo update

```



\### Install Headlamp



```bash

helm install headlamp headlamp/headlamp \\

\--namespace headlamp \\

\--create-namespace

```



\## Verification



Verify that Headlamp pods are running:



```bash

kubectl get pods -n headlamp

```



Expected output:



```text

headlamp-xxxxx    Running

```



Verify the service:



```bash

kubectl get svc -n headlamp

```



\## Accessing Headlamp



Headlamp can be accessed through Kubernetes port forwarding:



```bash

kubectl port-forward -n headlamp svc/headlamp 4466:80

```



The dashboard is available locally at:



```text

http://localhost:4466

```



\## Kubernetes Integration



Headlamp connects to the Kubernetes API server using the cluster credentials and displays live Kubernetes resources.



The dashboard provides visibility into:



\* Cluster nodes and status

\* Running workloads

\* Pod health and logs

\* Deployments and replicas

\* PersistentVolumeClaims and PersistentVolumes



\## Environment



Cluster:



\* Kubernetes distribution: K3s

\* Deployment environment: VirtualBox local Kubernetes cluster



Nodes:



\* node-master

\* node-worker1

\* node-worker2



\## Conclusion



Headlamp was successfully deployed as a Kubernetes management interface.



It provides a visual layer for observing and managing cluster resources and complements the command-line Kubernetes administration workflow.



