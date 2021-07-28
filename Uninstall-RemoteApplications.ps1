################################## METHOD 1 ##################################

$compList = Get-Content -Path C:\ComputerList.txt

foreach ($comp in $compList) {
    
    $online = Test-Connection -ComputerName $comp -Count 2 -Quiet

    if ($online) {

        $app = Get-CimInstance -ClassName Win32_Product -ComputerName $comp | Where-Object {$_.Name -eq 'Kofax Power PDF Advanced'}

        if ($app) {

            $app | Invoke-CimMethod -MethodName 'Uninstall'

            Out-File -InputObject $comp -FilePath C:\CompsWhereUninstallSucceeded.txt -Append -Force
        }
        else {

            Write-Information -MessageData "The specified application does not exist on $comp." -InformationAction Continue

            Out-File -InputObject $comp -FilePath C:\CompsWhereAppDoesNotExist.txt -Append -Force
        } #if/else app exists
    } #if Online
} #foreach


################################## METHOD 2 NO RESTART ##################################

$compList = Get-Content -Path C:\ComputerList.txt

foreach ($comp in $compList) {

    $online = Test-Connection -ComputerName $comp -Count 2 -Quiet

    if ($online) {

        $app = Get-CimInstance -ClassName Win32_Product -ComputerName $comp | Where-Object {$_.Name -eq 'Kofax Power PDF Advanced'}

        if ($app) {

            $appGuid = $app.IdentifyingNumber

            Invoke-Command -ComputerName $comp -ScriptBlock {

                Start-Process 'msiexec' -ArgumentList "/uninstall $appGuid /quiet /norestart"
            }

            Out-File -InputObject $comp -FilePath C:\CompsWhereUninstallRan.txt -Append -Force
        }
        else {

            Write-Information -MessageData "The app does not exist on $comp" -InformationAction Continue

            Out-File -InputObject $comp -FilePath C:\CompsWhereAppDoesNotExist.txt -Append -Force
        } #if/else app exists
    } #if online
} #foreach