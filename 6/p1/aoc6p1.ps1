$In = (Get-Content -Path .\input.txt -Raw)
$WordArray = "XMAS".ToCharArray();

[int]$Result = 0;
$Ground = "."
$Obstacle = "#"
$Guard = "^"
$Used = "X"

$rows = $In.Split("`n")

$Map = @()
for ($x = 0; $x -lt $rows.Length; $x++) { 
    $row = $rows[$x].ToCharArray()
    $Map += ,$row
}

for ($x = 0; $x -lt $Map.Length; $x++) {
    for ($y = 0; $y -lt $Map[$x].Length; $y++) { 
        if ($map[$x][$y] -eq $Guard) {
            $Position = $x,$y
            break
        }
    }
}

$Minimap = $map.Clone()
$Inside = $true
$Direction = 0
$Counter = 0
while ($Inside) {
    $x = $Position[0]
    $y = $Position[1]
    
    switch ($Direction)
    {
        0 { $newX = $x-1; $newY = $y }
        1 { $newX = $x; $newY = $y+1 }
        2 { $newX = $x+1; $newY = $y }
        3 { $newX = $x; $newY = $y-1 }
        Default {}
    }
    if ($newY -ge 0 -and $newY -lt $Map.Length -and $newX -ge 0 -and $newX -lt $Map[$y].Length-1) {
        
        
        if ($Map[$newX][$newY] -eq $Obstacle) {
            $Direction++
            if ($Direction -gt 4) { $Direction = 0 }
            continue
        }

        $Position = $newX,$newY
        if ($Minimap[$newX][$newY] -ne $Used) {
            $Minimap[$newX][$newY] = $Used
            $Minimap | % {$_ -join ""}
            Write-Host
            $Counter++
        }
        
    } else {
        $inside = $false
    }
}

$Counter
$Counter | Set-Content -Path .\out.txt -Encoding UTF8
