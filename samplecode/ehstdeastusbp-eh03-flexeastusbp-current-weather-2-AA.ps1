[Reflection.Assembly]::LoadWithPartialName("System.Web")| out-null
$URI="xxxxx.servicebus.windows.net/eventhubname"
# https://ehpremeastusbp.servicebus.windows.net:443/
# https://ehstdeastusbp.servicebus.windows.net:443/

$Access_Policy_Name="RootManageSharedAccessKey"
$Access_Policy_Key="xxxxxxx"

# Token expires now+3000
# $Expires=([DateTimeOffset]::Now.ToUnixTimeSeconds())+3000
$Expires=([DateTimeOffset]::Now.ToUnixTimeSeconds())+100000
$SignatureString=[System.Web.HttpUtility]::UrlEncode($URI)+ "`n" + [string]$Expires
$HMAC = New-Object System.Security.Cryptography.HMACSHA256
$HMAC.key = [Text.Encoding]::ASCII.GetBytes($Access_Policy_Key)
$Signature = $HMAC.ComputeHash([Text.Encoding]::ASCII.GetBytes($SignatureString))
$Signature = [Convert]::ToBase64String($Signature)
$SASToken = "SharedAccessSignature sr=" + [System.Web.HttpUtility]::UrlEncode($URI) + "&sig=" + [System.Web.HttpUtility]::UrlEncode($Signature) + "&se=" + $Expires + "&skn=" + $Access_Policy_Name

$SASToken
$method = "POST"
$URI = "https://xxxx.servicebus.windows.net/eventhubname/messages"
$signature = $SASToken
$idx = 0
$idxZ = 0

# API headers
$headers = @{
            "Authorization"=$signature;
            "Content-Type"="application/atom+xml;type=entry;charset=utf-8";
            }




$InstanceName = "LK01"
$Date = Get-Date -DisplayHint Date -Format MM/dd/yyyy
$Time = Get-Date -DisplayHint Time -Format HH:mm:ss
    



while($true)
{
    $Date = Get-Date -DisplayHint Date -Format MM/dd/yyyy
    $Time = Get-Date -DisplayHint Time -Format HH:mm:ss
    $idx = 0 


    



    $idx = $idx + 1

        
    $num = Get-Random -Minimum 0 -Maximum 1000
        # Write-host $i 
        # create Request Body
        # $body = "{'type':'test', 'DeviceId':'dev-01', 'Temperature':37.0}"

    

        $body = "{'city_name':'houston','dt':'" + $Date + "','tm':'" + $Time + "','rnum':" + $num + ",'current_temperature':57.47,'current_feels_like':56.01,'current_pressure':1025,'current_humidity':66,'weather_description':'scattered clouds','current_weather_json':{'coord': {'lon': -95.3633, 'lat': 29.7633}, 'weather': [{'id': 802, 'main': 'Clouds', 'description': 'scattered clouds', 'icon': '03d'}], 'base': 'stations', 'main': {'temp': 57.47, 'feels_like': 56.01, 'temp_min': 54.41, 'temp_max': 60.3, 'pressure': 1025, 'humidity': 66}, 'visibility': 10000, 'wind': {'speed': 16.11, 'deg': 340, 'gust': 31.07}, 'clouds': {'all': 40}, 'dt': 1676048759, 'sys': {'type': 2, 'id': 2022061, 'country': 'US', 'sunrise': 1676034327, 'sunset': 1676073964}, 'timezone': -21600, 'id': 4699066, 'name': 'Houston', 'cod': 200}}"


        #Write-Host ($body)

        # execute the Azure REST API
        Invoke-RestMethod -Uri $URI -Method $method -Headers $headers -Body $body
  

	sleep 5

}    


#Write-Host "Date: " $Date " Time: " $Time " CPU: " $ComputerCPU " Memory: " $RoundMemory " Temp(C): " $Temp " Thread Count: " $ThreadCount " Processor Count: " $ProcessorCount 
#Write-Host "Uptime: " $Uptime
#Write-Host "max clock speed: " $maxClockSpeed
#Write-Host "current clock speed: " $currentClockSpeed
#Write-Host "cpu name: " $cpuName
#Write-Host "second: " $Sec
#Write-Host "minute: " $Min 
#Write-Host "mod 5 min: "  ($Min % 5)
#Write-Host "mod 1 min: "  ($Sec % 60)
#Write-Host (ConvertTo-Json @($payload))



