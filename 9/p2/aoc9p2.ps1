Measure-Command {

$In = (Get-Content -Path .\input.txt -Raw)

[int64]$Result = 0

$diskmap = $In.Trim().ToCharArray();
$files = @();
$empty = @();

Write-Host "Scan diskmap . . . " -NoNewline
for ($i = 0; $i -lt $diskmap.Length; $i++) { 
    if ($i % 2 -eq 0) {
        $files += [int]$diskmap[$i].ToString()
    } else {
        $empty += [int]$diskmap[$i].ToString()
    }
}
Write-Host "Done."

$disklayout = @();

Write-Host "Initialize disklayout . . . " -NoNewline
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
Write-Host "Done."

Write-Host "Rearranging files . . . " -NoNewline
$js = 0
$is = $disklayout.Length
$actions = @(); # a list of actions we can use to debug.
$nfs = @{}; # When a spot of freespace is used, the length key and location value is added here. Then we can know that there are no spots of that size (ore bellow) are before this point.
:findData for ($i = $disklayout.Length - 1; $i -ge 0; $i--) {
    <#if ($disklayout[$i] -eq "2") {
        Write-Host "We have a $($disklayout[$i])"
    }#>
    if ($i -ge $is) {continue} # Make sure we continue untill the next file starts.

    # Check if we are at the start of a file
    if ($disklayout[$i] -ne '.') {
    
        # Find the end of the file
        for ($i1 = $i; $i1 -ge 0; $i1--) {
        
            # Check if we are at the end of the file
            if ($disklayout[($i1)] -ne $disklayout[($i1-1)]) { 

                # At this point we have a complete file between $i and $i1

                $datasize = $i-$i1+1
                
                # There is no reason to loop through the slots before this point, because we have previously used a slot of $datasize at this $j
                $start = if ($nfs.ContainsKey($datasize)) {$nfs.$datasize} else {0}

                :findEmpty for ($j = $start; $j -lt $i; $j++) {
                    
                    # Check if we are at the start of a free space
                    if ($disklayout[$j] -eq '.') {

                        # Find the end of the free space
                        for ($j1 = $j; $j1 -lt $i; $j1++) {
                            
                            # Check if we are at the end of the free space
                            if ($disklayout[($j1)] -ne $disklayout[($j1+1)]) { # We are at the end of a free space
                        
                                if ($disklayout[$j1] -eq '.') {

                                    # At this point we have a complete free space between $j and $j1
                                    # We also have a complete file between $i and $i1, from the parent loop

                                    $freesize = $j1-$j+1
                                
                                    # If file is too large for free space, continue looking for free space
                                    if ($datasize -gt $freesize) {continue}
                                    #[console]::WriteLine("$($disklayout[$i]) $i $i1 $j $j1 $datasize $freesize")
                                    $actions += [PSCustomObject]@{
                                        "ID" = $($disklayout[$i])
                                        "I" = $i
                                        "I1" = $i1
                                        "J" = $j
                                        "J1" = $j1
                                        "Datasize" = $datasize
                                        "Freesize" = $freesize
                                    }

                                    foreach ($r in ($j..($j+$datasize-1))) {
                                        $disklayout[$r] = $disklayout[$i]
                                    }
                                    foreach ($r in ($i..$i1)) {
                                        $disklayout[$r] = "."
                                    }
                                    
                                    # Note that we have used a free space of $freespace at position $j
                                    $nfs.$freesize = $j
                                    #Write-Output $($disklayout -join "")
                                    
                                    continue findData
                                } else {
                                    continue findEmpty
                                }
                            }
                        }
                    }
                }
                # Mark the end of the file so the loop will continue completely past the file, and not take part of it.
                $is = $i1
                continue findData
            }
        }
    }
}
Write-Host "Done."

#$actions | ft

# Calculate the checksum
Write-Host "Calculating checksum . . . " -NoNewline
[int64]$Checksum = 0
for ($i = 0; $i -lt $disklayout.Length; $i++) {
    if ($disklayout[$i] -ne '.') {
        $Checksum += $i * [int]$disklayout[$i].ToString()
    }
}

# Output the checksum to a file
$Checksum | Set-Content -Path .\out.txt -Encoding UTF8

# Print the checksum to the console
Write-Host "$Checksum"
} | select TotalMinutes