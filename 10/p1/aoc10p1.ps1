$In = (Get-Content -Path .\input.txt -Raw)

[int]$Result = 0;

$rows = $In.Split("`n")

$Map = @()
for ($x = 0; $x -lt $rows.Length; $x++) {
    if ($rows[$x] -eq "") {continue}
    $row = $rows[$x].Trim().ToCharArray()
    $Map += ,$row
}

function Check-TrailPosition ($x, $y, $height) {
    $currentheight = [int]$Map[$x][$y].ToString()
    $searchheight = $height+1
    if ($currentheight -eq $searchheight) {
        
        if ($currentheight -eq 9) {
            if (!($seen.ContainsKey("$x-$y"))) {
                $seen."$x-$y" = $true
                return 1
            } else {
                return 0
            }
        }

        $Count = 0;
        
        if ($x + 1 -lt $Map.Length) {
            $Count += Check-TrailPosition -x ($x + 1) -y $y -height $currentheight
        }
        if ($y + 1 -lt $Map[$x].Length) {
            $Count += Check-TrailPosition -x $x -y ($y + 1) -height $currentheight
        }
        if ($x - 1 -ge 0) {
            $Count += Check-TrailPosition -x ($x - 1) -y $y -height $currentheight
        }
        if ($y - 1 -ge 0) {
            $Count += Check-TrailPosition -x $x -y ($y - 1) -height $currentheight
        }
        return $Count
    } else {
        return 0
    }
}

for ($x = 0; $x -lt $Map.Length; $x++) {
    for ($y = 0; $y -lt $Map[$x].Length; $y++) { 
        if ([int]$Map[$x][$y].ToString() -eq 0) {
            $seen = @{};
            $Result += Check-TrailPosition -x $x -y $y -height (-1)
        }
    }
}


$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8
