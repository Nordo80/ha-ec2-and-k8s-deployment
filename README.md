
# 🚀 ha-ec2-and-k8s-deployment

![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?logo=amazonaws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Orchestration-EKS-326CE5?logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker&logoColor=white)
![BusyBox](https://img.shields.io/badge/Runtime-BusyBox-1E5C07?logo=linux&logoColor=white)
![Nginx](https://img.shields.io/badge/Web-Nginx-009639?logo=nginx&logoColor=white)

---

## 🧭 Introduction

**ha-ec2-and-k8s-deployment** is a production-like AWS infrastructure project demonstrating how to deploy:

1) A highly available EC2 workload with Auto Scaling Group and encrypted EBS volumes.
2) A Kubernetes workload in EKS running a 2‑container pod and exposing a Hello World page only to a specific client IP.

The infrastructure is automated fully with **Terraform**, Kubernetes configuration uses **Kustomize**, and access security is maintained through strict IP allowlisting.

---

## 🧱 Tech Stack

| Layer                 | Technology    | Purpose                                          |
|----------------------|---------------|--------------------------------------------------|
| Cloud                | AWS           | Infrastructure hosting                           |
| IaC                  | Terraform     | Automated provisioning of EC2, EBS & EKS         |
| Orchestration        | EKS (K8s)     | Hosting application workloads                    |
| Manifests            | Kustomize     | Declarative Kubernetes manifests                 |
| Container Runtime    | Docker        | App containerization                             |
| Web App              | Nginx/BusyBox | Demo containers + logs                           |

---

## 🗂 Repository Structure

```
.
├── applications
│   ├── ha-ec2
│   │   └── environment
│   │       └── development
│   │           ├── ha-ec2.tf
│   │           └── provider.tf
│   └── my-k8s
│       ├── environment
│       │   └── development
│       │       ├── my-app.tf
│       │       └── provider.tf
│       └── kustomize
│           ├── kustomization.yml
│           └── resources
│               ├── deployment.yaml
│               └── service.yaml
└── terraform_modules
    ├── ha-ec2
    │   ├── asg.tf
    │   ├── iam.tf
    │   ├── launch-template.tf
    │   ├── outputs.tf
    │   ├── sg.tf
    │   ├── variables.tf
    │   └── versions.tf
    └── my-k8s
        ├── data.tf
        ├── iam.tf
        ├── locals.tf
        ├── main.tf
        ├── node-template.tf
        ├── outputs.tf
        ├── variables.tf
        └── versions.tf
```

---

## 🏗 Architecture Overview

This project deploys a HA EC2 setup (ASG with min 2 instances), each with 2 EBS volumes attached.
Kubernetes workloads are deployed to AWS EKS cluster where a 2 container pod runs:

- busybox — prints date every 1 minute
- nginx — returns a Hello World page

Exposure and SSH access is strictly limited to **IP: 88.196.208.91**.

---

## 🚀 Deployment Process

### PART 1 — HA EC2

Manual preparation:

- Created KMS key
- Created ssh keypair `my-app-kms-key`

Terraform actions:

```bash
cd applications/ha-ec2/environment/development
terraform init
terraform plan
terraform apply
```

SSH (from allowed IP only):

```bash
ssh -i my-app-kms-key.pem ec2-user@<ec2-ip>
```

### PART 2 — EKS Deployment

```bash
aws eks update-kubeconfig --region eu-west-1 --name my-k8s-deployment
kubectl create namespace my-app-deployment
kubectl apply -k ./applications/my-k8s/kustomize/
```

Check the logs of busybox and confirm that the date is printed every minute:

```bash
kubectl logs <pod> -n my-app-deployment -c busybox
```

Navigate to the Load Balancer endpoint of the EKS Service and verify that the Hello World page is displayed.

---

## 🖼 Screenshots

### HA EC2
#### EBS configurations
<img width="1627" height="618" alt="ebs" src="https://github.com/user-attachments/assets/60ed970f-2665-4324-aa3d-18df231e42a8" />

#### SG configurations
<img width="1621" height="653" alt="sg" src="https://github.com/user-attachments/assets/ee1ac69f-f7d3-454f-98e6-90353f58aec7" />

#### EC2 scaling
<img width="1670" height="194" alt="ec2" src="https://github.com/user-attachments/assets/3a629671-940a-4de1-aa48-835613ed4322" />

#### Invalid IP access test to EC2
<img width="1156" height="69" alt="incorrect_ip_ssh" src="https://github.com/user-attachments/assets/bf58e80d-3e21-44c2-95a9-6964c657e30b" />

#### Valid IP access test to EC2
<img width="1156" height="111" alt="correct_ip_ssh" src="https://github.com/user-attachments/assets/11f67012-ecf9-42b7-bf43-2594a5f834a2" />
<img width="791" height="263" alt="correct_ip_ssh2" src="https://github.com/user-attachments/assets/89ccba55-0bc6-4a2e-b070-ae03fa314bf8" />


### EKS Deployment
#### Busybox logs
<img width="1573" height="112" alt="busybox" src="https://github.com/user-attachments/assets/11fd1501-9076-41de-b711-4e3d125ef944" />

#### Invalid IP access test to website
<img width="1382" height="812" alt="wrong_ip" src="https://github.com/user-attachments/assets/c317b931-6071-4c81-a475-fe0cad89aa14" />

#### Valid IP access test to website
<img width="933" height="160" alt="correct_ip" src="https://github.com/user-attachments/assets/b551cb10-98ce-4661-9d68-40d4666a9ee7" />


---

## 🧩 Future Improvements

- Add application logging
- Add GitHub Actions CI/CD pipeline
- Implement alerting and dashboards
- Add terraform state file into S3 bucket

---


## 🧑‍💻 Author

**Made with ❤️ by [Nordo80](https://github.com/Nordo80)**
