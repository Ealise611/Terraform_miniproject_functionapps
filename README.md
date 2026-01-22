# Azure Function + Key Vault (RBAC) with Terraform

## 📌 Project Overview

This project demonstrates how to use **Terraform** to deploy a complete Azure solution that securely retrieves secrets from **Azure Key Vault** using an **Azure Function App**.

It is designed as a **beginner-friendly, real-world example** for people learning:

- Azure Infrastructure (AZ-104 level)
- Terraform (Infrastructure as Code)
- Azure Key Vault with RBAC
- Azure Functions (HTTP-triggered API)
- Managed Identity authentication (no secrets in code)

---

## 🧠 What This Project Does

Using Terraform, this project provisions the following Azure resources:

- ✅ Resource Group  
- ✅ Virtual Network (VNet)  
- ✅ Subnet  
- ✅ Azure Key Vault (RBAC enabled)  
- ✅ A Key Vault secret  
- ✅ Azure Function App (Windows, .NET isolated)  
- ✅ Storage Account (required by Function App)  
- ✅ Application Insights  

The Azure Function App exposes a simple HTTP API that:

- Receives an HTTP request
- Authenticates to Azure using **Managed Identity**
- Reads a secret from **Azure Key Vault**
- Returns the secret value in the HTTP response

No usernames, passwords, or connection strings are stored in code.

> **Note**  
> A Virtual Network and subnet are provisioned as part of the base architecture.  
> They are not currently used by the Function App but allow future enhancements such as VNet integration or private endpoints.

---

## 🏗️ Architecture (High Level)

Client (Browser / curl)
        |
        v
Azure Function App (HTTP Trigger)
        |
        |  Managed Identity (RBAC)
        v
Azure Key Vault
        |
        v
Secret Value Returned

🔐 Security Model

This project follows enterprise best practices:
-Key Vault uses RBAC, not access policies
-Azure Function uses System-Assigned Managed Identity

-Permissions are granted using Azure RBAC roles:
  -Key Vault Secrets User (read secrets)
  -Key Vault Administrator (optional, for setup)
-No secrets are hard-coded or stored in Terraform state

🧰 Technologies Used

-Terraform
-Azure Functions (Windows, .NET isolated)
-Azure Key Vault
-Azure RBAC
-Azure CLI
-.NET SDK
-Azure Functions Core Tools
-Project Structure

📁 Project Structure
```text
mini_azure_project_functionapps/
│
├── main.tf                # Resource Group, VNet, Subnet, provider config
├── key_vault.tf           # Key Vault (RBAC enabled) + Secret
├── function_app.tf        # Function App, Storage Account, App Settings
├── outputs.tf             # Outputs
├── .gitignore
│
└── GetValueAPI/
    └── GetValueAPI/
        ├── Function1.cs   # HTTP-triggered Azure Function
        ├── Program.cs
        ├── GetValueAPI.csproj
        ├── host.json
        └── local.settings.json

> Terraform commands are run from the repository root.  
> Azure Function commands (`dotnet`, `func`) are run from the folder containing `GetValueAPI.csproj`.

🚀 How to Deploy (High Level)
1️⃣ Deploy Infrastructure with Terraform
terraform init
terraform plan
terraform apply

2️⃣ Build the Function App
From the folder containing GetValueAPI.csproj:

dotnet restore
dotnet build

3️⃣ Publish the Function to Azure
func azure functionapp publish <FUNCTION_APP_NAME>

Replace <FUNCTION_APP_NAME> with the name created by Terraform (You will find the function name after terraform plan).

4️⃣ Call the API

Open a browser or use curl:

https://<function-app-name>.azurewebsites.net/api/function1?code=<function-key>
The response will be the value stored in Azure Key Vault.

🧪 Example Output
hello-from-terraform

🎯 Learning Outcomes

By completing this project, you will understand:
-How Terraform manages Azure infrastructure
-How Azure Functions authenticate using Managed Identity
-How RBAC works with Azure Key Vault
-The difference between infrastructure deployment and application deployment
-A real-world secure pattern used in enterprise environments

📚 Who This Project Is For

-AZ-104 candidates
-Beginners learning Terraform
-Cloud / Platform Engineers in early career
-Anyone wanting a secure Azure reference project

🧹 Cleanup

To remove all deployed resources:

terraform destroy

Note: Some Azure-managed resource groups (e.g. NetworkWatcherRG) are not deleted automatically.

