\# NetApp Trident CSI Installation



\## Overview



NetApp Trident CSI was installed on the local K3s Kubernetes cluster to provide CSI integration capabilities.



Trident provides a CSI interface between Kubernetes and external storage backends, allowing Kubernetes workloads to request persistent storage through CSI-based resources.



In this local Kubernetes lab environment, Trident was installed and integrated with Kubernetes. Storage provisioning requires an additional configured storage backend such as NetApp ONTAP.



\## Installation Method



Trident was installed using Helm with the official NetApp Trident Helm chart.



\### Add Trident Helm repository



```bash

helm repo add netapp-trident https://netapp.github.io/trident-helm-chart

```



\### Update Helm repositories



```bash

helm repo update

```



\### Install Trident Operator



```bash

helm install trident netapp-trident/trident-operator \\

\--namespace trident

```



\## Verification



Verify Helm release:



```bash

helm list -n trident

```



Verify that Trident components are running:



```bash

kubectl get pods -n trident

```



Expected running components:



\* Trident Operator

\* Trident Controller

\* Trident Node DaemonSet running on all Kubernetes nodes



Example:



```text

trident-operator        Running

trident-controller      Running

trident-node-linux      Running

```



\## Kubernetes Integration



Trident installs Kubernetes Custom Resource Definitions (CRDs) required for CSI integration:



```bash

kubectl get crd | grep trident

```



Installed CRDs include:



\* Trident backends

\* Trident volumes

\* Trident storage classes

\* Trident snapshots



The CSI driver registration can be verified with:



```bash

kubectl get csidrivers

```



\## Environment



Cluster:



\* Kubernetes distribution: K3s

\* Deployment environment: VirtualBox local Kubernetes cluster



Nodes:



\* node-master

\* node-worker1

\* node-worker2



\## Storage Backend Limitation



The Trident CSI driver was successfully installed and registered with Kubernetes.



However, volume provisioning through Trident requires a configured storage backend, such as NetApp ONTAP.



No Trident backend was configured in this local lab environment, therefore:



\* Dynamic volume provisioning through Trident was not validated.

\* PersistentVolume creation through Trident was not performed.

\* RWX storage through Trident was not validated.



\## Persistent Storage Validation



Persistent storage functionality was validated using the built-in K3s local-path provisioner.



The working storage flow was:



```text

K3s local-path-provisioner

&#x20;         |

&#x20;        PVC

&#x20;         |

&#x20;        PV

&#x20;         |

&#x20;     VM Disk

```



Validation included:



\* PVC creation and binding

\* PV creation and binding

\* Pod volume mount

\* Data persistence after Pod deletion and recreation



Storage validation resources are documented separately under:



```text

k8s-storage/

```



