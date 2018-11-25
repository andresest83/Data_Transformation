# Load countries.csv in a custom ps object
$countries = Import-Csv "D:\Data Integration\Data Transformation\countries.csv"

# Loop through every country in the .csv file
for ($i=0; $i -lt $countries.length; $i++)
{
       $ErrorMessage=""
       $countryRestInfo=""

       # Find every empty field on the Unknown Column
       if ([string]::IsNullOrEmpty($countries[$i].Unknown))
       {
            $name=$countries[$i].Name
            
            # Call the API using the country name           
            try   {$countryRestInfo=Invoke-RestMethod -Method Get -Uri "https://restcountries.eu/rest/v2/name/$name"} 
            catch {$ErrorMessage = $_.Exception.Message}
            
            if ([string]::IsNullOrEmpty($ErrorMessage))
            {
            # In Step 1 we found out Unknown refers to Capital so this is the property we use to transform this column
            $countries[$i].Unknown=$countryRestInfo.Capital
            }
            else
            {
            $countries[$i].Unknown=$ErrorMessage
            }

       }
}

# Export a new file with the modified countries list
$countries | Export-Csv -Path "D:\Data Integration\Data Transformation\countriesTransformed.csv" -NoTypeInformation