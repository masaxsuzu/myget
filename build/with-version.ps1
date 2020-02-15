function Run {
    param (
        $_args,
        $info
    )
    $configration=$_args[0]
    $version = $info.version
    $build = $info.build
    $Title = $info.title
    $company = $info.company
    $product = $info.name

    msbuild /t:Build                 `
        /p:Configuration=$configration     `
        /p:Version="$version.$build" `
        /p:Title=$Title              `
        /p:Company=$company          `
        /p:Product=$product          `
        ..\myget.sln

}

#region script template

$ErrorActionPreference = "Stop"

function StopIfError {
    param (
        $message
    )
    if(!$?){
        throw $message
    }
}

try {
    Push-Location  $PSScriptRoot
    Run $Args $(Get-Content ..\product.json | ConvertFrom-Json)
}
finally {
    Pop-Location
}

#endregion
