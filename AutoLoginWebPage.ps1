#This Script is used to autologin to Azure webpage

Import-Module -Name Selenium -Force
Import-Module -Name PsOcr  -force

$Screenshotname="C:\Temp\image1.jpg "
$URL="https://portal.azure.com"
$userName="username@outlook.com"
$Password="Germany@123"


$Driver = Start-SeChrome -Arguments @('Incognito','start-maximized')
Enter-SeUrl $URL -Driver $Driver   


$Driver.FindElementByXPath('//*[@id="i0116"]').SendKeys($userName)
$Driver.FindElementByXPath('//*[@id="idSIButton9"]').Click()
Sleep 5
$Driver.FindElementByXPath('//*[@id="i0118"]').SendKeys($Password)
$Driver.FindElementByXPath('//*[@id="idSIButton9"] ').Click()
$Driver.FindElementByXPath('//*[@id="idBtn_Back"]').Click()
Sleep 5
New-SeScreenshot -Path $Screenshotname -ImageFormat Jpeg  -Target $Driver 
$VerifyImage=Convert-PsoImageToText -Path $Screenshotname  -Language en-us
 
If(($VerifyImage.Text -match "DEFAULT DIRECTORY") -and ($VerifyImage.Words -match "PowerShell-ResourceGroup"))  {

Write-host "Site has been successfully logged in" -ForegroundColor Green

} 
Else{ 
  Write-host  "Failed to Login" -ForegroundColor RED
}
$driver.Quit()
