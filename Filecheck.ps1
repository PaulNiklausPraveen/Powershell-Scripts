Set-Location E:\test
try{
$files = Get-ChildItem -Path "E:\test\test" -ErrorAction Stop
ForEach($file in $files)
{
$f = Get-Content $file
$f -contains $f[4]

}

}
catch
{
$_.exception.message
}



