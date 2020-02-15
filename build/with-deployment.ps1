function Run {
    param (
        $_args,
        $info
    )
    
    nuget locals all -clear
    msbuild ..\myget.sln -t:clean
    New-Item ..\pkg -ItemType Directory -force
    nuget sources add -name "local-myget" -source "$(Split-Path $pwd -Parent)\pkg"
    nuget restore ..\myget.sln

    ..\build\with-version.ps1 "Release"

    StopIfError "Build error"

    msbuild ..\myget.sln -t:pack -p:Configuration="Release"

    StopIfError "Package error"

    nuget install MyGet.Dep -outputdir ..\dep    

    StopIfError "Install error"

    ..\dep\extract.ps1 "..\sbx"

    StopIfError "Deployment error"

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
    nuget sources remove -name "local-myget"
    Pop-Location
}

#endregion
