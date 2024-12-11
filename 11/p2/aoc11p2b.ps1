$In = (Get-Content -Path .\sample.txt -Raw)

[int64]$Result = 0;
$depth = 25

$Stones = $In.Trim().Split() | % {[int]$_}
Write-Host "$($stones -join " ")"

$jobs = @();

for ($i = 0; $i -lt ($Stones.Length); $i++) {
    Write-Host "Processing #$i"
    $jobs += Start-Job -ScriptBlock {
        param ($Stone, $depth)

        function Engrave-Stone ([string]$Stone,[int]$i) {
            [int]$Count = 0

            if ($i -ge $depth) {
                return 1
            }
            $i++

            if ($seen.containskey($stone)) {
    
                $cached = $seen.$stone
                foreach ($r in $cached) {
                    $Count += Engrave-Stone -Stone $r -i $i
                }

            } else {
        
                $key = $stone
                [string]$Stone = [int64]$Stone
        
                switch ($Stone) {
                    "0" {
                        $seen.$key = @("1")
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
                        $seen.$key = @($s1,$s2)
                        $Count += Engrave-Stone -Stone $s1 -i $i
                        $Count += Engrave-Stone -Stone $s2 -i $i
                    }
                    Default {
                        $calc = ([int64]$Stone*2024)
                        $seen.$key = @($calc)
                        $Count += Engrave-Stone -Stone $calc -i $i
                    }
                }
            }
            [console]::WriteLine("Returned at $i")
            return $Count
        }

        $seen = @{};
        $amount = Engrave-Stone -Stone $Stone -i 0

        [PSCustomObject]@{
            Amount=$amount
        }
        
    } -ArgumentList $Stones[$i], $depth
}

# Wait for all jobs to complete
$jobs | ForEach-Object { $_ | Wait-Job }

# Collect results
$results = $jobs | ForEach-Object { $_ | Receive-Job }

$jobs | Remove-Job

$results | % {$Result+=$_.Amount}

write-host $Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8
