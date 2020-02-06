$ErrorActionPreference = "Stop"

$info = Get-Content .\Product.json | ConvertFrom-Json
$Version = $info.version
$Title = $info.title
$Company = $info.company
$Product = $info.name

msbuild /t:ReBuild              `
    /p:Configuration=Release    `
    /p:Version=$Version         `
    /p:Title=$Title             `
    /p:Company=$Company         `
    /p:Product=$Product