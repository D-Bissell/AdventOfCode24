

$list1 = @()
$list2 = @()

$inputFile = "input.txt"


# Seperate lists
foreach($line in Get-content $inputFile) {
    $result = $line -split "   "
    $list1 += $result[0]
    $list2 += $result[1]
}

# Pair up smallest number in left list with smallest in right
# then second smallest, and so on
# get the difference between them

# Order the lists by size ascending
$list1 = $list1 | Sort-Object
$list2 = $list2 | Sort-Object

$listLength = $list1.Length
$totalDistance = 0

for ($i=0; $i -le $listLength; $i++) {
    # Cant use absolute math function >:(
    if ($list1[$i] -ge $list2[$i]) {
        $totalDistance += $list1[$i] - $list2[$i]
    }
    elseif ($list2[$i] -ge $list1[$i]) {
        $totalDistance += $list2[$i] - $list1[$i]
    }
    else {
        throw 1
    }
}

Write-Host $totalDistance

########
# Part 2
########


# For each number on left list
# Check if it exists on right list

# Simularity score
# Add up each number in the left list after multiplying it by the number of times it is in the right list
# Add up all the results

$totalSimScore = 0

# For every list 1 number
foreach ($list1num in $list1) {
    # Check against every list 2 number
    $simCount = 0
    foreach($list2num in $list2) {       
        if($list1num -eq $list2num) {
            $simCount++
        }}
    # Calculate simularity score
    $simScore = [int]$list1num * $simCount
    $totalSimScore += $simScore
 
}

$totalSimScore

