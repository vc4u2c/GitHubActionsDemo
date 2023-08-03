param pLocation string
param pApplicationName string
param pEnv string
param pAppServicePlanOS string

// App Service Plan
param pAppServicePlanName string = 'pl-${pApplicationName}-${pEnv}-${pLocation}'
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: pAppServicePlanName
  kind: pAppServicePlanOS
  properties: {
    reserved: ((pAppServicePlanOS == 'linux') ? true : false)
  }
  location: pLocation
  sku: {
    name: 'S1'
    capacity: 1
  }
}

var configReferenceLinux = {
  linuxFxVersion: 'DOTNETCORE|7.0'
}

var configReferenceWindows = {
  windowsFxVersion: 'dotnet:7'
  netFrameworkVersion: 'v7.0'
}

// App Service
param pAppServiceName string = 'app-${pApplicationName}-${pEnv}'
resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: pAppServiceName
  location: pLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: ((pAppServicePlanOS == 'linux') ? configReferenceLinux : configReferenceWindows)
  }
}

// Application Settings for App Service
resource appServiceAppSetting 'Microsoft.Web/sites/config@2022-09-01' = {
  name: 'web'
  parent: appService
  properties: {
    appSettings: [
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: appInsights.properties.InstrumentationKey
      }
    ]
  }
}

// App Insights
param pAppInsightsName string = 'log-${pApplicationName}-${pEnv}'
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: pAppInsightsName
  location: pLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

// Staging Deployment Slot
param pDeploymentSlotName string = 'staging'
resource stagingSlot 'Microsoft.Web/sites/slots@2021-02-01' = if (pEnv == 'prd') {
  name: pDeploymentSlotName
  parent: appService
  location: pLocation
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
  }
}

output oAppServiceName string = pAppServiceName
