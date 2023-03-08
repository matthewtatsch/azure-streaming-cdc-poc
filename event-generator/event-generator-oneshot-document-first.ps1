[Reflection.Assembly]::LoadWithPartialName("System.Web") | out-null

$scenario = "Document sent first"

# Set the following environment variables before running the script:
$EVENT_HUB_NAMESPACE=$Env:EVENT_HUB_NAMESPACE
$Access_Policy_Key=$Env:EVENT_HUB_KEY
$Access_Policy_Name="RootManageSharedAccessKey"
$EVENT_HUB_NAME_DOCUMENT=$Env:EVENT_HUB_NAME_DOCUMENT
$EVENT_HUB_NAME_COUPON=$Env:EVENT_HUB_NAME_COUPON

$Expires=([DateTimeOffset]::Now.ToUnixTimeSeconds())+100000
$HMAC = New-Object System.Security.Cryptography.HMACSHA256
$HMAC.key = [Text.Encoding]::ASCII.GetBytes($Access_Policy_Key)

# URI for Document
$URI_DOCUMENT = "https://$EVENT_HUB_NAMESPACE.servicebus.windows.net/$EVENT_HUB_NAME_DOCUMENT/messages"

# URI for Coupon
$URI_COUPON = "https://$EVENT_HUB_NAMESPACE.servicebus.windows.net/$EVENT_HUB_NAME_COUPON/messages"

function New-SASToken {
    
    param(
        [Parameter(Mandatory=$true)] [string]$URI,
        [Parameter(Mandatory=$true)] [string]$Access_Policy_Name
    )

    $SignatureString=[System.Web.HttpUtility]::UrlEncode($URI)+ "`n" + [string]$Expires
    $Signature = $HMAC.ComputeHash([Text.Encoding]::ASCII.GetBytes($SignatureString))
    $Signature = [Convert]::ToBase64String($Signature)
    $SASToken = "SharedAccessSignature sr=" + [System.Web.HttpUtility]::UrlEncode($URI) + "&sig=" + [System.Web.HttpUtility]::UrlEncode($Signature) + "&se=" + $Expires + "&skn=" + $Access_Policy_Name
    
    return $SASToken
}

function New-EventHubRESTMessage {
    param(
        [Parameter(Mandatory=$true)] [string]$URI,
        [Parameter(Mandatory=$true)] [string]$SASToken,
        [Parameter(Mandatory=$true)] [string]$body
    )
    $method = "POST"

    # API headers document
    $headers = @{
        "Authorization"=$SASToken;
        "Content-Type"="application/atom+xml;type=entry;charset=utf-8";
    }

    # execute the Azure REST API for document
    Invoke-RestMethod -Uri $URI -Method $method -Headers $headers -Body $body
}

# Display scenario message
Write-Host $scenario -ForegroundColor Yellow

# Generate documentId as GUID
$documentId = New-Guid

# Event Hub message for Document
$SASTokenDocument = New-SASToken -URI $URI_DOCUMENT -Access_Policy_Name $Access_Policy_Name

$documentBody = @"
{
    "documentId": "$documentId",
    "createDatetime": "$(Get-Date -Format o -AsUTC)",
    "scenario": "$scenario"
}
"@

$documentBody
New-EventHubRESTMessage -URI $URI_DOCUMENT -SASToken $SASTokenDocument -body $documentBody

# Event Hub message for Coupon
$SASTokenCoupon = New-SASToken -URI $URI_COUPON -Access_Policy_Name $Access_Policy_Name

$couponId = New-Guid
$couponBody = @"
{
    "couponId": "$couponId",
    "createDatetime": "$(Get-Date -Format o -AsUTC)",
    "documentId": "$documentId",
    "scenario": "$scenario"
}
"@

$couponBody
New-EventHubRESTMessage -URI $URI_COUPON -SASToken $SASTokenCoupon -body $couponBody
