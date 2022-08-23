terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.19.1"
    }
  }
}

locals {
  apimName = "mf-demo-apim"
  resource_group_name = "api-management"
}

provider "azurerm" {
  features {}
}

data "azurerm_api_management" "apim" {
  name                = local.apimName
  resource_group_name = local.resource_group_name
}

resource "azurerm_api_management_api" "person_wsdl_link_api" {
  name                = "person-wsdllinkapi"
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "Person Retriever API (WSDLLINK)"
  revision = "1"
  protocols           = ["https"]
  path                = "person-wsdl-link"  
  service_url         = "https://wcf-app-app-site.azurewebsites.net"
  import {
    content_format = "wsdl-link"
    content_value  = "https://wcf-app-app-site.azurewebsites.net/PersonRetriever.svc?wsdl"
    wsdl_selector {
      service_name = "PersonRetriever"
      endpoint_name = "BasicHttpsBinding_IPersonRetriever"
    }
  }
}

resource "azurerm_api_management_api" "person_wsdl_api" {
  name                = "person-wsdlapi"
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "Person Retriever API (WSDL)"
  revision = "1"
  protocols           = ["https"]
  path                = "person-wsdl"  
  service_url         = "https://wcf-app-app-site.azurewebsites.net"
  import {
    content_format = "wsdl"
    content_value  = file("./personwsdl.xml")
    wsdl_selector {
      service_name = "PersonRetriever"
      endpoint_name = "BasicHttpsBinding_IPersonRetriever"
    }
  }
}

resource "azurerm_api_management_api" "person_wsdl_link_passthru_api" {
  name                = "person-wsdllinkapi-passthru"
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "Person Retriever API (WSDLLINK PASSTHRU)"
  revision = "1"
  protocols           = ["https"]
  path                = "person-wsdl-link"  
  service_url         = "https://wcf-app-app-site.azurewebsites.net"
  soap_pass_through   = true
  import {
    content_format = "wsdl-link"
    content_value  = "https://wcf-app-app-site.azurewebsites.net/PersonRetriever.svc?wsdl"
    wsdl_selector {
      service_name = "PersonRetriever"
      endpoint_name = "BasicHttpsBinding_IPersonRetriever"
    }
  }
}

resource "azurerm_api_management_api" "person_wsdl_passthru_api" {
  name                = "person-wsdlapi-passthru"
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "Person Retriever API (WSDL PASSTHRU)"
  revision = "1"
  protocols           = ["https"]
  path                = "person-wsdl"  
  service_url         = "https://wcf-app-app-site.azurewebsites.net"
  soap_pass_through   = true
  import {
    content_format = "wsdl"
    content_value  = file("./personwsdl.xml")
    wsdl_selector {
      service_name = "PersonRetriever"
      endpoint_name = "BasicHttpsBinding_IPersonRetriever"
    }
  }
}