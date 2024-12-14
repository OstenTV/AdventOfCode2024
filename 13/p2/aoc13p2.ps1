$In = (Get-Content -Path .\input.txt -Raw)

[int]$Result = 0;

# Regular expression to match the required pattern
$regex = [regex] 'Button A: X\+(?<Ax>\d+), Y\+(?<Ay>\d+)\s+Button B: X\+(?<Bx>\d+), Y\+(?<By>\d+)\s+Prize: X=(?<Px>\d+), Y=(?<Py>\d+)'

# Array to hold the parsed data
$parsedData = @()

# Match the input string against the regex
foreach ($match in $regex.Matches($In)) {
    $parsedData += @{
        A = @{ X = [int]$match.Groups['Ax'].Value; Y = [int]$match.Groups['Ay'].Value }
        B = @{ X = [int]$match.Groups['Bx'].Value; Y = [int]$match.Groups['By'].Value }
        Prize = @{ X = [int]$match.Groups['Px'].Value; Y = [int]$match.Groups['Py'].Value }
    }
}

foreach ($machine in $parsedData) {
    $px = $machine.Prize.X + 10000000000000
    $py = $machine.Prize.Y + 10000000000000
    $ax = $machine.A.X
    $ay = $machine.A.Y
    $bx = $machine.B.X
    $by = $machine.B.Y

    $maxax = [int64]($px / $ax)+1
    $maxay = [int64]($py / $ay)+1
    $maxa = ($maxax,$maxay | sort)[0]
    
    $maxbx = [int64]($px / $bx)+1
    $maxby = [int64]($py / $by)+1
    $maxb = ($maxbx,$maxby | sort)[0]

    $lowestcost = @(-1)
    for ($ai = 0; $ai -lt $maxa; $ai++) { 
        for ($bi = $maxb; $bi -ge 0; $bi--) {
            
            $posx = ($ax * $ai + $bx * $bi)
            $posy = ($ay * $ai + $by * $bi)

            if ($posx -lt $px -and $posy -lt $py) {
                break
            }

            $cost = $ai * 3 + $bi
            if ($lowestcost[0] -ne -1 -and $cost -ge $lowestcost[0]) {break}

            if ($px -eq $posx -and $py -eq $posy ) {
                $lowestcost = @($cost,$ai,$bi)
                #[console]::WriteLine("New path found for target $px $py with A $($lowestcost[1]) B $($lowestcost[2]) cost $($lowestcost[0])")
            }

        }
    }
    if ($lowestcost[0] -ne -1) {
        [console]::WriteLine("Lowest cost for target $px $py with A $($lowestcost[1]) B $($lowestcost[2]) cost $($lowestcost[0])")
        $Result+=$lowestcost[0]
    }
    
}

$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8
