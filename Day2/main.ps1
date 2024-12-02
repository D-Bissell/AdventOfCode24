
$inputFile = "input.txt"


# Test that levels in a report always increase or Decrease
function testIncreaseOrDecreaseOnly {
    param (
        [array]$report
    )
    

    # Split the report
    $levels = $report -split " "
    if ($levels.Length -eq 1) {
        return "pass"
    }    

    # Test if initial increase or decrease
    $increasing = $levels[1] -gt $levels[0]

    for ($i = 1; $i -lt (($levels.Length)); $i++) {
        # Check if still increasing or decreasing
        $difference = $levels[$i] - $levels[$i - 1]
        if ((($difference -gt 0) -ne $increasing) -or ($difference -eq 0)) {
            return ("fail")
        }
    }

    return ("pass")

}

function testlevelsDifference {
    param (
        [array]$report,
        [int]$minDiff,
        [int]$maxDiff
    )

    # Split the report
    $levels = $report -split " "

    # For each consecurive pair
    for ($i = 1; $i -lt (($levels.Length)); $i++) {
        # Get the difference
        $difference = [Math]::Abs([int]$levels[$i] - [int]$levels[$i - 1])

        # If difference is outside given range, fail.
        if (($difference -lt $minDiff) -or ($difference -gt $maxDiff)) {
            return ("fail")
        }
    }

    return("pass")
}


# Get content
$reports = Get-content $inputFile

$safeCount = 0
$unsafeCount = 0

foreach ($report in $reports) {

    # If any test fails, report is unsafe.
    if ((testIncreaseOrDecreaseOnly $report) -eq "fail") {
        $unsafeCount += 1
    }
    elseif ((testlevelsDifference $report 1 3) -eq "fail") {
        $unsafeCount += 1
    }
    else {
        $safeCount += 1
    }

}

Write-Host "Unsafe Count: $unsafeCount"
Write-Host "Safe Count: $safeCount"
