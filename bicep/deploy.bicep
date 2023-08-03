@description('Location of all resources')
param pLocation string = resourceGroup().location
param pApplicationName string
param pEnv string = 'dev'

module appServiceModule 'deploy-app-service.bicep' = {
  name: 'appServiceModule'
  params: {
    pEnv: pEnv
    pLocation: pLocation
    pApplicationName: pApplicationName
  }
}
