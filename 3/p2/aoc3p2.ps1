$In = (Get-Content -Path .\in.txt -Raw)

[int]$Result = 0;

# Define the regex pattern
$pattern = "mul\((\d+),(\d+)\)|don't\(\)|do\(\)"

# Find all matches
$matches = [regex]::Matches($In, $pattern)

$do = $true

# Output the matches
foreach ($match in $matches) {
    if ( ($do -eq $true) -and ($match.Groups[0].Value -match "mul")) {
        [int]$number1 = $match.Groups[1].Value
        [int]$number2 = $match.Groups[2].Value
        Write-Output "First number: $number1, Second number: $number2"
        $n3 = $number1 * $number2;
        $Result += $n3;
    } elseif ($match.Groups[0].Value -eq "don't()") {
        Write-Output "Found: don't()"
        $do = $false
    } elseif ($match.Groups[0].Value -eq "do()") {
        Write-Output "Found: do()"
        $do = $true
    }
}

$Result

$Result | Set-Content -Path .\out.txt -Encoding UTF8
