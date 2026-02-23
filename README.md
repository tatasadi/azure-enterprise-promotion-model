# Azure Enterprise Promotion Model

## ⚠️ LEGACY BRANCH - ANTI-PATTERNS DEMONSTRATION

> **WARNING:** This is the `legacy` branch containing **intentional anti-patterns** and security issues. This code demonstrates common mistakes found in real-world implementations.
>
> **DO NOT USE THIS CODE IN PRODUCTION!**

---

## 🎯 Purpose

This branch demonstrates a **legacy CI/CD implementation** with realistic but flawed practices commonly seen in enterprise environments before DevOps maturity.

### What This Demonstrates:
- ❌ Hardcoded secrets and connection strings
- ❌ Monolithic pipeline YAML
- ❌ No environment separation
- ❌ No Infrastructure as Code (manual Azure resources)
- ❌ Direct production deployments without gates
- ❌ No artifact promotion strategy
- ❌ Security vulnerabilities

---

## 📁 Project Structure

```
azure-enterprise-promotion-model/
├── src/
│   └── InventoryApi/              # .NET 10 Web API with hardcoded values
│       ├── Program.cs             # API with anti-patterns
│       ├── appsettings.json       # Hardcoded secrets!
│       └── InventoryApi.csproj
├── azure-pipelines-legacy.yml     # Monolithic, flawed pipeline
├── docs/
│   └── legacy-issues.md           # Detailed documentation of all issues
└── README.md                      # This file
```

---

## 🔴 Major Issues in This Branch

### Security Issues:
1. **Hardcoded Secrets** - Database passwords in `appsettings.json`
2. **Pipeline Variables** - Secrets stored as pipeline variables
3. **Information Disclosure** - API endpoints expose internal configuration

### Pipeline Issues:
4. **Monolithic YAML** - Single massive pipeline file
5. **No Environment Separation** - Only production environment
6. **No Approval Gates** - Automatic deployment to production
7. **No Artifact Promotion** - Rebuilds for each deployment
8. **No Infrastructure as Code** - Manual resource creation

### Code Quality Issues:
9. **No Error Handling** - Endpoints throw unhandled exceptions
10. **No Environment Awareness** - Hardcoded "Production" everywhere
11. **No Testing** - No unit, integration, or smoke tests
12. **No Rollback Strategy** - Can't recover from bad deployments

**See [docs/legacy-issues.md](docs/legacy-issues.md) for detailed analysis.**

---

## 🚀 Running the Legacy Application

### Prerequisites:
- .NET 10 SDK
- Azure subscription (for pipeline)
- Azure DevOps account

### Local Development:
```bash
# Navigate to the API project
cd src/InventoryApi

# Restore dependencies
dotnet restore

# Run the application
dotnet run
```

### API Endpoints:
- `GET /health` - Health check (exposes internal config)
- `GET /api/version` - Version information
- `GET /api/inventory` - Get all inventory items
- `GET /api/inventory/{id}` - Get specific item
- `POST /api/inventory` - Create new item
- `GET /api/external-data` - External API call (exposes secrets!)

---

## 📋 Pipeline Configuration

The legacy pipeline (`azure-pipelines-legacy.yml`) is intentionally flawed:

**What it does:**
1. Builds the .NET application
2. Deploys directly to production App Service
3. Passes secrets as app settings

**What's wrong:**
- No separate environments
- No approval process
- Secrets in pipeline variables
- No Terraform (assumes manual resource setup)
- No artifact publishing
- No tests

---

## 🎓 Learning Points

This branch demonstrates what **NOT** to do. Each anti-pattern shown here is:
- Based on real-world issues
- Common in legacy systems
- A security or operational risk
- Addressable with modern DevOps practices

---

## ✅ The Solution

See the **`main` branch** for the enterprise-grade refactored implementation that addresses all these issues with:

- ✅ Azure Key Vault for secrets
- ✅ Managed Identity authentication
- ✅ Modular Terraform infrastructure
- ✅ Multi-environment setup (dev/test/prod)
- ✅ Approval gates between environments
- ✅ Artifact promotion (build once, deploy many)
- ✅ Pipeline templates (DRY principle)
- ✅ Proper state management
- ✅ Rollback capability
- ✅ RBAC and least privilege

---

## 📚 Documentation

- [Legacy Issues Analysis](docs/legacy-issues.md) - Detailed breakdown of all anti-patterns
- Compare with `main` branch - See the transformation

---

## 🔗 Reference Materials

- [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/)
- [Azure DevOps Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Managed Identities](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/)

---

## ⚖️ License

This is a demonstration project for educational purposes.

---

## 👤 Author

**Ehsan**
- **Purpose:** Portfolio/CV project demonstrating Azure DevOps transformation
- **Target Role:** Azure Platform Engineer / DevOps Engineer
- **LinkedIn:** [Post series planned on legacy → enterprise transformation]

---

**Branch:** `legacy`
**Last Updated:** 2026-02-23
**Status:** ⚠️ Demonstration of Anti-Patterns - DO NOT USE IN PRODUCTION
