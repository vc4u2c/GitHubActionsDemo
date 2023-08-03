# GitHub Actions CI/CD Demo

[How To Deploy Your Application To Azure Using GitHub Actions | CI/CD Pipeline](https://www.youtube.com/watch?v=QP0pi7xe24s)

### Installation

### Create Solution

```
cd C:\Users\Vinod Chandran\Documents\Source\Repos\Azure
dotnet new sln -o GitHubActionsDemo
md src
cd src
dotnet new webapi -minimal -n GitHubActionsDemo.WebApi
cd..
cd tests
dotnet new xunit -n GitHubActionsDemo.WebApi.Tests
cd..
dotnet add tests/GitHubActionsDemo.WebApi.Tests reference src/GitHubActionsDemo.WebApi
dotnet sln GitHubActionsDemo.sln add src\GitHubActionsDemo.WebApi\GitHubActionsDemo.WebApi.csproj
dotnet sln GitHubActionsDemo.sln add tests\GitHubActionsDemo.WebApi.Tests\GitHubActionsDemo.WebApi.Tests.csproj

# Run on VS Studio GitHubActionsDemo.WebApi to and use tests.http to test that project
# To test the GitHubActionsDemo.WebApi.Tests project. Use dotnet run or use the VS Test Explorer
```

### Create Infra in Az

```
# Login
az login

# Change active subscription
az account set --subscription "sub-vc4u2c-demo"

# Create Resource Group
az group create --name rg-azurecacheforredisdemo-dev-eastus --location eastus

# Build and Run locally and Deploy to Azure from VS: AzureCacheForRedisDemo.WebApi

# Final Run
az deployment group create -g rg-azurecacheforredisdemo-dev-eastus -f deploy.bicep
# Hit Post endpoint in tests.http and see logs in Log Stream of Function App and API App Service
# Connect to Az instance using stunnel and publish a message and see in app service logs that it has been subscribed to
```

### Teardown

Delete resource group rg-azservicebusqueuedemo-dev-eastus

## Notes

- [How to test ASP.NET Core Minimal APIs](https://www.twilio.com/blog/test-aspnetcore-minimal-apis)
