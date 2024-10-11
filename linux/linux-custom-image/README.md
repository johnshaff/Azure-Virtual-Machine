## Understanding Azure Custom Linux Images

Azure Custom Linux Images offer the ability to create virtual machine (VM) images that are tailored to specific business or operational needs. By using these custom images, organizations can standardize their virtual environments, reducing the need for repetitive manual configurations and ensuring consistency across deployments. These images can be centrally managed, versioned, and deployed globally using Azure's powerful infrastructure.

### Key Concepts

- **Azure Compute Gallery (formerly Shared Image Gallery)**: This is a central feature for managing and distributing custom images across regions in Azure. It provides the ability to create image versions, replicate them across different Azure regions, and share them with other subscriptions or tenants, making it a crucial tool for scaling global operations. The Azure Compute Gallery enhances performance by allowing multiple VMs to be deployed simultaneously from a single image version.

- **Azure Image Builder**: A service that simplifies the process of building and customizing Windows and Linux images. Azure Image Builder allows users to start from a base image, apply configurations, run custom scripts, and distribute the resulting image. It automates much of the image creation process, from updating the operating system to installing required applications, ensuring that the image is production-ready from the start.

- **Base Images**: Azure offers pre-configured base images (like Debian 11, RHEL 9, etc.), which users can further customize. These base images are regularly updated with security patches and performance enhancements, providing a reliable foundation for custom image creation.

- **Custom Image Creation**: Organizations can create images that include specific software installations, security policies, and performance optimizations. By automating the customization of the operating system and applications, users can ensure that every VM deployed from a custom image is uniform and adheres to organizational standards.

- **Replication and Region Availability**: Azure allows custom images to be replicated across multiple regions, reducing deployment times by enabling VMs to be provisioned locally, closer to their users. This improves performance and scalability for global workloads, ensuring that custom images are always available where they are needed.

- **Versioning**: Azure Compute Gallery allows for versioning of custom images, making it easy to track updates and changes. This feature ensures that older versions of an image can be retained for rollback purposes or testing, while newer versions can be pushed to production with minimal disruption.

- **Distribute and Scale**: With custom images stored in the Azure Compute Gallery, users can deploy VMs to multiple regions using the same image. This allows for rapid scaling and consistency in large, distributed environments, making it easier to manage updates and deployments across a global infrastructure.

### Benefits of Azure Custom Linux Images

- **Efficiency**: Custom images eliminate the need to configure every VM individually, allowing for rapid deployment of fully configured systems.
  
- **Consistency**: All VMs created from a custom image will have the same configurations, software, and optimizations, reducing discrepancies across different environments.

- **Security and Compliance**: By embedding security settings and updates directly into the image, organizations can ensure compliance with security policies from the moment a VM is deployed.

- **Global Scalability**: Images can be replicated across multiple regions, allowing for consistent, high-performance VM deployment anywhere in the world.

- **Simplified Maintenance**: With image versioning, updating and maintaining VM environments becomes much simpler. New versions of the image can be created, tested, and rolled out without affecting existing deployments.

Understanding these foundational concepts is essential when working with custom Windows images in Azure. This knowledge will help you effectively utilize Azure's infrastructure to automate and scale your VM deployments.

## Scripts Summary

This directory automates the creation of a custom Linux image with Apache2 and the deployment of a new virtual machine (VM) based on that image by executing three numbered scripts (1-3) in a PowerShell environment using both PowerShell Modules and the Azure CLI. By using Azure Image Builder, custom configurations are baked into the image, allowing for scalable, consistent VM deployments. This process leverages PowerShell scripts, an ARM template, and a Managed Identity Role template to streamline the image creation and provisioning workflow. The image is then provisioned with a predefined size, location, and integration with Azure Compute Gallery for easy replication and scalability.

### Process Overview

1. **Service Registration**: The first script (`1-register-services.ps1`) registers the necessary Azure resources and services required for the custom image creation process.

2. **Image Creation**: The second script (`2-create-custom-image.ps1`) creates a Managed Identity using a role template (`aibRoleImageCreation.json`) so that your image build has the necessary permissions. The Managed Identity then leverages the Azure Image Builder and an ARM template (`baseImageTemplate.json`), which specifies the source OS, VM size, and necessary customizations to build, and distribute your custom Linux Image across the regions specified in the ARM template.  

3. **VM Provisioning**: The final script (`3-provision-image-vm.ps1`) deploys a new VM using the custom image created earlier, and exposes the VM's public IP so you can check if your new Apache server is properly deployed.

### Template Details

The base image template (`baseImageTemplate.json`) includes the following configurations:

- **VM Size**: The virtual machine is set to use the `Standard_D2s_v3` size.
- **Operating System**: Debian 12 is the base OS used for the image sku (`12-gen2`).
- **Customization Tasks**: The template incorporates several important customization tasks during the image build process, such as:
  - Installing Apache2 to support web services.
  - Configuring SSH by installing `openssh-server`, enabling the service, and securing root login.
  - Applying updates by running `apt-get update` and upgrading installed packages to ensure the OS is fully updated.
  - Cleaning up unnecessary packages and clearing the package cache to optimize the image size.

Once the image is built, it is distributed through an Azure Compute Gallery, which allows for easy deployment across multiple regions, ensuring scalability and rapid VM provisioning globally.

## Prerequisites for Executing Scripts in this Directory

Before running the scripts, ensure you have:

- An Azure subscription
- You have administrator or root access to the VM.
- You have created an Azure Storage Account
- Both the Azure PowerShell module and Azure CLI installed.
- Logged into your Azure account using `Connect-AzAccount`.
- Logged into your Azure CLI using `az login`.
- A resource group and storage account (or use the script to create one).
- Ensure you're executing your scripts within the same directory as the .json files

### Additional Resources

- **Azure Documentation**: Explore detailed guides and tutorials at the [Creating an Azure Custom Linux Image](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/imaging).