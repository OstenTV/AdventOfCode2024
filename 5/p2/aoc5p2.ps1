$In = (Get-Content -Path .\sample.txt -Raw)

[int]$Result = 0
$Rules = @()
$Updates = @()

function Test-RuleUpdate ($Update, $i) {
    $n = $Update[$i]
    foreach ($Rule in $Rules) {
        $x = $Rule[0]
        $y = $Rule[1]
        if ($x -eq $n) {
            for ($z = 0; $z -lt ($Update.Length); $z++) {
                $nz = $Update[$z]
                if ($y -eq $nz) {
                    if ($z -lt $i) {
                        return -1
                    } elseif ($z -gt $i) {
                        return 1
                    }
                }
            }
        }
    }
    return 0
}

foreach ($line in $In.Split("`n")) {
    if ($line -eq "") { continue }
    
    if ($line -like "*|*") {
        $Split = $line.Split("|")
        $x = $Split[0]
        $y = $Split[1]
        $Rules += ,@($x,$y)
    } elseif ($line -like "*,*") {
        $Split = $line.Split(",")
        $Updates += ,$Split
    }
}

foreach ($Update in $Updates) {
    $sorted = $false
    while (-not $sorted) {
        $sorted = $true
        for ($i = 0; $i -lt ($Update.Length - 1); $i++) {
            $d = Test-RuleUpdate -Update $Update -i $i
            if ($d -lt 0) {
                # Move the element to the right
                $temp = $Update[$i]
                $Update[$i] = $Update[$i + 1]
                $Update[$i + 1] = $temp
                $sorted = $false
            }
        }
    }
    Write-Host "Reordered Update: $($Update -join ',')"
}


foreach ($Update in $Updates) {
    $l = $Update.Length
    $m = [int](($l-1)/2)
    $Result += [int]$Update[$m]
}

$Result

$Result | Set-Content -Path .\out.txt -Encoding UTF8
