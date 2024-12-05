# Read and parse the input file
$In = (Get-Content -Path .\input.txt -Raw)
$Rules = @()
$Updates = @()
foreach ($line in $In.Split("`n")) {
    if ($line -eq "") { continue }
    
    if ($line -like "*|*") {
        $Split = $line.Split("|")
        [int]$x = $Split[0]
        [int]$y = $Split[1]
        $Rules += ,@($x,$y)
    } elseif ($line -like "*,*") {
        [int[]]$Split = $line.Split(",")
        $Updates += ,$Split
    }
}


# Function to check if an update is in the correct order
function Is-UpdateInOrder {
    param (
        [array]$update,
        [array]$rules
    )
    foreach ($rule in $rules) {
        $x = $rule[0]
        $y = $rule[1]
        if ($update -contains $x -and $update -contains $y) {
            if ([Array]::IndexOf($update, $x) -gt [Array]::IndexOf($update, $y)) {
                return $false
            }
        }
    }
    return $true
}

# Function to reorder an update according to the rules
function Reorder-Update {
    param (
        [array]$update,
        [array]$rules
    )
    $orderedUpdate = $update.Clone()
    $orderedUpdate = $orderedUpdate | Sort-Object {
        $page = $_
        $precedence = 0
        foreach ($rule in $rules) {
            if ($rule[1] -eq $page -and $update -contains $rule[0]) {
                $precedence++
            }
        }
        $precedence
    }
    return $orderedUpdate
}



# Check updates and reorder if necessary
$middlePagesSum = 0
foreach ($update in $Updates) {
    if (-not (Is-UpdateInOrder -update $update -rules $Rules)) {
        $reorderedUpdate = Reorder-Update -update $update -rules $Rules
        Write-Host $reorderedUpdate
        $middleIndex = [math]::Floor($reorderedUpdate.Length / 2)
        $middlePagesSum += [int]$reorderedUpdate[$middleIndex]
    } <# else {
        Write-Host $update
        $middleIndex = [math]::Floor($update.Length / 2)
        $middlePagesSum += [int]$update[$middleIndex]
    } #>
}


# Output the sum of the middle pages of the reordered updates
Write-Output $middlePagesSum
