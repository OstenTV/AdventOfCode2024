$In = (Get-Content -Path .\input.txt -Raw)

[int]$Result = 0

# Split the input into rows
$grid = $In.Split("`n")

for ($i = 0; $i -lt $grid.Length - 3; $i++) {
    for ($j = 0; $j -lt $grid[$i].Length - 2; $j++) {
        # Extract 3x3 subgrid
        $sub1 = $grid[$i].Substring($j, 3)
        $sub2 = $grid[$i + 1].Substring($j, 3)
        $sub3 = $grid[$i + 2].Substring($j, 3)

        if ($sub2[1] -eq 'A' -and $sub1[0] -eq 'M' -and $sub1[2] -eq 'M' -and $sub3[0] -eq 'S' -and $sub3[2] -eq 'S') {$Result++}
        if ($sub2[1] -eq 'A' -and $sub1[0] -eq 'S' -and $sub1[2] -eq 'S' -and $sub3[0] -eq 'M' -and $sub3[2] -eq 'M') {$Result++}
        if ($sub2[1] -eq 'A' -and $sub1[0] -eq 'S' -and $sub1[2] -eq 'M' -and $sub3[0] -eq 'S' -and $sub3[2] -eq 'M') {$Result++}
        #if ($sub2[1] -eq 'A' -and $sub1[0] -eq 'S' -and $sub1[2] -eq 'M' -and $sub3[0] -eq 'M' -and $sub3[2] -eq 'S') {$Result++}
        #if ($sub2[1] -eq 'A' -and $sub1[0] -eq 'M' -and $sub1[2] -eq 'S' -and $sub3[0] -eq 'S' -and $sub3[2] -eq 'M') {$Result++}
        if ($sub2[1] -eq 'A' -and $sub1[0] -eq 'M' -and $sub1[2] -eq 'S' -and $sub3[0] -eq 'M' -and $sub3[2] -eq 'S') {$Result++}

    }

}

$Result

$Result | Set-Content -Path .\out.txt -Encoding UTF8
