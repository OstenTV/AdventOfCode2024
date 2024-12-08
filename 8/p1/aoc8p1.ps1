$In = (Get-Content -Path .\input.txt -Raw)

[int]$Result = 0
$Ground = "."

$rows = $In.Split("`n")

$Map = @()
for ($x = 0; $x -lt $rows.Length; $x++) {
    if ($rows[$x] -eq "") {continue}
    $row = $rows[$x].Trim().ToCharArray()
    $Map += ,$row
}

$Antinodes = @{}

function Add-Antinode {
    param (
        [int]$x,
        [int]$y
    )
    if ($x -ge 0 -and $x -lt $Map.Length -and $y -ge 0 -and $y -lt $Map[0].Length) {
        $key = "$x,$y"
        $Antinodes[$key] = $true
    }
}

# Make a list of unique freq and their locations.
$P = @{}
for ($x = 0; $x -lt $Map.Length; $x++) {
    for ($y = 0; $y -lt $Map[$x].Length; $y++) {
        $freq = $Map[$x][$y]
        if ($freq -ne $Ground) {
            $P[$freq] += ,@($x, $y)
        }
    }
}

# Loop through each freq.
foreach ($freq in $P.Keys) {
    $vs = $P[$freq]

    # Loop through the 1st freq positions
    for ($i = 0; $i -lt $vs.Length; $i++) {
        $x1, $y1 = $vs[$i]

        # Loop through the 2nd freq positions
        for ($j = 0; $j -lt $vs.Length; $j++) {
            if ($i -eq $j) { continue }
            $x2, $y2 = $vs[$j]

            # Loop through the entire map to look for spots for antinodes
            for ($x = 0; $x -lt $Map.Length; $x++) {
                for ($y = 0; $y -lt $Map[$x].Length; $y++) {
                    
                    # Calculate the distance frrom the current position to the 2 positions of freq
                    $d1 = [math]::Abs($x - $x1) + [math]::Abs($y - $y1) # The total distance from current position to freq 1
                    $d2 = [math]::Abs($x - $x2) + [math]::Abs($y - $y2) # The total distance from current position to freq 2
                    $dx1 = $x - $x1 # Distance of the current x to the position of freq1 x
                    $dy1 = $y - $y1 # Distance of the current y to the position of freq1 y
                    $dx2 = $x - $x2 # Distance of the current x to the position of freq2 x
                    $dy2 = $y - $y2 # Distance of the current y to the position of freq2 y
                    
                    # Check the freq have twice the distance. We know the current position is in line with both freq if we multiply the two freq diagonally.
                    if (($d1 -eq 2 * $d2 -or 2 * $d1 -eq $d2) -and ($dx1 * $dy2 -eq $dy1 * $dx2)) {
                        Add-Antinode -x $x -y $y
                    }
                }
            }
        }
    }
}

# Just print the map for debugging
$Map | % {$_ -join ""}
write-host
for ($x = 0; $x -lt $Map.Length; $x++) {
    for ($y = 0; $y -lt $Map[$x].Length; $y++) {
        if ($Antinodes.ContainsKey("$x,$y")) {
            $Map[$x][$y] = "#"
        }
    }
}
$Map | % {$_ -join ""}

$TotalCount = $Antinodes.Keys.Count
$TotalCount
$TotalCount | Set-Content -Path .\out.txt -Encoding UTF8
