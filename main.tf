# Create resource groups for the project

resource "azurerm_resource_group" "prod" {
  name     = "Medilync-ProdRG"
  location = var.location
}

resource "azurerm_resource_group" "dev" {
  name     = "Medilync-DevRG"
  location = var.location
}

resource "azurerm_resource_group" "infra" {
  name     = "Medilync-InfraRG"
  location = var.location
}

module "nsg" {
  source              = "./modules/nsg"
  resource_group_name = azurerm_resource_group.prod.name
  location            = var.location

  nsg_definitions = {
    dmz-nsg = {
      rules = [
        {
          name                       = "Allow-HTTPS-Inbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    },
    internal-nsg = {
      rules = [
        {
          name                       = "Allow-HTTPS-from-DMZ"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "10.0.0.0/24"
          destination_address_prefix = "*"
        }
      ]
    },
    dev-nsg = {
      rules = [
        {
          name                       = "Allow-Bastion"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "10.0.255.0/27"
          destination_address_prefix = "*"
        }
      ]
    }
  }
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.prod.name
  location            = var.location
  vnet_name           = "medilync-vnet"
  address_space       = ["10.0.0.0/16"]

  subnets = {
    dmz = {
      address_prefix = "10.0.0.0/24"
    }
    internal = {
      address_prefix = "10.0.1.0/24"
    }
    dev = {
      address_prefix = "10.0.2.0/24"
    }
  }

  subnet_nsg_map = {
    dmz     = module.nsg.nsg_ids["dmz-nsg"]
    internal = module.nsg.nsg_ids["internal-nsg"]
    dev     = module.nsg.nsg_ids["dev-nsg"]
  }
}

module "bastion" {
  source                      = "./modules/bastion"
  resource_group_name         = azurerm_resource_group.prod.name
  location                    = var.location
  vnet_name                   = "medilync-vnet"
  vnet_resource_group_name    = azurerm_resource_group.prod.name
  bastion_subnet_prefix       = "10.0.255.0/27"
  public_ip_name              = "bastion-ip"
  bastion_name                = "medilync-bastion"

  depends_on = [module.network]
}


module "compute" {
  source = "./modules/compute"

  vm_configurations = {
    web01 = {
      name               = "web01"
      resource_group     = azurerm_resource_group.prod.name
      location           = var.location
      subnet_id          = module.network.subnet_ids["dmz"]
      public_ip_required = true
      admin_username     = var.admin_username
      admin_password     = var.admin_password
    },
    db01 = {
      name               = "db01"
      resource_group     = azurerm_resource_group.prod.name
      location           = var.location
      subnet_id          = module.network.subnet_ids["internal"]
      public_ip_required = false
      admin_username     = var.admin_username
      admin_password     = var.admin_password
    },
    dev01 = {
      name               = "dev01"
      resource_group     = azurerm_resource_group.dev.name
      location           = var.location
      subnet_id          = module.network.subnet_ids["dev"]
      public_ip_required = false
      admin_username     = var.admin_username
      admin_password     = var.admin_password
    }
  }
}

module "keyvault" {
  source              = "./modules/keyvault"
  key_vault_name      = "medilync-kv"
  resource_group_name = azurerm_resource_group.infra.name
  location            = var.location
  admin_object_id     = var.admin_object_id
}

module "monitoring" {
  source              = "./modules/monitoring"
  resource_group_name = azurerm_resource_group.infra.name
  location            = var.location
  workspace_name      = "medilync-loganalytics"

  vm_ids = {
    web01 = module.compute.vm_ids["web01"]
    db01  = module.compute.vm_ids["db01"]
    dev01 = module.compute.vm_ids["dev01"]
  }
}



module "iam" {
  source      = "./modules/iam"
  group_names = [
    "Medilync-Admin",
    "Medilync-Dev",
    "Medilync-Finance",
    "Medilync-Nurse",
    "Medilync-Healthcare"
  ]

  role_assignments = {
    "Medilync-Admin" = [
      {
        scope     = azurerm_resource_group.prod.id
        role_name = "Owner"
      },
      {
        scope     = azurerm_resource_group.infra.id
        role_name = "Owner"
      },
      {
        scope     = azurerm_resource_group.dev.id
        role_name = "Owner"
      }
    ],
    "Medilync-Dev" = [
      {
        scope     = azurerm_resource_group.dev.id
        role_name = "Contributor"
      }
    ],
    "Medilync-Finance" = [
      {
        scope     = azurerm_resource_group.infra.id
        role_name = "Reader"
      }
    ]
  }
}
