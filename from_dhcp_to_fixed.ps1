#!/usr/bin/env pwsh

# Debug
$debug = 1

# Define the IP ranges
$ipRange1 = 2..254 | ForEach-Object { "192.168.2.$_" }
$ipRange2 = 2..254 | ForEach-Object { "192.168.6.$_" }
$ipRange = $ipRange1 + $ipRange2

# Define the blacklist of IP addresses
$blacklist = "192.168.1.0", "172.16.1.1"

# Filter out the blacklist
$ipRange = $ipRange | Where-Object { $_ -notin $blacklist }

# Define the DHCP range
$dhcpRange = 2..254 | ForEach-Object { "10.30.3.$_" }

# Get the network adapter
$adapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

# Get the current IP address
$currentIP = (Get-NetIPAddress -InterfaceIndex $adapter.ifIndex).IPAddress

# Check if the current IP is in the DHCP range
if ($currentIP -in $dhcpRange)
{
  foreach ($ip in $ipRange)
  {

    # Display the current IP address
    Write-Output "Current IP Address: $currentIP"
    # Get the current DNS server addresses
    $currentDNS = (Get-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex).ServerAddresses
    # Display the current DNS server addresses
    Write-Output "Current DNS Server Addresses: $currentDNS"
        
    # Check if the IP address is free
    if (!(Test-Connection -ComputerName $ip -Count 1 -Quiet))
    {
      # 
      if ($debug -eq 0)
      {
        # Set the IP address
        New-NetIPAddress -InterfaceIndex $adapter.ifIndex -IPAddress $ip -PrefixLength 16 -DefaultGateway "172.16.1.1"
        # Set the DNS server
        Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses "172.16.1.11", "172.16.1.20"
            
      }
      else
      {
        Write-Output "Debug is active"
      }

      # Display the new IP address
      $currentIP = (Get-NetIPAddress -InterfaceIndex $adapter.ifIndex).IPAddress
      Write-Output "New IP Address: $currentIP"
      # Get the new DNS server addresses
      $currentDNS = (Get-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex).ServerAddresses
      # Display the current DNS server addresses
      Write-Output "New DNS Server Addresses: $currentDNS"
      break
    }
  }
}
