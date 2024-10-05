## Understanding Linux Virtual Machines

Azure Table Storage is a NoSQL key-value store for rapid development using massive semi-structured datasets. It is ideal for storing structured, non-relational data.



## Prerequisites for Executing Scripts in the Queue Directory

Before running the scripts, ensure you have:

- Both the Azure PowerShell module and Azure CLI installed.
- Logged into your Azure account using `Connect-AzAccount`.
- Logged into your Azure CLI using `az login`.
- A resource group and storage account (or use the script to create one).

## Start Here:

### `linux-list-images.ps1`

This script helps you retrieve and display the latest Linux virtual machine images available in Azure by publisher (ex Debian, RedHat, etc). It groups images by both Offer and SKU to ensure that you get the most recent version for each unique combination. This makes it easier to select the appropriate image when deploying new virtual machines.

## Linux VM Scripts

### `linux-apache-vm.ps1`

This script automates the deployment of a Debian 11 Linux Virtual Machine (VM) on Azure. It creates the VM, configures networking to allow HTTP traffic on port 80, and installs the Apache2 web server on the VM.