# Configuration settings for the database cloning script

# Source (Production) Database Details
$sourceServerName = "production.database.windows.net"
$sourceDatabaseName = "prod-database"
$SourceResourcegroup = "prodresourcegroup"

# Target (Homologation) Database Details
$targetServerName = "homolog"
$targetDatabaseName = "homologdb"
$targetResourcegroup = "hmlresourcegroup"

# Full Server Name for Connection String
$fullServerName = "$targetServerName.database.windows.net"

