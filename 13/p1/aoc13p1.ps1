$In = (Get-Content -Path .\sample.txt -Raw)

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


function Solve ($machine, $i=0, $x=0, $y=0, $steps="", $ia=0, $ib=0) {

    $px = $machine.Prize.X
    $py = $machine.Prize.Y
    $ax = $machine.A.X
    $ay = $machine.A.Y
    $bx = $machine.B.X
    $by = $machine.B.Y

    if (($tries.containskey("$ia-$ib")) -or ($Global:lowest -ne -1 -and $Global:lowest -lt $i)) {
        return
    } elseif ($x -eq $px -and $y -eq $py) {
        [console]::WriteLine("Reached $x $y with $i steps")
        $Global:lowest = $i
        return $i
    } elseif ($x -gt $px -or $y -gt $py) {
        [console]::WriteLine("Stepped over $px $py with $x $y with $i steps")
        [console]::WriteLine("$steps")
        $tries."$ia-$ib" = $true
        return
    } else {
        $ret = @();
        $ret += Solve -machine $machine -x ($y+$ax) -y ($y+$ay) -i ($i+1) -steps "$($steps)B" -ia ($ia+1) -ib $ib
        $ret += Solve -machine $machine -x ($x+$ax) -y ($y+$ay) -i ($i+3) -steps "$($steps)A" -ib ($ib+1) -ia $ia
        return $ret
    }

}

foreach ($machine in $parsedData) {
    $Global:lowest = -1
    $tries= @{}
    $steps = Solve -machine $machine
    $shortest = ($steps | Sort-Object)[0]
    $Result += $shortest
}

$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8
