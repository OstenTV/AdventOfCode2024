$In = (Get-Content -Path .\input.txt -Raw)

[int64]$Result = 0

$Equations = @{}
$AllowedOperators = "+", "*", "C"

foreach ($line in $In.Split("`n")) {
    if ($line -eq "") { continue }
    $Split = $line.Split(":")
    $Equations.$([int64]$Split[0].Trim()) = $Split[1].Trim()
}

function Get-Operator-Combinations {
    param (
        [int]$length,
        [string[]]$operators
    )
    if ($length -eq 0) {
        return @("")
    }
    $combinations = @()
    $subCombinations = Get-Operator-Combinations -length ($length - 1) -operators $operators
    foreach ($subComb in $subCombinations) {
        foreach ($op in $operators) {
            $combinations += "$subComb$op"
        }
    }
    return $combinations
}

function Evaluate-LeftToRight {
    param (
        [string]$expression,
        [int64]$goal
    )
    $tokens = $expression -split ' '
    $result = [int64]$tokens[0]
    for ($i = 1; $i -lt $tokens.Length; $i += 2) {
        $operator = $tokens[$i]
        $operand = $tokens[$i + 1]
        switch ($operator) {
            '+' { $result = $result + [int64]$operand }
            '*' { $result = $result * [int64]$operand }
            'C' { $result = [int64]"$result$operand" }
        }
        if ($result -gt $goal) {
            return 0
        }
    }
    return $result
}

# Memoization caches
$OperatorCombinationsCache = Import-Clixml -Path .\OperatorCombinationsCache.xml

$jobs = @()

foreach ($Goal in $Equations.Keys) {
    $EquationText = $Equations.$Goal 
    $Equation = $EquationText.Split(" ") | % { $_ }
    $EquationLength = $Equation.Length - 1

    # Check if operator combinations for this length are already cached
    if ($OperatorCombinationsCache.ContainsKey($EquationLength)) {
        $OperatorCombinations = $OperatorCombinationsCache[$EquationLength]
    } else {
        $OperatorCombinations = Get-Operator-Combinations -length $EquationLength -operators $AllowedOperators
        $OperatorCombinationsCache[$EquationLength] = $OperatorCombinations
    }

    # Wait if there are already 10 running jobs
    while (($jobs | Where-Object { $_.State -eq 'Running' }).Count -ge 25) {
        Start-Sleep -Seconds 1
    }

    Write-Host "New job started $Goal = $EquationText"

    $jobs += Start-Job -ScriptBlock {
        param ($Goal, $Equation, $OperatorCombinations)
        $GoalMet = $false
        foreach ($OpComb in $OperatorCombinations) {
            $Expression = ""
            for ($i = 0; $i -lt $Equation.Length; $i++) {
                $Expression += $Equation[$i]
                if ($i -lt $OpComb.Length) {
                    $Expression += " " + $OpComb[$i] + " "
                }
            }

            try {
                $EvalResult = Evaluate-LeftToRight -expression $Expression -goal $Goal
            } catch {
                Write-Host "Error evaluating expression: $Expression"
                continue
            }

            if ($EvalResult -eq $Goal) {
                $GoalMet = $true
                break
            }
        }

        if ($GoalMet) {
            return [PSCustomObject]@{ Goal = $Goal; Result = $Goal; Status = "Valid"; OpComb = $OpComb }
        } else {
            return [PSCustomObject]@{ Goal = $Goal; Result = 0; Status = "Invalid"; OpComb = "" }
        }
    } -ArgumentList $Goal, $Equation, $OperatorCombinations
}

# Wait for all jobs to complete
$jobs | ForEach-Object { $_ | Wait-Job }

# Collect results
$results = $jobs | ForEach-Object { $_ | Receive-Job }

# Process results
foreach ($result in $results) {
    if ($result.Status -eq "Valid") {
        Write-Host "$($result.Goal) = $($result.OpComb).$"
        $Result += $result.Result
    } else {
        Write-Host "$($result.Goal) = Invalid."
    }
}

$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8

# Clean up jobs
$jobs | ForEach-Object { Remove-Job -Job $_ }
