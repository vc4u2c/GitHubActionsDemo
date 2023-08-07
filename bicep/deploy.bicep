@description('Location of all resources')
param pLocation string = resourceGroup().location
param pApplicationName string
param pEnv string
param pAppServicePlanOS string = 'linux'

module appServiceModule 'deploy-app-service.bicep' = {
  name: 'appServiceModule'
  params: {
    pEnv: pEnv
    pLocation: pLocation
    pApplicationName: pApplicationName
    pAppServicePlanOS: pAppServicePlanOS
  }
}

output oAppServiceName string = appServiceModule.outputs.oAppServiceName
