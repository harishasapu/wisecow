# Problem Statement 1: Wisecow Application Deployment

## Overview
Containerized and deployed the Wisecow application on Kubernetes with secure TLS communication and automated CI/CD pipeline.

## Architecture

```
GitHub → Actions → Docker Hub → ArgoCD → Kubernetes
   ↓         ↓         ↓          ↓         ↓
 Code    Build/Push  Registry  GitOps   Deploy
```


## Tasks Completed

### 1. Dockerization ✅
- Created Dockerfile
- Installed required packages: `fortune`, `cowsay`, `netcat-openbsd`

### 2. Kubernetes Deployment ✅
- **Deployment**: Created deployment manifest with 2 replicas
- **Service**: ClusterIP service
- **Ingress**: Configured ingress with TLS configuration (cowsay.homelabcraft.ovh)
- **Kustomization**: Added kustomization support for manifest management

- **Manifest-file-path**: `gitops/` directory containing Kubernetes manifests and kustomization files


![argocd-ui](/assets/argocd-UI-wisecow.png)

### 3. TLS Implementation ✅
- Installed **cert-manager** for automatic SSL certificate provisioning
- Created **ClusterIssuer** with Let's Encrypt ACME provider
- Configured **NGINX Ingress controller** for routing traffic inside the cluster
- Added `cert-manager.io/cluster-issuer` annotation for auto certificate generation
- Domain A record points to NGINX Ingress LoadBalancer IP
- **Result**: Secure TLS/HTTPS communication at `https://wisecow.homelabcraft.ovh`

- The `cluster-issuer.yaml` manifest for Let's Encrypt configuration is located in the cert-manager directory

![Wisecow HTTPS](/assets/tls-and-output-ingress.png)


### 4. CI/CD Pipeline ✅

#### CI (GitHub Actions)
- **Trigger**: On push/PR to main (excluding `gitops/` path)
- **Build**: Docker image with commit SHA tag
- **Push**: To Docker Hub registry

![CI](/assets/CI.png)

#### CD (ArgoCD Image Updater)
- **ArgoCD**: Installed with image updater
- **GitOps Repo**: Private repository for manifests
- **Auto-sync**: Monitors registry for new images
- **Write-back**: Updates manifests automatically

![image-updater-log](/assets/argocd-image-updater-log.png)


## Deployment Commands

```bash
# Prerequisites
kustomize build nginx-ingress --enable-helm | kubectl apply --server-side -f -
kustomize build cert-manager --enable-helm | kubectl apply --server-side -f -
kustomize build argocd --enable-helm | kubectl apply --server-side -f - (configure PAT token first)

# Application
kubectl apply -f argocd-application-wisecow.yaml
```

## Verification
- ✅ Application accessible via HTTPS
- ✅ Valid TLS certificate
- ✅ CI Pipeline triggering while push changes 
- ✅ Auto-deployment on code changes
- ✅ GitOps workflow functional