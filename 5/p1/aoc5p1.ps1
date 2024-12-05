$In = (Get-Content -Path .\sample.txt -Raw)

[int]$Result = 0
$Rules = @()
$Updates = @()
$Correct = @()

function Test-RuleUpdate ($Update, $i) {
    $n = $Update[$i]
    foreach ($Rule in $Rules) {
        [int]$x = $Rule[0]
        [int]$y = $Rule[1]
        if ($x -eq $n) {
            for ($z = 0; $z -lt ($Update.Length); $z++) {
                $nz = $Update[$z]
                if ($y -eq $nz) {
                    if ($z -lt $i) {
                        return -1
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
    $CorrectUpdate = @()
    $skip = $false
    for ($i = 0; $i -lt ($Update.Length); $i++) {
        if ((Test-RuleUpdate -Update $Update -i $i) -ne -1) {
            $CorrectUpdate += $Update[$i]
        } else {
            $skip = $true
            break
        }
    }
    if ($skip) {continue}
    $Correct += ,$CorrectUpdate
}

for ($c = 0; $c -lt ($Correct.Length); $c++) {
    $l = $Correct[$c].Length
    $m = [int](($l-1)/2)
    $Result += [int]$Correct[$c][$m]
}

$Result

$Result | Set-Content -Path .\out.txt -Encoding UTF8
