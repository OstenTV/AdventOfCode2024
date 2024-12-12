$In = (Get-Content -Path .\input.txt -Raw)

[int]$Result = 0;
$seen = @{};

$rows = $In.Split("`n")

$Map = @()
for ($x = 0; $x -lt $rows.Length; $x++) {
    if ($rows[$x] -eq "") {continue}
    $row = $rows[$x].Trim().ToCharArray()
    $Map += ,$row
}

function Solve ($x, $y, $plant) {
    $currentplant = $Map[$x][$y].ToString()

    if ($seen.ContainsKey("$plant-$x-$y")) {
        return 0,0
    } elseif ($plant -eq $currentplant) {
        
        $seen."$plant-$x-$y" = $true

        $Area = 1;
        $Perimeter = 0;
        
        if ($x + 1 -lt $Map.Length) {
            $a,$b = Solve -x ($x + 1) -y $y -plant $plant
            $Area += $A
            $Perimeter += $b
        } else {
            $Perimeter++
        }
        if ($y + 1 -lt $Map[$x].Length) {
            $a,$b = Solve -x $x -y ($y + 1) -plant $plant
            $Area += $A
            $Perimeter += $b
        } else {
            $Perimeter++
        }
        if ($x - 1 -ge 0) {
            $a,$b = Solve -x ($x - 1) -y $y -plant $plant
            $Area += $A
            $Perimeter += $b
        } else {
            $Perimeter++
        }
        if ($y - 1 -ge 0) {
            $a,$b = Solve -x $x -y ($y - 1) -plant $plant
            $Area += $A
            $Perimeter += $b
        } else {
            $Perimeter++
        }
        
        return $area,$Perimeter
    } else {
        return 0,1
    }
}

for ($x = 0; $x -lt $Map.Length; $x++) {
    for ($y = 0; $y -lt $Map[$x].Length; $y++) {
        $Plant = $Map[$x][$y].ToString()
        $Area, $Perimeter = Solve -x $x -y $y -plant $Plant
        if ($Area -and $Perimeter) {
            [console]::WriteLine("$Plant at $x $y with $Area $Perimeter")
            $Result += $Perimeter*$Area
        } else {
            #[console]::WriteLine("$Plant at $x $y was skipped")
        }
        
    }
}

$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8
