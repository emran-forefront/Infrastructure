targetScope = 'tenant'

param companyPrefix string

resource rootMG 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: tenant().tenantId
}

resource platformMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${companyPrefix}-platform'
  properties: {
    displayName: '${companyPrefix}-platform'
    parent: {
      id: rootMG.id
    }
  }
}

resource landingZonesMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${companyPrefix}-landingzones'
  properties: {
    displayName: '${companyPrefix}-LandingZones'
    parent: {
      id: rootMG.id
    }
  }
}

output landingZonesMG string = landingZonesMG.id
