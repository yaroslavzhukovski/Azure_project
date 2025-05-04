# Medilync Azure Infrastructure Project

This is a **learning project** created to demonstrate my practical knowledge of deploying secure and structured cloud infrastructure in Microsoft Azure using **Terraform**.

## Project Overview

The goal of this project is to build a **secure, production-ready Azure infrastructure** for a fictional healthcare company called **Medilync**. It is designed based on real-world best practices for **network segmentation, access control, monitoring, and compliance**.

The infrastructure includes:

- **Three Resource Groups**:
  - `Medilync-ProdRG` – production workloads
  - `Medilync-DevRG` – development/test workloads
  - `Medilync-InfraRG` – shared services like monitoring and Key Vault

- **Virtual Network (VNet)**:
  - Address space: `10.0.0.0/16`
  - Subnets:
    - `dmz` – for internet-facing services
    - `internal` – for internal services like databases
    - `dev` – for development VMs
    - `AzureBastionSubnet` – for Bastion host access

- **Network Security Groups (NSGs)**:
  - `dmz-nsg` – allows HTTPS inbound
  - `internal-nsg` – allows traffic from the DMZ
  - `dev-nsg` – allows access from Bastion only

- **Virtual Machines**:
  - `web01` – in DMZ, public IP enabled
  - `db01` – in internal subnet, no public access
  - `dev01` – in dev subnet, no public access

- **Azure Bastion**:
  - Secure remote access to internal and dev VMs

- **Azure Key Vault**:
  - Controlled access using Azure AD `object_id`

- **Monitoring**:
  - Log Analytics workspace for VM diagnostics and metrics

- **IAM Role Assignments**:
  - Custom groups with different RBAC permissions

## Technologies Used

- **Terraform**
- **Microsoft Azure**
- **Azure Resource Manager**
- Modules for reusability and clarity


## Key Concepts Demonstrated

- Infrastructure as Code (IaC)
- Secure networking with NSGs and DMZ
- RBAC with Azure Active Directory
- Diagnostics with Log Analytics
- Modular Terraform design
- Environment separation (prod, dev, infra)

## Notes

- **This is a learning project.**
- Resources were created temporarily and destroyed after testing to minimize cost.
- Terraform state is stored locally.
- Designed and tested using Azure free tier and Visual Studio Code.




