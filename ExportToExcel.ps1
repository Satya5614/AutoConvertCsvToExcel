### Set CSV source folder path and excel destination folder
$sourceCSV = "<Full path of dir where CSVs are downloded/created>"
$destinationXLSX = "<Full path of dir where converted excels are saved>"

### FIlters for file type
$filter = "*.csv"

### Set watcher on File System events
$fswatcher = New-Object IO.FileSystemWatcher $sourceCSV, $filter -Property @{
    IncludeSubdirectories = $false
    NotifyFilter = [IO.NotifyFilters] 'FileName, LastWrite'
}

### Set eventlistner on file system events
$onCreated = Register-ObjectEvent $fswatcher Created -SourceIdentifier FileCreated -Action {
    
    $path = $Event.SourceEventArgs.FullPath
    $name = $Event.SourceEventArgs.Name
    
    $outputFileName = $name.Replace('.csv','_excel') 
    
    ### Create a new Excel Workbook with worksheet
    $excel = New-Object -ComObject excel.application
    
    $Workbook = $excel.workbooks.open($path)
    $Worksheets = $Workbook.worksheets
    $Workbook.SaveAs("$destinationXLSX\$outputFileName.xlsx", 51)
    $Workbook.Saved = $True
    $excel.Quit()
}