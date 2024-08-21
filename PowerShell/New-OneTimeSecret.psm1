function New-OneTimeSecret {
    # Prompt the user to paste the secret in
	$Secret = Read-Host -Prompt "Paste in the secret you want to share" -AsSecureString

    # Convert string from secure back to plain text
    $Hashed = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secret)
    $PlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Hashed)

    # Encode the secret to handle special characters
    $EncodedSecret = [System.Web.HttpUtility]::UrlEncode($PlainText)

    # Send the data, expiring the secret if it's not opened within 84600 seconds (1 day)
    $Response = Invoke-RestMethod -Method Post -Uri "https://onetimesecret.com/api/v1/share?secret=$($EncodedSecret)&ttl=86400"

    # Echo the link back to you and copy it to your clipboard
    $Link = "https://onetimesecret.com/secret/" + $Response.secret_key
	Set-Clipboard $Link
    Write-Host $Link
	Write-Host "Link has been copied to the clipboard"
}
