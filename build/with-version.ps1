$ErrorActionPreference = "Stop"

$info = Get-Content .\Product.json | ConvertFrom-Json
$version = $info.version
$build = $info.build
$Title = $info.title
$company = $info.company
$product = $info.name

msbuild /t:ReBuild               `
    /p:Configuration=Release     `
    /p:Version="$version.$build" `
    /p:Title=$Title              `
    /p:Company=$company          `
    /p:Product=$product