$In = (Get-Content -Path .\in.txt -Raw)

[int]$Result = 0;

# Define the regex pattern
$pattern = "mul\((\d+),(\d+)\)"

# Find all matches
$matches = [regex]::Matches($In, $pattern)

# Output the matches
foreach ($match in $matches) {
    [int]$number1 = $match.Groups[1].Value
    [int]$number2 = $match.Groups[2].Value
    Write-Output "First number: $number1, Second number: $number2"
    $n3 = $number1 * $number2;

    $Result += $n3;
}

$Result

$Result | Set-Content -Path .\out.txt -Encoding UTF8
