measure-command {

$In = (Get-Content -Path .\input.txt -Raw)

[int64]$Result = 0;
$depth = 75
$seen = @{};
[int64]$global:calls = 0
[int64]$global:saved = 0

$Stones = $In.Trim().Split() | % {[int]$_}
Write-Host "$($stones -join " ")"

function Engrave-Stone ([string]$Stone,[int]$i) {
    [int64]$Count = 0
    $key = "$i-$stone"
    
    if ($i -ge $depth) {
        return 1
    }
    $i++

    if ($seen.containskey($key)) {
    
        $Count = $seen.$key
        $global:saved += $Count
        #[Console]::WriteLine("GET $($global:saved) $key $Count")

    } else {
        
        [string]$Stone = [int64]$Stone
        switch ($Stone) {
            "0" {
                $Count += Engrave-Stone -Stone "1" -i $i
            }
            {$Stone.Length % 2 -eq 0} {
                $h = $Stone.Length / 2
                $s1 = ""
                $s2 = ""
                for ($j = 0; $j -lt $Stone.Length; $j++) {
                    if ($j -lt $h) {
                        $s1 += $stone[$j]
                    } else {
                        $s2 += $stone[$j]
                    }
                }
                $Count += Engrave-Stone -Stone $s1 -i $i
                $Count += Engrave-Stone -Stone $s2 -i $i
            }
            Default {
                $Count += Engrave-Stone -Stone ([int64]$Stone*2024) -i $i
            }
        }
        $seen.$key = $Count
        $global:calls++
        #[Console]::WriteLine("PUT $($global:calls) $key $Count")
    }
    return $Count
}

for ($i = 0; $i -lt ($Stones.Length); $i++) {
    Write-Host "Processing #$i"
    $Result += Engrave-Stone -Stone $Stones[$i]
}

write-host $Result
Write-Host "Saved $((($Global:saved)/($Global:calls)-($global:calls))*3.02653/60/24/365) years"
$Result | Set-Content -Path .\out.txt -Encoding UTF8

}