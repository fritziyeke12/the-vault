# Fetch the latest version from Microsoft's website
$url = "https://www.microsoft.com/en-us/wdsi/defenderupdates"
try {
    $webContent = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
} catch {
    Write-Error "Failed to fetch web content. Error: $_"
    return
}

# Validate the fetched content
if ($null -eq $webContent.Content) {
    Write-Error "No content retrieved from the website."
    return
}

# Updated regex to extract version number inside <span>
if ($webContent.Content -match "<li>Version:\s*<span>(\d+\.\d+\.\d+\.\d+)</span>") {
    $latestVersion = $Matches[1]
    Write-Output "Latest version extracted: $latestVersion"
} else {
    Write-Error "Failed to extract the latest version from the website. Check the HTML structure."
    return
}

# Fetch local version
$localVersion = (Get-MpComputerStatus).AntivirusSignatureVersion
Write-Output "Local version: $localVersion"

# Split versions for comparison
$localArray = $localVersion -split '\.'
$latestArray = $latestVersion -split '\.'

# Calculate the difference in revision numbers
$difference = $latestArray[2] - $localArray[2]
Write-Output "You are $difference revisions behind the latest definitions."
