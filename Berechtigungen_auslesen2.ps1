################################################################################
<#
Authors: Florian Nowarre 
Title: <show-folder-permissions>
Description / purpose:
- This script show´s folder permissions or export the inforamtions into a csv

Parameters:
- all parameters with a Read-Host and a description
#> 
#################################################################################



#variable for the folderpath

Function folder() {
    $folder = Read-Host 'Type-in the folderpath for ex. D:\Share\' 

    Return $folder
}

$folder = folder 

While($folder.length -eq 0) {
    Write-Host $folder.length
    $folder = folder
}

# variable the export path

$csvexport = Read-Host 'Type-in the path for the csv. when you type nothing in, it will shown on the screen' 


#Foreach to create the table on the screen or to the csv. columns: Folder, AD Group, Premissions, Inherited 

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