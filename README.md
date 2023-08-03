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
```

### Run locally

```
# Run on VS Studio GitHubActionsDemo.WebApi to and use tests.http to test that project
# To test the GitHubActionsDemo.WebApi.Tests project. Use dotnet run or use the VS Test Explorer

# Code Coverage
dotnet test --collect:"XPlat Code Coverage"

# Install report generator tool once
dotnet tool install -g dotnet-reportgenerator-globaltool

# Generate report
reportgenerator `
-reports:".\tests\GitHubActionsDemo.WebApi.Tests\TestResults\2c39de27-c157-40d7-8b5a-9223fb48c8c6\coverage.cobertura.xml" `
-targetdir:".\tests\GitHubActionsDemo.WebApi.Tests\TestResults\2c39de27-c157-40d7-8b5a-9223fb48c8c6\coveragereport" `
-reporttypes:Html
```

### Create Infra in Az

```
# Check if we are logged in
az account show

# Login
az login

# Change active subscription
az account set --subscription "sub-vc4u2c-demo"

# Create Resource Group
az group create --name rg-githubactionsdemo-dev-eastus --location eastus

# Final Run
az deployment group create -g rg-azurecacheforredisdemo-dev-eastus -f deploy.bicep
# Hit Post endpoint in tests.http and see logs in Log Stream of Function App and API App Service
# Connect to Az instance using stunnel and publish a message and see in app service logs that it has been subscribed to
```

### Teardown

Delete resource group rg-githubactionsdemo-dev-eastus

## Notes

- [How to test ASP.NET Core Minimal APIs](https://www.twilio.com/blog/test-aspnetcore-minimal-apis)
- [Quickstart: Deploy Bicep files by using GitHub Actions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=userlevel%2CCLI)
- [Use code coverage for unit testing](https://learn.microsoft.com/en-us/dotnet/core/testing/unit-testing-code-coverage?tabs=windows)
- [Code Coverage in GitHub with .NET Core](https://samlearnsazure.blog/2021/01/05/code-coverage-in-github-with-net-core/)
