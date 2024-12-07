$In = (Get-Content -Path .\input.txt -Raw)

[int64]$Result = 0

$Equations = @{}
$AllowedOperators = "+","*"

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
    $result = [int]$tokens[0]
    for ($i = 1; $i -lt $tokens.Length; $i += 2) {
        $operator = $tokens[$i]
        $operand = [int]$tokens[$i + 1]
        switch ($operator) {
            '+' { $result += $operand }
            '*' { $result *= $operand }
        }
    }
    return $result
}

foreach ($Goal in $Equations.Keys) {
    $EquationText = $Equations.$Goal 
    $Equation = $EquationText.Split(" ") | % {,[int64]$_}
    $OperatorCombinations = Get-Operator-Combinations -length ($Equation.Length - 1) -operators $AllowedOperators

    $GoalMet = $false
    foreach ($OpComb in $OperatorCombinations) {
        $Expression = ""
        for ($i = 0; $i -lt $Equation.Length; $i++) {
            $Expression += $Equation[$i]
            if ($i -lt $OpComb.Length) {
                $Expression += " " + $OpComb[$i] + " "
            }
        }
        
        # Debugging output
        #Write-Host "Evaluating expression: $Expression"
        
        try {
            $EvalResult = Evaluate-LeftToRight -expression $Expression
            #Write-Host "Result: $EvalResult"
            if ($EvalResult -eq $Goal) {
                Write-Host "Goal met: $Goal with expression $Expression"
                $GoalMet = $true
                break
            }
        } catch {
            Write-Host "Error evaluating expression: $Expression"
        }
    }

    if ($GoalMet) {
        $Result += $Goal
    }
}

$Result
$Result | Set-Content -Path .\out.txt -Encoding UTF8