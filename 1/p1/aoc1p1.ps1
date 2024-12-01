$In = (Get-Content -Path .\in.txt -Raw)

[int]$Result = 0;

$l1 = @()
$l2 = @()

foreach ($line in $In.Split("`n")){
    if ($line -eq "") {continue}
    $Split = $line.Replace("   ",",").Split(",");
    $l1 += [int]$Split[0]
    $l2 += [int]$Split[1]
}

$l1 = $l1 | Sort-Object
$l2 = $l2 | Sort-Object

for ($i = 0; $i -lt ($l1.Count); $i++)
{ 
    $n1 = $l1[$i]
    $n2 = $l2[$i]
    if ($n1 -ge $n2) {
        $d = $n1 - $n2
    } else {
        $d = $n2 - $n1
    }

    $Result += $d;

}

$Result

$Result | Set-Content -Path .\out.txt -Encoding UTF8