function Run {
    param (
        $args,
        $info
    )
    
    $lib_net472 = "lib\net472\"
    $lib_netstandard20 = "lib\netstandard2.0\"
    $lib_netother = "lib\net"
    $lib_portable = "lib\portable-"
    $lib = "lib\"
    $content = "content\"

    $sbx = "sbx"
    $bin = "bin"

    if(Test-Path ..\$sbx\$bin) {
        Remove-Item ..\$sbx\$bin -r -force
    }

    ls ..\pkg -Directory | % {

        $parent = $_.Parent
        $packageName = $_.Name

        # sbx\bin
        ls $_.FullName -r -File -exclude "*.nupkg" | % {
            
            $file = ($_.FullName).Replace("$($parent.FullName)\$($packageName)\","")

            if ($file.StartsWith($lib_net472)){
                $binFile = $file.Replace($lib_net472,"")
                Copy-File $_.FullName "$($parent.Parent.FullName)\$sbx\$bin\$($binFile)"
            } 
            elseif ($file.StartsWith($lib_netstandard20)){
                $binFile = $file.Replace($lib_netstandard20,"")
                Copy-File $_.FullName "$($parent.Parent.FullName)\$sbx\$bin\$($binFile)"
            }
            elseif ($file.StartsWith($lib_netother)){
                # Skip
            }
            elseif ($file.StartsWith($lib_portable)){
                # Skip
            }
            elseif ($file.StartsWith($lib)) {
                $binFile = $file.Replace($lib,"")
                Copy-File $_.FullName "$($parent.Parent.FullName)\$sbx\$bin\$($binFile)"
            } 
            elseif ($file.StartsWith($content)) {
                $binFile = $file.Replace($content,"")
                Copy-File $_.FullName "$($parent.Parent.FullName)\$sbx\$bin\$($binFile)"
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
