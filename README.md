# Secure Cloud Storage Platform

Secure Cloud Storage Platform is a DevOps portfolio project that aims to build a secure, cloud-native storage infrastructure using a local Kubernetes cluster with planned AWS cloud storage integration.

---

## Local Infrastructure Architecture

The local environment is virtualized using VirtualBox and running Ubuntu Server instances managed with automated static networking.

---

## Network Topology & Node Assignment

> Note: All IP addresses belong to a private VirtualBox Host-Only network and are not accessible from the public internet.

| Node Name    | Role                     | Host-Only IP (Static) | NAT IP (Internet) | OS                  |
|--------------|--------------------------|------------------------|-------------------|---------------------|
| node-master  | Kubernetes Control Plane | 192.168.56.101        | DHCP              | Ubuntu Server LTS   |
| node-worker1 | Kubernetes Worker Node   | 192.168.56.102        | DHCP              | Ubuntu Server LTS   |
| node-worker2 | Kubernetes Worker Node   | 192.168.56.103        | DHCP              | Ubuntu Server LTS   |


## Prerequisites Configuration

- Base Virtual Machines created and configured in VirtualBox  
- Dual-NIC network setup (NAT + Host-Only)  
- Static IPs assigned via Netplan  
- Passwordless SSH access configured from the host machine to all cluster components


## Kubernetes Storage Layer

The cluster includes Kubernetes storage capabilities:

- NetApp Trident CSI driver installation
- K3s local-path dynamic provisioning for local storage validation
- PersistentVolumeClaim and PersistentVolume lifecycle testing

## APP
Developed a containerized Flask REST API integrated with AWS S3 using boto3, implemented retry mechanisms for cloud resilience, and secured the Docker image using non-root execution and least privilege principles.