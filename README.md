# Azure Enterprise Promotion Model

## ✅ ENTERPRISE SOLUTION - MAIN BRANCH

> **This is the `main` branch** containing the **enterprise-grade refactored implementation**. This demonstrates modern DevOps best practices for Azure CI/CD.

---

## 🎯 Purpose

This project demonstrates transformation from legacy CI/CD practices to an enterprise-grade promotion model on Azure, showcasing:

- ✅ **Infrastructure as Code** with modular Terraform
- ✅ **Secret Management** via Azure Key Vault + Managed Identity
- ✅ **Multi-Environment Strategy** (dev → test → prod)
- ✅ **Artifact Promotion** (build once, deploy many)
- ✅ **Approval Gates** between environments
- ✅ **Modular Pipelines** using reusable templates
- ✅ **Security Best Practices** (RBAC, least privilege, no hardcoded secrets)

**Portfolio Goal:** Demonstrate Azure Platform Engineer / DevOps Engineer capabilities

---

## 📁 Project Structure

```
azure-enterprise-promotion-model/
├── src/
│   └── InventoryApi/                    # .NET 9 Web API
│       ├── Program.cs                   # Enterprise-grade with Key Vault integration
│       ├── appsettings.json             # No secrets! Config references only
│       └── InventoryApi.csproj          # Azure SDK packages
│
├── infrastructure/
│   ├── modules/                         # Reusable Terraform modules
│   │   ├── app-service/                 # App Service + Managed Identity
│   │   ├── key-vault/                   # Key Vault + RBAC
│   │   └── storage-account/             # State storage
│   │
│   ├── environments/                    # Environment-specific configs
│   │   ├── dev/                         # Development environment
│   │   ├── test/                        # Test environment
│   │   └── prod/                        # Production environment
│   │
│   └── bootstrap/                       # Terraform state setup
│
├── pipelines/
│   ├── azure-pipelines.yml              # Main orchestrator pipeline
│   └── templates/                       # Reusable pipeline templates
│       ├── build.yml                    # Build template
│       ├── terraform-plan.yml           # Infrastructure planning
│       ├── terraform-apply.yml          # Infrastructure deployment
│       └── deploy-app.yml               # Application deployment
│
├── docs/
│   ├── legacy-issues.md                 # Analysis of legacy anti-patterns
│   ├── architecture.md                  # Architecture decisions (TBD)
│   └── setup-guide.md                   # Setup instructions (TBD)
│
├── azure-pipelines-legacy.yml           # Legacy pipeline (for comparison)
└── README.md                            # This file
```

---

## 🏗️ Architecture Overview

### **Three-Environment Promotion Model**

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Build   │ --> │   Dev    │ --> │   Test   │ --> │   Prod   │
│  (Once)  │     │  (Auto)  │     │ (Approval)     │ (Approval)
└──────────┘     └──────────┘     └──────────┘     └──────────┘
                       │                │                │
                       ▼                ▼                ▼
                  ┌─────────┐     ┌─────────┐     ┌─────────┐
                  │App Svc  │     │App Svc  │     │App Svc  │
                  │Key Vault│     │Key Vault│     │Key Vault│
                  │Managed  │     │Managed  │     │Managed  │
                  │Identity │     │Identity │     │Identity │
                  └─────────┘     └─────────┘     └─────────┘
```

### **Key Components**

1. **App Service** - Linux Web App with system-assigned Managed Identity
2. **Key Vault** - Stores secrets (connection strings, API keys)
3. **Managed Identity** - App Service authenticates to Key Vault without credentials
4. **Terraform State** - Stored in Azure Storage with state locking
5. **Pipeline Templates** - Reusable, modular deployment logic

---

## 🚀 Getting Started

### **Prerequisites**

- Azure subscription
- Azure DevOps organization
- Terraform >= 1.0
- .NET 9 SDK
- Azure CLI

### **1. Local Development**

```bash
# Clone the repository
git clone <your-repo-url>
cd azure-enterprise-promotion-model

# Checkout main branch
git checkout main

# Navigate to the API project
cd src/InventoryApi

# Restore dependencies
dotnet restore

# Run locally (will work without Key Vault for dev)
dotnet run
```

### **2. Bootstrap Terraform State Storage**

```bash
# Navigate to bootstrap directory
cd infrastructure/bootstrap

# Login to Azure
az login

# Initialize and apply
terraform init
terraform plan
terraform apply

# Note the storage account name for pipeline configuration
```

### **3. Configure Azure DevOps**

1. **Create Service Connections:**
   - `Azure-ServiceConnection-Dev`
   - `Azure-ServiceConnection-Test`
   - `Azure-ServiceConnection-Prod`

2. **Create Variable Groups for Secrets:** ⚠️ **REQUIRED**
   - See [Variable Groups Setup Guide](docs/variable-groups-setup.md)
   - Create 3 variable groups:
     - `terraform-secrets-dev`
     - `terraform-secrets-test`
     - `terraform-secrets-prod`
   - Each contains `TF_VAR_KEY_VAULT_SECRETS` with secrets as JSON

3. **Create Environments with Approvals:**
   - `dev` (no approval)
   - `test` (1 approver)
   - `prod` (2 approvers)

4. **Create Pipeline:**
   - Use `azure-pipelines.yml`
   - Configure trigger for `main` branch

### **4. Deploy Infrastructure**

The pipeline will automatically:
1. Build the application (once)
2. Deploy Terraform infrastructure to dev
3. Deploy application to dev
4. Wait for approval → test
5. Deploy to test
6. Wait for approval → prod
7. Deploy to prod

---

## 🔐 Security Features

### **No Hardcoded Secrets**
- ❌ No connection strings in code
- ❌ No API keys in appsettings.json
- ❌ No secrets in pipeline YAML

### **Azure Key Vault Integration**
- ✅ All secrets stored in Key Vault
- ✅ Separate Key Vault per environment
- ✅ RBAC-based access control

### **Managed Identity**
- ✅ App Service uses system-assigned identity
- ✅ No credentials needed to access Key Vault
- ✅ Principle of least privilege

### **Terraform State Security**
- ✅ State stored in Azure Storage (encrypted)
- ✅ State locking enabled
- ✅ Separate state files per environment

---

## 📊 Enterprise Features

| Feature | Legacy | Enterprise (Main) |
|---------|--------|-------------------|
| **Secrets Management** | Hardcoded | Azure Key Vault |
| **Authentication** | Static credentials | Managed Identity |
| **Infrastructure** | Manual | Terraform (IaC) |
| **Environments** | 1 (prod only) | 3 (dev/test/prod) |
| **Deployment** | Rebuild per env | Build once, promote |
| **Approval Gates** | None | Test + Prod |
| **Pipeline Structure** | Monolithic | Modular templates |
| **State Management** | None | Azure Storage backend |
| **Rollback** | Not possible | Version tracking enabled |
| **Error Handling** | None | Comprehensive |
| **Logging** | Minimal | Structured logging |

---

## 🛠️ API Endpoints

All endpoints include proper error handling, validation, and logging:

- `GET /health` - Health check (no sensitive data exposed)
- `GET /health/ready` - Readiness probe
- `GET /api/version` - Version with environment awareness
- `GET /api/inventory` - Get all inventory items
- `GET /api/inventory/{id}` - Get specific item (with validation)
- `POST /api/inventory` - Create new item (with validation)
- `GET /api/external-data` - External API integration example
- `GET /api/config/status` - Configuration status (for debugging)

---

## 📈 What Was Fixed from Legacy

Compare the `legacy` branch to see the transformation:

### **Security Improvements**
1. Removed hardcoded secrets → Key Vault integration
2. Removed pipeline variable secrets → Key Vault
3. Removed information disclosure → Proper security practices

### **Pipeline Improvements**
4. Monolithic YAML → Modular templates
5. Single environment → Multi-environment (dev/test/prod)
6. No approvals → Approval gates
7. Rebuild per deploy → Artifact promotion
8. Manual resources → Terraform IaC

### **Code Quality Improvements**
9. No error handling → Comprehensive try-catch
10. No environment awareness → Environment-based configuration
11. No testing → Test stages ready (add your tests!)
12. No rollback → Version tracking + deployment slots

**See [docs/legacy-issues.md](docs/legacy-issues.md) for detailed analysis of all anti-patterns.**

---

## 🎓 Key Learnings

### **Infrastructure as Code**
- Modular Terraform design
- Environment separation
- State management best practices

### **Security**
- Managed Identity over service principals
- RBAC instead of access policies
- Secret rotation capabilities

### **CI/CD**
- Build once, deploy many times
- Environment promotion strategy
- Approval gates for change control

### **Azure Platform**
- App Service configuration
- Key Vault integration
- Service connections and environments

---

## 📚 Documentation

- [Legacy Issues Analysis](docs/legacy-issues.md) - What was wrong and why
- [Architecture Guide](docs/architecture.md) - Design decisions (TBD)
- [Setup Guide](docs/setup-guide.md) - Step-by-step deployment (TBD)
- [Migration Guide](docs/migration-guide.md) - Legacy to enterprise (TBD)

---

## 🔗 Reference Materials

- [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/)
- [Managed Identities](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure DevOps Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/)
- [Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/)

---

## 🎬 Demo Video

> Coming soon: Full walkthrough of the transformation

---

## ⚖️ License

This is a demonstration project for educational purposes.

---

## 👤 Author

**Ehsan**
- **Purpose:** Portfolio/CV project demonstrating Azure DevOps expertise
- **Target Role:** Azure Platform Engineer / DevOps Engineer
- **Skills Demonstrated:** CI/CD, Terraform, Azure, Security, DevOps Best Practices

---

## 🌟 Compare with Legacy

Want to see the "before" state? Check out the `legacy` branch:

```bash
git checkout legacy
```

**Branch:** `main`
**Last Updated:** 2026-02-23
**Status:** ✅ Production-Ready Enterprise Implementation
