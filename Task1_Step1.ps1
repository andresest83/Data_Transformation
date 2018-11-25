# Load countries.csv in a custom PS object
$countries = Import-Csv "D:\Data Integration\Data Transformation\countries.csv"

# Load all of the countries information requested to the REST API in a PS Object
$allCountriesRest=Invoke-RestMethod -Method Get -Uri https://restcountries.eu/rest/v2/all

# Load all the keys of the JSON file retrieved from the API in a PS Array
$values = @("topLevelDomain","alpha2code","alpha3code","callingCodes","capital","altSpellings","region","subregion","population","latlng","demonym","area","gini","timezones","borders","nativeName","numericCode","currencies","languages","translations","flag","regionalBlocs","cioc") 

# Create an initialize an array counter for the JSON Keys
$valuesCounter = @()
for ($k=0; $k -lt 23; $k++)
{
$valuesCounter+=0
}

# Loop through both PS Objects and count all the times that a field in UNKNOWN matches a field in the API
for ($i=0; $i -lt $countries.length; $i++)
{
    for ($j=0; $j -lt $allCountriesRest.length; $j++)
    {
        if(($countries[$i].Name -eq $allCountriesRest[$j].name) -and (-not [string]::IsNullOrEmpty($countries[$i].Unknown)))
        {
             for ($k=0; $k -lt 23; $k++)
             {
                 $property=$values[$k]
                 if ($countries[$i].Unknown -eq $allCountriesRest[$j].$property)
                 {
                    $valuesCounter[$k]+=1
                 }

             }
        }
    }
}

# Get the field in the API that matched the most times
$maxValue=$valuesCounter | measure -Maximum
$maxValue=$maxValue.Maximum
for ($i=0; $i -lt $valuesCounter.length; $i++)
{
    if ($valuesCounter[$i] -eq $maxValue)
    {
    $valuesIndex=$i
    }
}

# Results
Write-Host "The Column UNKNOWN is the column"$values[$valuesIndex]"in the Countries Restful API"