## Understanding Azure Custom Windows Images

Azure Custom Windows Images offer the ability to create virtual machine (VM) images that are tailored to specific business or operational needs. By using these custom images, organizations can standardize their virtual environments, reducing the need for repetitive manual configurations and ensuring consistency across deployments. These images can be centrally managed, versioned, and deployed globally using Azure's powerful infrastructure.

### Key Concepts

- **Azure Compute Gallery (formerly Shared Image Gallery)**: This is a central feature for managing and distributing custom images across regions in Azure. It provides the ability to create image versions, replicate them across different Azure regions, and share them with other subscriptions or tenants, making it a crucial tool for scaling global operations. The Azure Compute Gallery enhances performance by allowing multiple VMs to be deployed simultaneously from a single image version.

- **Azure Image Builder**: A service that simplifies the process of building and customizing Windows and Linux images. Azure Image Builder allows users to start from a base image, apply configurations, run custom scripts, and distribute the resulting image. It automates much of the image creation process, from updating the operating system to installing required applications, ensuring that the image is production-ready from the start.

- **Base Images**: Azure offers pre-configured base images (like Windows 10, Windows Server, etc.), which users can further customize. These base images are regularly updated with security patches and performance enhancements, providing a reliable foundation for custom image creation.

- **Custom Image Creation**: Organizations can create images that include specific software installations, security policies, and performance optimizations. By automating the customization of the operating system and applications, users can ensure that every VM deployed from a custom image is uniform and adheres to organizational standards.

- **Replication and Region Availability**: Azure allows custom images to be replicated across multiple regions, reducing deployment times by enabling VMs to be provisioned locally, closer to their users. This improves performance and scalability for global workloads, ensuring that custom images are always available where they are needed.

- **Versioning**: Azure Compute Gallery allows for versioning of custom images, making it easy to track updates and changes. This feature ensures that older versions of an image can be retained for rollback purposes or testing, while newer versions can be pushed to production with minimal disruption.

- **Distribute and Scale**: With custom images stored in the Azure Compute Gallery, users can deploy VMs to multiple regions using the same image. This allows for rapid scaling and consistency in large, distributed environments, making it easier to manage updates and deployments across a global infrastructure.

### Benefits of Azure Custom Windows Images

- **Efficiency**: Custom images eliminate the need to configure every VM individually, allowing for rapid deployment of fully configured systems.
  
- **Consistency**: All VMs created from a custom image will have the same configurations, software, and optimizations, reducing discrepancies across different environments.

- **Security and Compliance**: By embedding security settings and updates directly into the image, organizations can ensure compliance with security policies from the moment a VM is deployed.

- **Global Scalability**: Images can be replicated across multiple regions, allowing for consistent, high-performance VM deployment anywhere in the world.

- **Simplified Maintenance**: With image versioning, updating and maintaining VM environments becomes much simpler. New versions of the image can be created, tested, and rolled out without affecting existing deployments.

Understanding these foundational concepts is essential when working with custom Windows images in Azure. This knowledge will help you effectively utilize Azure's infrastructure to automate and scale your VM deployments.

## Scripts Summary

This project automates the creation of a custom Windows image and the deployment of a new virtual machine (VM) based on that image in Azure. By using Azure Image Builder, custom configurations are baked into the image, allowing for scalable, consistent VM deployments. This process leverages PowerShell scripts and an ARM template to streamline the image creation and provisioning workflow. The VM is then provisioned with a predefined size, location, and integration with Azure Compute Gallery for easy replication and scalability.

### Process Overview

1. **Service Registration**: The first script (`1-register-services.ps1`) registers the necessary Azure resources and services required for the custom image creation process.

2. **Image Creation**: The second script (`2-create-custom-image.ps1`) builds the custom Windows image by leveraging Azure Image Builder and the ARM template (`baseImageTemplate.json`), which specifies the source OS, VM size, and necessary customizations.

3. **VM Provisioning**: The final script (`3-provision-image-vm.ps1`) deploys a new VM using the custom image created earlier, and opens the necessary ports before returning your public IP address for use with Windows Remote Desktop (RDP).

### Template Details

The base image template (`baseImageTemplate.json`) includes the following configurations:

- **VM Size**: The virtual machine is set to use the `Standard_D2s_v3` size.
- **Operating System**: Windows 10 is the base OS used for the image (`win10-22h2-avd-g2`).
- **Customization Tasks**: The template incorporates several important customization tasks during the image build process, such as:
  - Installing FsLogix for profile management.
  - Optimizing the operating system for enhanced performance.
  - Installing Microsoft Teams as part of the default applications.
  - Running Windows Updates to ensure the image is fully up to date.

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

- **Azure Documentation**: Explore detailed guides and tutorials at the [Creating an Azure Custom Windows Image](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/image-builder-virtual-desktop).