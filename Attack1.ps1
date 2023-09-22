# Define the source file and destination file paths
$sourceFilePath = "C:\Users\vagrant\Desktop\Wk9Attack\Test.txt"
$destinationFilePath = "C:\Users\vagrant\Desktop\Wk9AttackCopy\Test_Copy.txt"
$encryptedFilePath = "C:\Users\vagrant\Desktop\Wk9AttackPass\Pass.txt"

# Check if the source file exists
if (Test-Path -Path $sourceFilePath -PathType Leaf) {
    # Create a copy of the source file
    Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -Force

    # Prompt the user for a password for encryption
    $password = Read-Host -Prompt "Enter a password for encryption" -AsSecureString

    # Convert the secure password to a plain text string
    $passwordText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

    # Generate a secure key and IV from the password using a salt
    $salt = [System.Text.Encoding]::UTF8.GetBytes("YourSaltValue")  # Change this salt value
    $keyBytes = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($passwordText, $salt, 10000).GetBytes(32)
    $ivBytes = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($passwordText, $salt, 10000).GetBytes(16)

    # Read the content of the source file
    $fileContent = [System.IO.File]::ReadAllBytes($sourceFilePath)

    # Encrypt the file content
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $keyBytes
    $aes.IV = $ivBytes
    $encryptor = $aes.CreateEncryptor()
    $encryptedBytes = $encryptor.TransformFinalBlock($fileContent, 0, $fileContent.Length)

    # Write the encrypted content back to the source file
    [System.IO.File]::WriteAllBytes($sourceFilePath, $encryptedBytes)

    # Save the password to a file for decryption later
    $password | ConvertFrom-SecureString | Out-File -FilePath $encryptedFilePath

    Write-Output "File copied and original file encrypted successfully."
} else {
    Write-Output "Source file does not exist."
}
