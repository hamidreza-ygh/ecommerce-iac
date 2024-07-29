# E-commerce Microservices Project

This repository contains the infrastructure code for deploying a simple e-commerce project utilizing microservice architecture on a Kubernetes cluster. The project comprises three main microservices: UI, Product, and User Manager, each hosted in separate repositories with distinct technology stacks. The deployment infrastructure leverages Terraform, Exoscale Kubernetes Service (SKS), ArgoCD for continuous deployment, Traefik as the ingress controller, and Cloudflare API for DNS management.

## Microservices Overview

1. [**UI Microservice(Ecommerce-UI)**](https://github.com/hamidreza-ygh/ecommerce-ui)
   - Developed with Vue.js
   - Interacts with backend microservices via exposed APIs

2. [**Product Microservice(Ecommerce-Product)**](https://github.com/hamidreza-ygh/ecommerce-product)
   - Manages product catalog and inventory
   - Exposes RESTful APIs for CRUD operations

3. [**User Manager Microservice(Ecommerce-User-Manager)**](https://github.com/hamidreza-ygh/ecommerce-user-manager)
   - Handles user authentication and authorization
   - Provides secure endpoints for user-related operations

## Deployment Architecture

### Infrastructure as Code

- **Terraform**: Used to define and provision the entire infrastructure on Exoscale Kubernetes Service (SKS).
- **Exoscale Kubernetes Service (SKS)**: Managed Kubernetes service for hosting the microservices.

### Continuous Deployment

- **ArgoCD**: Manages the continuous deployment of each microservice from their respective repositories.

### Networking

- **Traefik**: Serves as the ingress controller, managing incoming traffic and routing it to the appropriate services.
- **Cloudflare API**: Automates DNS record management for seamless service discovery.

### Security

- **Traefik AuthForward Middleware**: Secures microservices by forwarding authentication requests to the User Manager microservice. This ensures that only authenticated requests are processed by the backend services.

## Microservice Communication

Since the UI microservice runs in the client browser, direct inter-service communication is not feasible. To facilitate secure interaction between the UI and backend microservices, the following approach is implemented:

1. **Exposing Microservices**: Product and User Manager microservices are exposed to the internet through Traefik.
2. **Authentication**: Traefik's authforward middleware forwards authentication requests to the User Manager microservice to verify user credentials before allowing access to other services.
