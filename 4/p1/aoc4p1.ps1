$In = (Get-Content -Path .\input.txt -Raw)
$WordArray = "XMAS".ToCharArray();

[int]$Result = 0;

$rows = $In.Split("`n")

$Map = @()
for ($x = 0; $x -lt $rows.Length; $x++) { 
    $row = $rows[$x].ToCharArray()
    $Map += ,$row
}

function Check-WordMap ($x, $y, $d, $i) {
    $ltr = $Map[$x][$y]
    $SearchLtr = $WordArray[$i]
    if ($ltr -eq $SearchLtr) {
        $Count = 0;
        if ($i -eq ($WordArray.Count)-1) {
            return 1
        }
        $i++;

        if ($d -eq 1 -or $d -eq 0) {
            if ($x + 1 -lt $Map.Length) {
                $Count += Check-WordMap -x ($x + 1) -y $y -d 1 -i $i
            }
        }
        if ($d -eq 2 -or $d -eq 0) {
            if ($x + 1 -lt $Map.Length -and $y + 1 -lt $Map[$x].Length) {
                $Count += Check-WordMap -x ($x + 1) -y ($y + 1) -d 2 -i $i
            }
        }
        if ($d -eq 3 -or $d -eq 0) {
            if ($y + 1 -lt $Map[$x].Length) {
                $Count += Check-WordMap -x $x -y ($y + 1) -d 3 -i $i
            }
        }
        if ($d -eq 4 -or $d -eq 0) {
            if ($x - 1 -ge 0 -and $y + 1 -lt $Map[$x].Length) {
                $Count += Check-WordMap -x ($x - 1) -y ($y + 1) -d 4 -i $i
            }
        }
        if ($d -eq 5 -or $d -eq 0) {
            if ($x - 1 -ge 0) {
                $Count += Check-WordMap -x ($x - 1) -y $y -d 5 -i $i
            }
        }
        if ($d -eq 6 -or $d -eq 0) {
            if ($x - 1 -ge 0 -and $y - 1 -ge 0) {
                $Count += Check-WordMap -x ($x - 1) -y ($y - 1) -d 6 -i $i
            }
        }
        if ($d -eq 7 -or $d -eq 0) {
            if ($y - 1 -ge 0) {
                $Count += Check-WordMap -x $x -y ($y - 1) -d 7 -i $i
            }
        }
        if ($d -eq 8 -or $d -eq 0) {
            if ($x + 1 -lt $Map.Length -and $y - 1 -ge 0) {
                $Count += Check-WordMap -x ($x + 1) -y ($y - 1) -d 8 -i $i
            }
        }
        return $Count
    } else {
        return 0
    }
}

for ($x = 0; $x -lt $Map.Length; $x++) {
    for ($y = 0; $y -lt $Map[$x].Length; $y++) { 
        $Result += Check-WordMap -x $x -y $y -d 0 -i 0
    }
}


$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8
