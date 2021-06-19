# What is this?
- This guide shows you how to legitimately obtain a Server 2019 Eval ISO and then convert it to full
- This is useful as Eval editions will randomly shut down once the trial period expires

# Getting the ISO
- Go here
- https://www.microsoft.com/en-gb/evalcenter/evaluate-windows-server-2019
- Make a free account and download the ISO

# Install
- Install Windows, selecting "datacenter desktop experience"

# Convert
- To convert the edition, open cmd and run

```
DISM /online /Get-TargetEditions
```

- This should return something like this

```
C:\Users\Administrator>DISM /online /Get-TargetEditions

Deployment Image Servicing and Management tool
Version: 10.0.17763.1

Image Version: 10.0.17763.379

Editions that can be upgraded to:

Target Edition : ServerDatacenter

The operation completed successfully.
```

- Now to convert it, run this command

```
DISM /Online /Set-Edition:ServerDatacenter /ProductKey:WMDGN-G9PQG-XVVXX-R3X43-63DFG /AcceptEula
```

- If you're using a different edition, you'll need a different product key
- You can use any of the GVLKs from here for your edition
- https://docs.microsoft.com/en-us/windows-server/get-started/kmsclientkeys

# Reboot
- Once you've ran the above command, reboot

# Finishing
- Now you're done, you just need to license windows
- Have a Google for "KMS VL ALL" and give that a shot