function Run {
    param (
        $_args,
        $info
    )

    $myget_contents = "MyGet.Contents"
    $lib_net472 = "lib\net472\"
    $lib_netstandard20 = "lib\netstandard2.0\"
    $lib_netother = "lib\net"
    $lib_portable = "lib\portable-"
    $lib = "lib\"
    $content = "content\"

    $sbx = $_args[0]
    $bin = "bin"
    if(Test-Path $sbx) {
        Remove-Item $sbx -r -force
    }

    ls ..\dep -Directory | % {

        $parent = $_.Parent
        $packageName = $_.Name

        ls $_.FullName -r -File -exclude "*.nupkg" | % {
            
            $file = ($_.FullName).Replace("$($parent.FullName)\$($packageName)\","")

            if ($file.Contains("MyGet.Dep.dll")){
                # Skip
            }
            elseif ($packageName.StartsWith($myget_contents)){
                if($file.StartsWith($content)){
                    $binFile = $file.Replace($content,"")
                    Copy-File $_.FullName "$sbx\$($binFile)"
                }
            }
            elseif ($file.StartsWith($lib_net472)){
                $binFile = $file.Replace($lib_net472,"")
                Copy-File $_.FullName "$sbx\$bin\$($binFile)"
            } 
            elseif ($file.StartsWith($lib_netstandard20)){
                $binFile = $file.Replace($lib_netstandard20,"")
                Copy-File $_.FullName "$sbx\$bin\$($binFile)"
            }
            elseif ($file.StartsWith($lib_netother)){
                # Skip
            }
            elseif ($file.StartsWith($lib_portable)){
                # Skip
            }
            elseif ($file.StartsWith($lib)) {
                $binFile = $file.Replace($lib,"")
                Copy-File $_.FullName "$sbx\$bin\$($binFile)"
            } 
            elseif ($file.StartsWith($content)) {
                $binFile = $file.Replace($content,"")
                Copy-File $_.FullName "$sbx\$bin\$($binFile)"
            }      
        }
    }

}

function Copy-File {
    param($fileFrom, $fileTo)
    New-Item $fileTo -force
    Copy-Item $fileFrom $fileTo  
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
