
Function folder() {
    $folder = Read-Host 'Type-in the folderpath for example D:\Share\' 

    Return $folder
}

$folder = folder 

While($folder.length -eq 0) {
    Write-Host $folder.length
    $folder = folder
}

$csvexport = Read-Host 'Type-in the path for the csv. when you type nothing it will show on the screen' 


$FolderPath = dir -Directory -Path "$folder" -Recurse -Force -ErrorAction SilentlyContinue
$Report = @()
Foreach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    foreach ($Access in $acl.Access) {
        $Properties = [ordered]@{'Folder' = $Folder.FullName;'AD Group' = $Access.IdentityReference;'Permissions' = $Access.FileSystemRights;'Inherited' = $Access.IsInherited}
        $Report += New-Object -TypeName PSObject -Property $Properties
    }
}

If($csvexport.length -eq 0) {
    $Report | Format-Table -autosize 
} Else {
    $Report | Export-Csv -path "$csvexport" -NoTypeInformation 
}