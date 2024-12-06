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

$Position = @()
$StartingPos = @()
$GuardFound = $false
for ($x = 0; $x -lt $Map.Length; $x++) {
    for ($y = 0; $y -lt $Map[$x].Length; $y++) { 
        if ($Map[$x][$y] -eq $Guard) {
            $StartingPos = $x,$y
        }
    }
}

# Function to deep clone the map
function Clone-Map {
    param (
        [array]$map
    )
    $newMap = @()
    foreach ($row in $map) {
        $newMap += ,($row.Clone())
    }
    return $newMap
}

$SaveGame = Clone-Map -map $Map  # Ensure the initial map state is deeply cloned

$LoopCounter = 0

for ($tryX = 0; $tryX -lt $Map.Length; $tryX++) {
    for ($TryY = 0; $TryY -lt $Map[$tryX].Length; $TryY++) {  # Corrected typo

        $Map = Clone-Map -map $SaveGame  # Deep clone the saved game state
        $Direction = 0
        $Counter = 0
        $Retry = 0
        $Inside = $true
        $Position = $StartingPos

        $sx = $StartingPos[0]
        $sy = $StartingPos[1]

        if ($Map[$tryX][$TryY] -ne $Guard) {
            $Map[$tryX][$TryY] = $Obstacle
        }

        while ($Inside) {
            
            $Looping = $false

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
            if ($newY -ge 0 -and $newY -lt $Map[$newX].Length -and $newX -ge 0 -and $newX -lt $Map.Length) {  # Corrected boundary check
        
                if ($Map[$newX][$newY] -eq $Obstacle) {
                    if ($Retry -ge 10000) {
                        # Means we are stuck in a loop
                        $Looping = $true
                        break
                    } else {
                        $Direction++
                        if ($Direction -ge 4) { $Direction = 0 }
                        continue
                    }
            
                }

                $Position = $newX,$newY
                if ($Map[$newX][$newY] -ne $Used) {
                    $Map[$newX][$newY] = $Used
                    $Counter++
                }
        
            } else {
                $Inside = $false
            }
            $Retry++

        }
        
        #$Map | % {$_ -join ""}
        #Write-Host
        if ($Looping) {
            Write-Host "Loop detected at position ($tryX, $TryY)"
            $LoopCounter++
        } else {
            Write-Host "No Loop detected at position ($tryX, $TryY)"
        }

    }
}

$LoopCounter
$LoopCounter | Set-Content -Path .\out.txt -Encoding UTF8
