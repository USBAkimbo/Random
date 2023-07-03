function New-OneTimeSecret {

    # Prompt the user to paste the secret in
    $Secret = Read-Host -Prompt "Paste in the secret you want to share" -AsSecureString

    # Convert string from secure back to plain text
    $Hashed = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secret)
    $PlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Hashed)

    # Send the data and expire secret in 24 hours
    $Response = Invoke-RestMethod -Method Post -Uri "https://onetimesecret.com/api/v1/share?secret=$($PlainText)&ttl=86400"

    # Echo the link back to you
    $Link = "https://onetimesecret.com/secret/" + $Response.secret_key
    Set-Clipboard $Link
    Write-Host $Link
    Write-Host "Link has been copied to the clipboard"

    }
