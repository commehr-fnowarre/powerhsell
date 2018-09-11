
Function folder() {
    $folder = Read-Host 'type in the folderpath for example D:\Share\' 

    Return $folder
}

    $folder = folder 

    While($folder.length -eq 0){Write-Host $folder.length
                $folder = folder}

$csvexport = Read-Host 'type in the path for the csv. when you type nothing it will be C:\exportpremission.csv' 

    If($csvexport.length -eq 0) {
        $csvexport = "C:\exportpremission.csv"
    }

$FolderPath = dir -Directory -Path "$folder" -Recurse -Force
$Report = @()
Foreach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    foreach ($Access in $acl.Access)
        {
            $Properties = [ordered]@{'Folder'=$Folder.FullName;'AD
Group'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
            $Report += New-Object -TypeName PSObject -Property $Properties

        }
}

$Report | Export-Csv -path "$csvexport"  -NoTypeInformation


