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
    $px = $machine.Prize.X
    $py = $machine.Prize.Y
    $ax = $machine.A.X
    $ay = $machine.A.Y
    $bx = $machine.B.X
    $by = $machine.B.Y

    $ia = 0
    $ib = 0
    
    do {
        $ia++
        $x = $ia * $ax
        $y = $ia * $ay
    } until ($x -ge $px -and $y -ge $py)
    $maxa = $ia
    do {
        $ib++
        $x = $ib * $ax
        $y = $ib * $ay
    } until ($x -ge $px -and $y -ge $py)
    $maxa = $ia
    $maxb = $ib

    $lowestcost = @(-1)
    for ($ai = 0; $ai -lt $maxa; $ai++) { 
        for ($bi = 0; $bi -lt $maxb; $bi++) {
            
            $cost = $ai * 3 + $bi
            if ($lowestcost[0] -ne -1 -and $cost -ge $lowestcost[0]) {break}

            if ($px -eq ($ax * $ai + $bx * $bi) -and $py -eq ($ay * $ai + $by * $bi) ) {
                $lowestcost = @($cost,$ai,$bi)
            }

        }
    }
    if ($lowestcost[0] -ne -1) {
        [console]::WriteLine("Target $px $py with A $($lowestcost[1]) B $($lowestcost[2]) cost $($lowestcost[0])")
        $Result+=$lowestcost[0]
    }
    
}

$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8
