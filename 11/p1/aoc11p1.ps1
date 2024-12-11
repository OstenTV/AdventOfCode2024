$In = (Get-Content -Path .\input.txt -Raw)

[int]$Result = 0;

$Stones = $In.Trim().Split() | % {[int]$_}
Write-Host "0 : $($stones -join " ")"

for ($i = 1; $i -le 25; $i++) {
    $New = @();
    foreach ($Stone in $Stones) {
        [string]$Stone = $Stone
        switch ($Stone)
        {
            "0" {
                $New += 1
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
                $New += [int64]$s1,[int64]$s2
            }
            Default {
                $New += [int64]$Stone * 2024
            }
        }
    }
    $Stones = $New
    if ($i -lt 10) {
        Write-Host "$i : $($stones -join " ")"
    } else {
        Write-Host "$i : $($stones.Count)"
    }
}

$Result = $stones.Count
$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8
