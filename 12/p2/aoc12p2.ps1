$In = (Get-Content -Path .\input.txt -Raw)

[int]$Result = 0;
$seen = @{}
$sides = @{}

$rows = $In.Split("`n")

$Map = @()
for ($x = 0; $x -lt $rows.Length; $x++) {
    if ($rows[$x] -eq "") {continue}
    $row = $rows[$x].Trim().ToCharArray()
    $Map += ,$row
}

function Sides ($x, $y, $Plant, $r) {
    if (-not $sides.ContainsKey("$Plant-$r")) {

        $sides."$Plant-$r" = ,@($x,$y)
        #[console]::WriteLine("found for $Plant at $x $y with rotation $r - Counted")
        return 1

    } else {

        $found = 0
        foreach ($item in $sides."$Plant-$r") {
            $sx = $item[0]
            $sy = $item[1]
            if (($sx -eq $x -and ($sy-1 -eq $y -or $sy+1 -eq $y)) -or `                ($sy -eq $y -and ($sx-1 -eq $x -or $sx+1 -eq $x)) ) {
                
                $found++
            }
        }

        $sides."$Plant-$r" += ,@($x,$y)
        if ($found -eq 0) {
            $ret = 1
            #[console]::WriteLine("found for $Plant at $x $y with rotation $r - Counted")
        } elseif ($found -eq 1) {
            $ret = 0
            #[console]::WriteLine("found for $Plant at $x $y with rotation $r")
        } else {
            $ret = 1-$found
            #[console]::WriteLine("found for $Plant at $x $y with rotation $r - Subtracted $ret")
        } 
        return $ret

    }
}

function Solve ($x, $y, $plant, $r) {

    
    $currentplant = $Map[$x][$y].ToString()
    
    

    if ($seen.ContainsKey("$plant-$x-$y")) {
        return 0,0
    } elseif ($plant -eq $currentplant) {
        
        $seen."$plant-$x-$y" = $true

        $Area = 1;
        $Perimeter = 0;
        
        if ($x + 1 -lt $Map.Length) {
            $a,$b = Solve -x ($x + 1) -y $y -plant $plant -r 1
            $Area += $a
            $Perimeter += $b
        } else {
            $Perimeter += Sides -x ($x + 1) -y $y -plant $plant -r 1
        }
        if ($y + 1 -lt $Map[$x].Length) {
            $a,$b = Solve -x $x -y ($y + 1) -plant $plant -r 2
            $Area += $a
            $Perimeter += $b
        } else {
            $Perimeter += Sides -x $x -y ($y + 1) -plant $plant -r 2
        }
        if ($x - 1 -ge 0) {
            $a,$b = Solve -x ($x - 1) -y $y -plant $plant -r 3
            $Area += $a
            $Perimeter += $b
        } else {
            $Perimeter += Sides -x ($x - 1) -y $y -plant $plant -r 3
        }
        if ($y - 1 -ge 0) {
            $a,$b = Solve -x $x -y ($y - 1) -plant $plant -r 4
            $Area += $a
            $Perimeter += $b
        } else {
            $Perimeter += Sides -x $x -y ($y - 1) -plant $plant -r 4
        }
        
        return $Area, $Perimeter
    } else {
        $Perimeter = Sides -x $x -y $y -plant $plant -r $r
        return 0,$Perimeter
    }
}

for ($x = 0; $x -lt $Map.Length; $x++) {
    for ($y = 0; $y -lt $Map[$x].Length; $y++) {
        $Plant = $Map[$x][$y].ToString()
        $Area, $Perimeter = Solve -x $x -y $y -plant $Plant
        if ($Area -and $Perimeter) {
            [console]::WriteLine("$Plant at $x $y with $Area + $Perimeter $($Area * $Perimeter)")
            $Result += $Perimeter * $Area
        } else {
            #[console]::WriteLine("$Plant at $x $y was skipped")
        }
    }
}

$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8
