function Run {
    param (
        $args,
        $info
    )
    
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
