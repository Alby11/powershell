# PowerShell Administration Toolkit

A comprehensive collection of PowerShell scripts for Windows system administration, Active Directory management, and cloud service integration.

## Repository Overview

This repository contains various PowerShell scripts designed to automate common IT administration tasks in Windows environments. The toolkit demonstrates modern approaches to system administration, security implementation, and enterprise management.

## Script Categories

### Machine Management
- [`AskAndRenameMachineWithSN.ps1`](AskAndRenameMachineWithSN.ps1) - Rename computers using serial numbers
- [`DesktopOrLaptop.ps1`](DesktopOrLaptop.ps1) - Detect machine type (laptop/desktop)
- [`GetMachineSN.ps1`](GetMachineSN.ps1) - Retrieve machine serial numbers
- [`GetMachineFromUser.ps1`](GetMachineFromUser.ps1) - Get machine information from AD user
- [`RenameMachineWithSN.ps1`](RenameMachineWithSN.ps1) - Rename local machine using SN

### Network Configuration
- [`DisableNETBIOS.ps1`](DisableNETBIOS.ps1) - Disable NetBIOS across network interfaces
- [`from_dhcp_to_fixed.ps1`](from_dhcp_to_fixed.ps1) - Convert DHCP to static IP configuration

### Security & Administration
- [`create-securePwFile.ps1`](create-securePwFile.ps1) - Create encrypted password files
- [`Remove-File-Eventually.ps1`](Remove-File-Eventually.ps1) - Handle deletion of locked files
- [`sentinelone_delete_snapshots.ps1`](sentinelone_delete_snapshots.ps1) - Manage security snapshots

### User & Device Management
- [`copy_user_batch.ps1`](copy_user_batch.ps1) - Batch creation of AD users
- [`deleteUsersFromXLSX.ps1`](deleteUsersFromXLSX.ps1) - Delete users from Excel list
- [`removeEntraIdDeviceFromUser.ps1`](removeEntraIdDeviceFromUser.ps1) - Manage Entra ID device registrations

### System Administration
- [`chengeWinPKToPro.ps1`](chengeWinPKToPro.ps1) - Windows license management
- [`office_no_org_control.ps1`](office_no_org_control.ps1) - Configure Office organizational control
- [`restartStockagerServices.ps1`](restartStockagerServices.ps1) - Service management with logging
- [`migrate_printers_newpserver.ps1`](migrate_printers_newpserver.ps1) - Migrate printer configurations

### Azure & Microsoft 365
- [`azure_login_to_graph.ps1`](azure_login_to_graph.ps1) - Microsoft Graph API authentication
- [`automic/check_agent.ps1`](automic/check_agent.ps1) - Check status of automation agents

### Tiered Administration Framework
Scripts implementing Microsoft's recommended tiered administration model:

- [`script_tier/1-Create-OUs.ps1`](script_tier/1-Create-OUs.ps1) - Create organizational unit structure
- [`script_tier/2-Create-Group.ps1`](script_tier/2-Create-Group.ps1) - Create security groups
- [`script_tier/2-TierUsersAdd.ps1`](script_tier/2-TierUsersAdd.ps1) - Add tiered administrative users
- [`script_tier/3-ManualSecurityGroupAdd.Server.ps1`](script_tier/3-ManualSecurityGroupAdd.Server.ps1) - Server group assignments
- [`tiers_administrators.ps1`](tiers_administrators.ps1) - Tiered admin management

## Technical Highlights

- **PowerShell Automation**: Advanced scripting techniques using WMI, CIM, remoting
- **Active Directory Management**: User/group creation, permissions, OU structure
- **Security Implementation**: Tiered administration model, secure credential handling
- **Windows Management**: Service control, registry configuration
- **API Integration**: REST API consumption (Microsoft Graph, SentinelOne)
- **Cloud Services**: Azure/Microsoft 365 administration

## Usage

Most scripts can be run directly from PowerShell with appropriate permissions. Some scripts require administrator privileges or specific module installations noted in script headers.

## Requirements

- Windows PowerShell 5.1 or PowerShell Core 7.x
- Windows Server environment with Active Directory
- Appropriate administrative permissions
- Various PowerShell modules as required by specific scripts

## License

This repository is provided for educational and professional reference purposes.