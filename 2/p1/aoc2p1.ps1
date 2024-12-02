$In = (Get-Content -Path .\in.txt -Raw)

[int]$Result = 0;

function Is-Safe ($Split) {
    $Safe = $true
    $Order = 0
    for ($i = 0; $i -lt ($Split.Count); $i++) {
        [int]$n = $Split[$i]
        
        if ($i -eq 0) {
            # Do nothing.
        } elseif ($n -gt $p) {
            switch ($Order) {
                0 {$Order = 1}
                1 {}
                2 {$Safe = $false; break}
            }
            [int]$d = $n - $p
        } elseif ($n -lt $p) {
            switch ($Order) {
                0 {$Order = 2}
                1 {$Safe = $false; break}
                2 {}
            }
            [int]$d = $p - $n
        } else {
            $Safe = $false
            break
        }

        if (($i -ne 0) -and (($d -gt 3) -or ($d -lt 1))) {
            $Safe = $false
            break
        }

        $p = $n
    }
    return $Safe
}

foreach ($line in $In.Split("`n")) {
    if ($line -eq "") { continue }
    $Split = $line.Replace(" ", ",").Split(",")
    
    Write-Host $line -NoNewline

    if (Is-Safe -Split $Split) {
        Write-Host " Safe"
        $Result++
    } else {
        Write-Host " Unsafe"
    }
}

$Result

$Result | Set-Content -Path .\out.txt -Encoding UTF8
