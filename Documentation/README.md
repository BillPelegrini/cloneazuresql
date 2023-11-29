# Database Cloning Script (Azure SQL)

## Description
This repository contains a PowerShell script designed to automate the cloning of a database from a production environment to a homologation environment in Azure SQL. The script utilizes Azure PowerShell commands to achieve the database cloning process and includes additional steps to modify sensitive production data in the cloned database.

## Structure

1. **Scripts:**
   - **clone-database.ps1:** The main PowerShell script for cloning the database.

2. **Documentation:**
   - **README.md:** Provides an overview of the script, instructions on usage, and any prerequisites.
   - **LICENSE:** Specifies the terms under which the script is distributed.

3. **Configuration:**
   - **config.ps1:** Configuration file containing variables such as server names, database names, and resource group names. Users can customize these variables based on their environment.

4. **Credentials:**
   - **credentials.ps1:** Placeholder for credentials required for database authentication. Users need to fill in their credentials securely.

## Usage Instructions

1. Clone the repository to your local machine.
   ```bash
   git clone https://github.com/BillPelegrini/cloneazuresql.git

2. Navigate to the repository directory.
   ```bash
   cd database-cloning-script
3. Update the config.ps1 file with your Azure SQL and resource group details.
4. Populate the credentials.ps1 file with the necessary login credentials securely.
5. Run the script using PowerShell.
   ```bash
   .\Scripts\clone-database.ps1
6. Monitor the script output for success or any encountered errors.

# Note

* Ensure you have the required permissions and Azure PowerShell modules installed.
* Exercise caution when handling sensitive information such as login credentials.
* This script is intended for educational and demonstration purposes. Modify it according to your production requirements.

Feel free to contribute, report issues, or suggest improvements. Happy cloning!
