function Run {
    param (
        $args,
        $info
    )
    
    nuget locals all -clear
    msbuild ..\myget.sln -t:clean
    nuget restore ..\myget.sln
    
    ..\build\with-version.ps1

    StopIfError "Build error"

    msbuild ..\myget.sln -t:pack -p:Configuration="Release"

    StopIfError "Package error"

    nuget install MyGet.Dep -outputdir ..\pkg    

    StopIfError "Install error"

    ..\dep\extract.ps1

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
    Pop-Location
}

#endregion
