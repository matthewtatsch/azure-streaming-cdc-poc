[Reflection.Assembly]::LoadWithPartialName("System.Web") | out-null

# Set the following environment variables before running the script:
$EVENT_HUB_NAMESPACE=$Env:EVENT_HUB_NAMESPACE
$EVENT_HUB_NAME=$Env:EVENT_HUB_NAME
$Access_Policy_Key=$Env:EVENT_HUB_KEY

$URI="https://$EVENT_HUB_NAMESPACE.servicebus.windows.net/$EVENT_HUB_NAME/messages"
$Access_Policy_Name="RootManageSharedAccessKey"

$Expires=([DateTimeOffset]::Now.ToUnixTimeSeconds())+100000
$SignatureString=[System.Web.HttpUtility]::UrlEncode($URI)+ "`n" + [string]$Expires
$HMAC = New-Object System.Security.Cryptography.HMACSHA256
$HMAC.key = [Text.Encoding]::ASCII.GetBytes($Access_Policy_Key)
$Signature = $HMAC.ComputeHash([Text.Encoding]::ASCII.GetBytes($SignatureString))
$Signature = [Convert]::ToBase64String($Signature)
$SASToken = "SharedAccessSignature sr=" + [System.Web.HttpUtility]::UrlEncode($URI) + "&sig=" + [System.Web.HttpUtility]::UrlEncode($Signature) + "&se=" + $Expires + "&skn=" + $Access_Policy_Name

$method = "POST"

# API headers
$headers = @{
            "Authorization"=$SASToken;
            "Content-Type"="application/atom+xml;type=entry;charset=utf-8";
            }

function New-InsertObject {
    $documentId = New-Guid
    $createdDatetime = Get-Date -DisplayHint Date -Format MM/dd/yyyy
    
    # create Request Body
    $body = @"
{
    "documentId": $documentId,
    "createdDatetime": $createdDatetime,
    "entityType": {
        "string":"PT"

    }
}
"@
}

# Function to generate json data
function New-JsonObject {
    $Date = Get-Date -DisplayHint Date -Format MM/dd/yyyy
    $Time = Get-Date -DisplayHint Time -Format HH:mm:ss
    $num = Get-Random -Minimum 0 -Maximum 1000
    $body = "{'city_name':'houston','dt':'" + $Date + "','tm':'" + $Time + "','rnum':" + $num + ",'current_temperature':57.47,'current_feels_like':56.01,'current_pressure':1025,'current_humidity':66,'weather_description':'scattered clouds','current_weather_json':{'coord': {'lon': -95.3633, 'lat': 29.7633}, 'weather': [{'id': 802, 'main': 'Clouds', 'description': 'scattered clouds', 'icon': '03d'}], 'base': 'stations', 'main': {'temp': 57.47, 'feels_like': 56.01, 'temp_min': 54.41, 'temp_max': 60.3, 'pressure': 1025, 'humidity': 66}, 'visibility': 10000, 'wind': {'speed': 16.11, 'deg': 340, 'gust': 31.07}, 'clouds': {'all': 40}, 'dt': 1676048759, 'sys': {'type': 2, 'id': 2022061, 'country': 'US', 'sunrise': 1676034327, 'sunset': 1676073964}, 'timezone': -21600, 'id': 4699066, 'name': 'Houston', 'cod': 200}}"
    return $body
}

while($true)
{
    # create Request Body
    $body = New-JsonObject

    # execute the Azure REST API
    Invoke-RestMethod -Uri $URI -Method $method -Headers $headers -Body $body

	Start-Sleep -m 30
}   



