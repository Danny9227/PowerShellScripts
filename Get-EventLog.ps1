Get-EventLog -LogName Application -InstanceId 1035 -After ((Get-Date).AddDays(-1)) | Export-Csv -Path C:\EventLogOutput.csv -NoTypeInformation