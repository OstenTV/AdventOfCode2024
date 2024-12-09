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

$defrag = @();

# Create the initial disk layout
for ($i = 0; $i -lt $files.Length; $i++) {
    $fileLength = [int64]$files[$i]
    $emptyLength = [int64]$empty[$i]
    $defrag += ($i.ToString() * $fileLength)
    $defrag += '.' * $emptyLength
}

# Convert the array to a string
$defrag = -join $defrag

# Compact the disk map by moving file blocks from the end to the first available empty slots
$defrag = $defrag.ToCharArray()
for ($i = $defrag.Length - 1; $i -ge 0; $i--) {
    if ($defrag[$i] -ne '.') {
        # Find the first empty slot from the left
        for ($j = 0; $j -lt $i; $j++) {
            if ($defrag[$j] -eq '.') {
                # Move the file block to the empty slot
                $defrag[$j] = $defrag[$i]
                $defrag[$i] = '.'
                break
            }
        }
    }
}

# Calculate the checksum
$Checksum = 0
for ($i = 0; $i -lt $defrag.Length; $i++) {
    if ($defrag[$i] -ne '.') {
        $Checksum += $i * [int64]$defrag[$i].ToString()
    }
}

# Output the checksum to a file
$Checksum | Set-Content -Path .\out.txt -Encoding UTF8

# Print the checksum to the console
Write-Output "Checksum: $Checksum"
