## Understanding Azure Linux Virtual Machines

Azure Linux Virtual Machines provide flexible and scalable compute resources in the cloud, tailored specifically for running Linux-based workloads. Azure offers a wide range of Linux distributions, optimized for different use cases like web hosting, AI model training, and container orchestration. Linux VMs in Azure come with unique features and integrations, making them distinct from Windows VMs.

### Key Features

- **Open-Source Flexibility**: Azure supports a broad spectrum of Linux distributions, including Ubuntu, CentOS, Debian, Red Hat Enterprise Linux (RHEL), and SUSE, allowing organizations to run a variety of open-source applications and services.

- **Custom Images and Containers**: Azure allows you to create and deploy custom Linux VM images or run containerized applications using Docker, Kubernetes, or Azure Kubernetes Service (AKS), giving you full control over your environments.

- **Cloud-Init**: A configuration tool specifically for Linux VMs, cloud-init allows automatic provisioning tasks such as setting up SSH keys, disk partitioning, and user management during boot time. This tool is not available for Windows VMs, making Linux VMs more customizable at startup.

- **VM Extensions**: The waagent agent manages extensions including extensions which are other agents, allowing you to run custom scripts, deploy configurations, or perform monitoring tasks on the VM after provisioning. When installing an extension on a vm, whether you're using the Azure CLI `az vm extension set` command, or you're installing the extension via a template using the Azure CLI `az deployment group create` command, it is ultimately the waagent agent (ie Azure Linux Agent) that is doing the installation, configuration, and updating of that extension.

- **SSH Access**: Linux VMs provide secure, out-of-the-box access through Secure Shell (SSH) instead of Remote Desktop Protocol (RDP), which is used for Windows VMs. SSH allows for more flexible and scriptable remote management.

- **Native Bash Support**: Unlike Windows VMs, Linux VMs offer Bash shell as the default command-line interface. This makes it easier for developers familiar with Linux environments to interact with their VMs.

- **Azure Hybrid Benefit for Linux**: Linux VMs in Azure come with unique licensing and cost-saving benefits, such as the ability to use existing on-premises Red Hat and SUSE licenses in Azure without additional fees. This benefit is not available for Windows VMs.

### Unique Services for Azure Linux VMs

- **Azure Monitor for Linux**: While Azure Monitor is available for both Linux and Windows VMs, Linux VMs can integrate more deeply with open-source monitoring solutions like **Prometheus** and **Grafana**. This allows advanced, customizable monitoring and alerting tailored to Linux workloads.

- **Custom Linux Kernel**: You can use a custom Linux kernel with Azure Linux VMs, providing complete control over performance optimizations, security, and kernel module loading. This level of customization is not available for Windows VMs.

- **Accelerated Networking for Linux**: Azure Linux VMs support Accelerated Networking, which provides enhanced throughput, lower latency, and reduced CPU usage for high-performance workloads. Although this feature is available for both Windows and Linux VMs, the Linux implementation supports a wider range of network optimizations, especially for open-source networking tools.

- **Azure VM Scale Sets with Linux**: For Linux workloads, you can take advantage of **VM Scale Sets** to deploy and manage a group of identical VMs that automatically scale based on demand. Linux VMs integrate seamlessly with container orchestration tools such as Kubernetes, making it easier to deploy large-scale applications.

### Supported Linux Distributions

Azure provides a wide range of Linux distributions, including but not limited to:

- Ubuntu
- CentOS
- Red Hat Enterprise Linux (RHEL)
- SUSE Linux Enterprise Server (SLES)
- Debian
- Oracle Linux
- CoreOS (for container workloads)

### Unique Security Features for Linux VMs

- **SE Linux (Security-Enhanced Linux)**: This is a security module available in Red Hat-based distributions like RHEL and CentOS, providing additional security policies for Linux VMs.
  
- **AppArmor**: Another security feature that is available on Ubuntu and other distributions, AppArmor allows you to restrict programs' capabilities, ensuring tighter control over services.

## Prerequisites for Executing Scripts in the Linux Directory

Before running the scripts, ensure you have:

- An Azure subscription
- You have administrator or root access to the VM.
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

## Linux VM Agent (LVM) Scripts

### `lvm-list-extensions.ps1`

This script lists all available Azure Linux Extensions and first gives you the latest version of each, and then list all other versions.

### `lvm-list-extensions.ps1`

This script lists all available Azure Linux Extensions and first gives you the latest version of each, and then list all other versions.
