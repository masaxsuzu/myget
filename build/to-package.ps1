$ErrorActionPreference = "Stop"

try {
    Push-Location  $PSScriptRoot

    msbuild /t:pack             `
    /p:Configuration=Release    `
    ..\myget.sln 
}
finally {
    Pop-Location
}