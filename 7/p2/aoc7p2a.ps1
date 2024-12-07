$In = (Get-Content -Path .\input.txt -Raw)

[int64]$Result = 0

$Equations = @{}
$AllowedOperators = "+", "*", "C"

foreach ($line in $In.Split("`n")){
    if ($line -eq "") {continue}
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
        [string]$expression
    )
    $tokens = $expression -split ' '
    $result = $tokens[0]
    for ($i = 1; $i -lt $tokens.Length; $i += 2) {
        $operator = $tokens[$i]
        $operand = $tokens[$i + 1]
        switch ($operator) {
            '+' { $result = [int64]$result + [int64]$operand }
            '*' { $result = [int64]$result * [int64]$operand }
            'C' { $result = [int64]"$result$operand" }
        }
    }
    return $result
}

# Memoization caches
$MemoizationCache = @{}
$OperatorCombinationsCache = @{}

foreach ($Goal in $Equations.Keys) {
    $EquationText = $Equations.$Goal 
    $Equation = $EquationText.Split(" ") | % {$_}
    $EquationLength = $Equation.Length - 1

    # Check if operator combinations for this length are already cached
    if ($OperatorCombinationsCache.ContainsKey($EquationLength)) {
        $OperatorCombinations = $OperatorCombinationsCache[$EquationLength]
    } else {
        $OperatorCombinations = Get-Operator-Combinations -length $EquationLength -operators $AllowedOperators
        $OperatorCombinationsCache[$EquationLength] = $OperatorCombinations
    }

    $GoalMet = $false
    foreach ($OpComb in $OperatorCombinations) {
        $Expression = ""
        for ($i = 0; $i -lt $Equation.Length; $i++) {
            $Expression += $Equation[$i]
            if ($i -lt $OpComb.Length) {
                $Expression += " " + $OpComb[$i] + " "
            }
        }

        # Check if the expression result is already cached
        if ($MemoizationCache.ContainsKey($Expression)) {
            $EvalResult = $MemoizationCache[$Expression]
        } else {
            try {
                $EvalResult = Evaluate-LeftToRight -expression $Expression
                # Cache the result
                $MemoizationCache[$Expression] = $EvalResult
            } catch {
                Write-Host "Error evaluating expression: $Expression"
                continue
            }
        }

        if ($EvalResult -eq $Goal) {
            Write-Host "Goal met: $Goal with expression $Expression"
            $GoalMet = $true
            break
        }
    }

    if ($GoalMet) {
        $Result += $Goal
    }
}

$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8
