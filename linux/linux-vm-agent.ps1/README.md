## Understanding Azure Linux VM Agents

Azure Linux VM Agents (waagent) are used to manage Azure Linux Virtual Machines by enabling interaction with the Azure platform. The agent is responsible for provisioning, monitoring, and handling VM extensions. It ensures that your Linux VM can be properly integrated into Azure services, making it an essential component for cloud-based management.

### Key Components

- **waagent (Azure Linux Agent)**: The primary service that enables communication between the Linux VM and Azure's control plane. It facilitates tasks such as provisioning, SSH key injection, and handling custom scripts or other VM extensions.

- **Provisioning**: The agent handles initial VM setup, including hostname configuration, user creation, and enabling SSH access based on the provided Azure parameters.

- **VM Extensions**: The waagent agent manages extensions including extensions which are other agents, allowing you to run custom scripts, deploy configurations, or perform monitoring tasks on the VM after provisioning. When installing an extension on a vm, whether you're using the Azure CLI `az vm extension set` command, or you're installing the extension via a template using the Azure CLI `az deployment group create` command, it is ultimately the waagent agent (ie Azure Linux Agent) that is doing the installation, configuration, and updating of that extension.

### VM Agent Features

- **Automatic Updates**: The agent can be configured to automatically update itself to the latest version, ensuring compatibility with new Azure features and security patches.

- **SSH Key Management**: Automatically injects or updates SSH keys provided during the VM creation process, allowing secure access.

- **Extension Handling**: Supports a wide variety of extensions for operations like monitoring, security, and backup, ensuring the VM is properly managed and integrated with Azure services.

- **Provisioning Logging**: Logs activities during the VM provisioning process, aiding in troubleshooting and performance monitoring.

### Supported Linux Distributions

The Azure Linux VM Agent supports various Linux distributions, including:

- Ubuntu
- CentOS
- Red Hat Enterprise Linux (RHEL)
- SUSE Linux Enterprise Server (SLES)
- Debian

### Prerequisites for Using Azure Linux VM Agent Scripts & Templates

Before configuring the Linux VM agent, ensure the following:

- The Linux distribution is supported by the Azure Linux Agent.
- The VM has outbound internet access to reach Azure endpoints.
- You have administrator or root access to the VM.
- Both the Azure PowerShell module and Azure CLI installed.
- Logged into your Azure account using `Connect-AzAccount`.
- Logged into your Azure CLI using `az login`.
- A resource group and storage account (or use the script to create one).

## Linux VM Agent Scripts

### `lvm-install-extension-template.ps1`

This script deploys the **AzureMonitorLinuxAgent** extension on an existing Linux VM for performance monitoring. The agent requires a Log Analytics workspace to store and analyze collected metrics like CPU performance. To ensure all dependencies are handled, the script first creates a Log Analytics workspace and retrieves its Resource ID. The workspace details, along with the VM name, are passed to an ARM template, which deploys the **AzureMonitorLinuxAgent** extension and sets up data collection rules. These rules ensure that performance data is sent to the Log Analytics workspace for monitoring and analysis.

### `lvm-install-extension.ps1`

This script uses the Azure CLI to install the **AzureMonitorLinuxAgent** extension on an existing Linux VM. It leverages the Azure CLI `az vm extension set` command to add the agent to the specified VM for performance monitoring. This script only installs the agent and does not configure or set up the Log Analytics workspace for data collection.