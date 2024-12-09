$In = (Get-Content -Path .\input.txt -Raw)

[int64]$Result = 0

$diskmap = $In.Trim().ToCharArray();
$files = @();
$empty = @();

for ($i = 0; $i -lt $diskmap.Length; $i++) { 
    if ($i % 2 -eq 0) {
        $files += [int]$diskmap[$i].ToString()
    } else {
        $empty += [int]$diskmap[$i].ToString()
    }
}

$disklayout = @();

# Create the initial disk layout
for ($i = 0; $i -lt $files.Length; $i++) {
    $fileLength = [int]$files[$i]
    $emptyLength = [int]$empty[$i]
    for ($j = 0; $j -lt $fileLength; $j++) { 
        $disklayout += $i
    }
    for ($j = 0; $j -lt $emptyLength; $j++) { 
        $disklayout += "."
    }
}

$ns = 0
for ($i = $disklayout.Length - 1; $i -ge 0; $i--) {
    if ($disklayout[$i] -ne '.') {
        # Find the first empty slot from the left
        for ($j = $ns; $j -lt $i; $j++) {
            if ($disklayout[$j] -eq '.') {
                # Move the file block to the empty slot
                $disklayout[$j] = $disklayout[$i]
                $disklayout[$i] = '.'
                #$disklayout -join ""
                break
            }
        }
        $ns = $j
    }
}

# Calculate the checksum
[int64]$Checksum = 0
for ($i = 0; $i -lt $disklayout.Length; $i++) {
    if ($disklayout[$i] -ne '.') {
        $Checksum += $i * [int]$disklayout[$i].ToString()
    }
}

# Output the checksum to a file
$Checksum | Set-Content -Path .\out.txt -Encoding UTF8

# Print the checksum to the console
Write-Output "Checksum: $Checksum"
