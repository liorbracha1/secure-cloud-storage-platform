\# Kubernetes Networking Troubleshooting



\## Issue: Flannel selected the wrong network interface



\### Environment



The Kubernetes cluster was deployed locally using VirtualBox with two network interfaces:



\* `enp0s3` - NAT interface (10.0.2.15)

\* `enp0s8` - Host-Only interface (192.168.56.x)



The Host-Only network is used for Kubernetes node communication.



Cluster nodes:



| Node         | IP             |

| ------------ | -------------- |

| node-master  | 192.168.56.101 |

| node-worker1 | 192.168.56.102 |

| node-worker2 | 192.168.56.103 |



\---



\## Symptoms



Trident CSI node pods were running but failed to register with the Trident controller.



Error message:



```text

Could not update Trident controller with node registration



context deadline exceeded

```



The Trident controller service was reachable, but communication through the Kubernetes overlay network was failing.



\---



\## Root Cause



K3s automatically selected the NAT interface (`enp0s3`) for Flannel networking.



Although Kubernetes nodes had the correct Internal-IP addresses, Flannel VXLAN traffic was using the wrong network interface.



This caused pod-to-pod communication issues between nodes and prevented Trident CSI components from registering successfully.



\---



\## Solution



Configured K3s to use the Host-Only interface (`enp0s8`) for Flannel networking.



\### Master node



Updated:



```text

/etc/systemd/system/k3s.service

```



Added:



```text

\--node-ip=192.168.56.101

\--flannel-iface=enp0s8

```



Applied:



```bash

sudo systemctl daemon-reload

sudo systemctl restart k3s

```



\---



\### Worker nodes



Updated:



```text

/etc/systemd/system/k3s-agent.service

```



Added:



```text

\--node-ip=<worker-ip>

\--flannel-iface=enp0s8

```



Applied:



```bash

sudo systemctl daemon-reload

sudo systemctl restart k3s-agent

```



\---



\## Validation



Verified cluster health:



```bash

kubectl get nodes -o wide

```



All nodes returned to:



```text

Ready

```



Verified Trident registration:



```bash

kubectl get tridentnode -A

```



Output:



```text

node-master

node-worker1

node-worker2

```



Verified CSI drivers:



```bash

kubectl get csinode

```



All cluster nodes were registered successfully.



\---



\## Conclusion



The issue was caused by incorrect network interface selection for the Kubernetes overlay network.



Explicitly configuring K3s Flannel to use the VirtualBox Host-Only interface restored node-to-node communication and allowed Trident CSI components to register successfully.



This networking fix was required before deploying storage components because CSI node registration depends on Kubernetes node-to-node communication.



