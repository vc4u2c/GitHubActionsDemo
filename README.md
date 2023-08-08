# GitHub Actions CI/CD Demo

[![](https://img.shields.io/github/actions/workflow/status/vc4u2c/GitHubActionsDemo/ci-workflow.yml?branch=main)](https://github.com/vc4u2c/GitHubActionsDemo/actions?query=branch%3Amain)
![CI Workflow Passing](https://github.com/vc4u2c/GitHubActionsDemo/actions/workflows/ci-workflow.yml/badge.svg)
![CD Workflow Passing](https://github.com/vc4u2c/GitHubActionsDemo/actions/workflows/cd-workflow.yml/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/vc4u2c/GitHubActionsDemo/badge.svg?branch=main)](https://coveralls.io/github/vc4u2c/GitHubActionsDemo?branch=main)
[![GitHub contributors](https://img.shields.io/github/contributors/vc4u2c/GitHubActionsDemo)](https://github.com/vc4u2c/GitHubActionsDemo/graphs/contributors)
[![GitHub last commit](https://img.shields.io/github/last-commit/vc4u2c/GitHubActionsDemo)](https://github.com/vc4u2c/GitHubActionsDemo)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/vc4u2c/GitHubActionsDemo)](https://github.com/vc4u2c/GitHubActionsDemo/graphs/commit-activity)
[![GitHub Repo stars](https://img.shields.io/github/stars/vc4u2c/GitHubActionsDemo)](https://github.com/vc4u2c/GitHubActionsDemo/stargazers)
[![open issues](https://img.shields.io/github/issues/vc4u2c/GitHubActionsDemo)](https://github.com/vc4u2c/GitHubActionsDemo/issues)
![](https://img.shields.io/github/license/vc4u2c/GitHubActionsDemo)

- .NET 7 Minimal Web API with Tests & Code Coverage using GitHub Actions
- Infrastructure automation using Bicep
- Unit Tests in Pipeline
- Code Coverage and Code Converage reporting
- [How To Deploy Your Application To Azure Using GitHub Actions | CI/CD Pipeline](https://www.youtube.com/watch?v=QP0pi7xe24s)

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
dotnet add tests/GitHubActionsDemo.WebApi.Tests package Microsoft.NET.Test.Sdk
dotnet add tests/GitHubActionsDemo.WebApi.Tests package coverlet.msbuild
dotnet sln GitHubActionsDemo.sln add src\GitHubActionsDemo.WebApi\GitHubActionsDemo.WebApi.csproj
dotnet sln GitHubActionsDemo.sln add tests\GitHubActionsDemo.WebApi.Tests\GitHubActionsDemo.WebApi.Tests.csproj

git init -b main
# And commit and push to remote
# Ensure Remote GitHub Repo is public
# Sign up with https://coveralls.io/ using GitHub creds
# Click on Add Repos and click Sync Repos
# Turn on the start uploading coverage option
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

### Create Infrastructure in Azure

```
# Check if we are logged in
az account show

# Login
az login

# Change active subscription
az account set --subscription "sub-vc4u2c-demo"
az account subscription list

# Create Resource Group
az group create --name rg-githubactionsdemo-dev-eastus --location eastus

az ad sp create-for-rbac --name spgithubactionsdemo --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/rg-githubactionsdemo-dev-eastus --sdk-auth

# Download Github CLI and install
https://cli.github.com/

# Login to GitHub. Type command below and enter details interatively
gh auth login -p https -h GitHub.com -w
gh auth status

# Set secrets
gh secret set AZURE_SUBSCRIPTION -b {subscription-id} -R vc4u2c/GitHubActionsDemo
# If this does not work then enter manually in the UI
gh secret set AZURE_CREDENTIALS -b @'
{
  "clientId": "xxx",
  "clientSecret": "{}",
  "subscriptionId": "{}",
  "tenantId": "{}",
  "activeDirectoryEndpointUrl": "{}",
  "resourceManagerEndpointUrl": "{}",
  "activeDirectoryGraphResourceId": "{}",
  "sqlManagementEndpointUrl": "{}",
  "galleryEndpointUrl": "{}",
  "managementEndpointUrl": "{}"
} -R vc4u2c/GitHubActionsDemo
'@

# List the secrets created
gh secret list

# Set Vars
gh variable set SUBSCRIPTION_NAME -b "sub-vc4u2c-demo" -R vc4u2c/GitHubActionsDemo
gh variable set APPLICATION_NAME -b "githubactionsdemo" -R vc4u2c/GitHubActionsDemo
gh variable set LOCATION -b "eastus" -R vc4u2c/GitHubActionsDemo
gh variable set ENVIRONMENT -b "dev" -R vc4u2c/GitHubActionsDemo

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
- [Disable a direct push to GitHub main branch](https://dev.to/pixiebrix/disable-a-direct-push-to-github-main-branch-8c2#:~:text=To%20create%20a%20branch%20protection,a%20pull%20request%20before%20merging)
- [Managing the automatic deletion of branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches)
- [Quickstart: Deploy Bicep files by using GitHub Actions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=userlevel%2CCLI)
- [GitHub CLI](https://cli.github.com/)
