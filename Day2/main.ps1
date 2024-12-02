

# 7 6 4 2 1: Safe because the levels are all decreasing by 1 or 2.
# 1 2 7 8 9: Unsafe because 2 7 is an increase of 5.
# 9 7 6 2 1: Unsafe because 6 2 is a decrease of 4.
# 1 3 2 4 5: Unsafe because 1 3 is increasing but 3 2 is decreasing.
# 8 6 4 4 1: Unsafe because 4 4 is neither an increase or a decrease.
# 1 3 6 7 9: Safe because the levels are all increasing by 1, 2, or 3.
# So, in this example, 2 reports are safe.

# Analyze the unusual data from the engineers. How many reports are safe?

$inputFile = "example.txt"

# Create a set of tests

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
        $difference = [Math]::Abs($levels[$i] - $levels[$i - 1])

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
    if ((testIncreaseOrDecreaseOnly($report)) -eq "fail") {
        $unsafeCount += 1
    }
    elseif ((testlevelsDifference($report, 1, 3)) -eq "fail") {
        $unsafeCount += 1
    }
    else {
        $safeCount += 1
    }

}

Write-Host "Unsafe Count: $unsafeCount"
Write-Host "Safe Count: $safeCount"

foreach ($report in $reports) {
    $result1 = testIncreaseOrDecreaseOnly($report)
    $result2 = testlevelsDifference($report, 1, 3)
    Write-Host "Report: $report"
    Write-Host "Increase/Decrease Test: $result1"
    Write-Host "Difference Test: $result2"
    Write-Host ""
}
