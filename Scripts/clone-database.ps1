#script to clone database from prod env to homolog env

Connect-AzAccount -Identity 

Update-AzConfig -DisplayBreakingChangeWarning $false

# Conectar ao Azure SQL
$sourceServerName = "production.database.windows.net"
$sourceDatabaseName = "prod-database"
$SourceResourcegroup = "prodresourcegroup"
$creds = Get-AutomationPSCredential -Name "bdcredentials"

# Detalhes do servidor de destino
$targetServerName = "homolog"
$fullServerName = "homolog.database.windows.net"
$targetDatabaseName = "homologdb"
$targetResourcegroup = "hmlresourcegroup"

# Capturar a hora de início
$startTime = Get-Date

# Inicializar variável para controlar o sucesso/erro
$success = $false

# Tente copiar o banco de dados
try {
    # Verificar se o banco de dados de destino já existe no servidor de destino e, se existir, faça o drop
    $targetDatabaseExists = Get-AzSqlDatabase -ResourceGroupName $targetResourcegroup -ServerName $targetServerName -DatabaseName $targetDatabaseName -ErrorAction SilentlyContinue

    if ($targetDatabaseExists) {
        Remove-AzSqlDatabase -ResourceGroupName $targetResourcegroup -ServerName $targetServerName -DatabaseName $targetDatabaseName -Confirm:$false
        Write-Output "Banco de dados $targetDatabaseName foi excluido."
    }

    # Criar uma cópia do banco de dados de produção no servidor de destino
    New-AzSqlDatabaseCopy -ResourceGroupName $SourceResourcegroup -ServerName $sourceServerName -DatabaseName $sourceDatabaseName -CopyDatabaseName $targetDatabaseName -CopyServerName $targetServerName -CopyResourceGroupName $targetResourcegroup
    Write-Output "Realizando a copia do ambiente de produção"

    # Alterar o tamanho do banco de dados para P1
    Set-AzSqlDatabase -ResourceGroupName $targetResourcegroup -ServerName $targetServerName -DatabaseName $targetDatabaseName -Edition "Premium" -RequestedServiceObjectiveName "P1"
    Write-Output "Alterando o size do ambiente $targetDatabaseName para P1"

    # Definir sucesso como verdadeiro
    $success = $true
}
catch {
    # Capturar qualquer erro e registrar
    $errorMessage = $_.Exception.Message
}

# String de Conexão
$connectionString = "Server=tcp:$fullServerName,1433;Initial Catalog=$targetDatabaseName;Persist Security Info=False;User ID=" + $creds.UserName + ";Password=" + $creds.GetNetworkCredential().Password + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=0;"

# Criar uma conexão com o banco de dados
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString

try {
    # Abra a conexão com o banco de dados
    $connection.Open()

    # Crie um comando para executar os updates no banco de dados.
    $command = $connection.CreateCommand()
    $command.CommandText = @"
UPDATE table1 SET name = concat('homolog-', name);
UPDATE table2 SET name = concat('homolog-', name);
UPDATE table3 SET password = 'XXXXXXX'
UPDATE table4 SET email = concat('homolog-', name) 
UPDATE table5 SET column1 = null, column2 = null, column3 = null, column4 = null, column5 = null
"@
    $command.CommandTimeout = 0;

    # Execute a consulta
    $command.ExecuteNonQuery()

    Write-output "Dados de produção alterados com sucesso."

} catch {
    Write-output "Ocorreu um erro no update dos dados: $_"
} finally {
    # Feche a conexão com o banco de dados
    $connection.Close()
}

# Capturar a hora de término
$endTime = Get-Date

# Exibe se o processo concluiu com sucesso ou ocorreu falha.
if ($success) {
    Write-Output "Concluído com Sucesso"
} else {
    Write-Output "Erro - $errorMessage"
}

Write-Output "Hora de inicio: $startTime"
Write-Output "Hora de termino: $endTime"

