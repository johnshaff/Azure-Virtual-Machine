
# Checks the registration state of resource providers required for the image build process and registers them if necessary.

try {
    $providers = @(
        "Microsoft.VirtualMachineImages",
        "Microsoft.Storage",
        "Microsoft.Compute",
        "Microsoft.KeyVault",
        "Microsoft.ContainerInstance",
        "Microsoft.ManagedIdentity"
    )

    foreach ($provider in $providers) {
        $providerState = Get-AzResourceProvider -ProviderNamespace $provider

        if ($providerState.RegistrationState -ne 'Registered') {
            Write-Host "$provider is not registered. Attempting to register..."
            Register-AzResourceProvider -ProviderNamespace $provider
            Write-Host "$provider registered successfully."
        }
        else {
            Write-Host "$provider is already registered."
        }
    }
}
catch {
    Write-Error "An error occurred: $_"
}