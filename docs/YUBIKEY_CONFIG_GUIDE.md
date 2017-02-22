# Yubikey - GPG and SSH Key Configuration Guidelines

## Preamble 
This is the configuration guidelines for deploying GPG and SSH keys on a Yubikey. It has been validated on [secure development environment - Ubuntu v16.04][https://github.com/UKorg/development_environment]. The guidelines are for Yubikey 4 as it supports 4096 bit key length.  

## Prerequisites
For this procedure to work it requires GnuPG version 2.0.22 or later (this is currently included in the secure development environment). 
The version of the YubiKey's OpenPGP module must be 1.0.5 or later. To check this version you may run: 
 
```shell
gpg-connect-agent --hex "scd apdu 00 f1 00 00" /bye
D[0000]  01 00 05 90 00                                     .....
OK
Where "01 00 05" means version 1.0.5.
```

## Generate a Key
>Skip this step if you already have a key. It is assumed that the GPG private and public key are available in the environment. 

```shell
$gpg2 --gen-key
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096		

Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire		
      <n>  = key expires in n days		
      <n>w = key expires in n weeks		
      <n>m = key expires in n months		
      <n>y = key expires in n years		
Key is valid for? (0) 0				
```
											
Select an expiry date if you want to. And answer that the data is correct.		

```shell
Real name: <your name>									
```
Enter your name associated with this key.

```shell
Email address: <user.name@org.com>					
```

Enter the email address associated with this key.

```shell
Comment: 										
May be a comment attached to the key if you want, or leave this empty.			
You selected this USER-ID:								
    "<your name> <user.name@org.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
```

If you're happy with this USER-ID answer O for okay.

```shell
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: key 13AFCE85 marked as ultimately trusted
public and secret key created and signed.

gpg: checking the trustdb
gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
gpg: depth: 0  valid:   4  signed:   8  trust: 0-, 0q, 0n, 0m, 0f, 4u
gpg: depth: 1  valid:   8  signed:   2  trust: 3-, 0q, 0n, 5m, 0f, 0u
gpg: next trustdb check due at 2014-03-23
pub   4096R/13AFCE85 2014-03-07 [expires: 2014-06-15]
      Key fingerprint = 743A 2D58 688A 9E9E B4FC  493F 70D1 D7A8 13AF CE85
uid                 <your name> <user.name@org.com>
sub   4096R/D7421CDF 2014-03-07 [expires: 2014-06-15]
```

Take note of the key id, in this case 13AFCE85.

##Add an authentication key
Here we will add an authentication key to the previously generated key.

```shell
$gpg2 --expert --edit-key 13AFCE85

gpg (GnuPG) 2.1.11; Copyright (C) 2016 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

pub  4096R/13AFCE85  created: 2014-03-07  expires: 2014-06-15  usage: SC
                     trust: ultimate      validity: ultimate
sub  4096R/D7421CDF  created: 2014-03-07  expires: 2014-06-15  usage: E
[ultimate] (1). <your name> <user.name@org.com>

gpg> addkey

4096-bit RSA key, ID 13AFCE85, created 2014-03-07

Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
Your selection? 8
```
Here we select 8 to get another RSA key attached to our key.

```shell
Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Sign Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? A
Your selection? S
Your selection? E
Your selection? Q
```

Select A, then S, then E to get a pure authentication key. Then Q to continue.

```shell
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
```

Again we want a 4096 bit key.

```shell
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 0
```

Select same expiry as for the rest of the key and then answer y.

```shell
Is this correct? (y/N) y
Really create? (y/N) y
Enter a Passphrase for the Authentication Key
Enter the Passphrase for the GPG Key 
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

pub  4096R/13AFCE85  created: 2014-03-07  expires: 2014-06-15  usage: SC
                     trust: ultimate      validity: ultimate
sub  4096R/D7421CDF  created: 2014-03-07  expires: 2014-06-15  usage: E
sub  4096R/B4000C55  created: 2014-03-07  expires: 2014-06-15  usage: A
[ultimate] (1). <your name> <user.name@org.com>

gpg> Save changes? (y/N) y
```

##Backup
This is a good point to create a backup of your key.

```shell
$gpg2 --output /media/<username>/usb/<keyname> --export-ssh-key <sshkeyname>
```

Or you can copy the .gpg folder and tar it. 

>Recommendation: All keys are stored away securely (preferably on an external usb).

##Enabling CCID your YubiKey
In order for your YubiKey to be a U2F device and behave as a GPG card, you need to put the card into a mode called __'super combo mode'__. This is achieved by the following;

```shell
$ ykpersonalize -m 86

Firmware version 4.3.4 Touch level 773 Program sequence 1
Unsupported firmware revision - some features may not be available
Please see
https://developers.yubico.com/yubikey-personalization/doc/Compatibility.html
for more information.
The USB mode will be set to: 0x86
Commit? (y/n> [n] y
```

##Setting your YubiKey PINs
You need to configure 3 PINs, an 8-digit* admin PIN, an 8-digit* user PIN and an 8-digit* reset PIN.  

The admin PIN is used for administration operations including the changing of the 8-digit user PIN. The user PIN is used to access the GPG key for signing or encryption. The reset PIN is used to reset the user PIN. 

>Recommendation: It is recommended that you store the new PIN numbers within a password vault or keep it locked away with the USB key you backed-up your GPG key on. Since your admin PIN can't unlock your original GPG key (because that's protected by a pass-phrase), it's OK to keep the together.

*The minimum length for each PIN is 4 digits and the maximum length is 8 digits. The digits can be made up of numbers, lowercase letters, uppercase letters and special characters. 

>Recommendation: that the PIN be set to maximum length of 8 digits, using a least 3 of the 4 digit types.
  
###Changing the admin PIN
```shell
$ gpg2 --card-edit
gpg/card> admin
Admin commands are allowed
gpg/card> passwd

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? 3
```

A pop dialog will request the YubiKey's existing admin PIN which is `12345678.` Another pop-up will request a new PIN. Enter your new PIN (twice to confirm).

###Changing the user PIN.

```shell
1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? 1
```

This time, you'll be asked for the existing user PIN which is `123456.` Enter an new 8 digit PIN.

###Changing reset PIN.

```shell

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? 4
```
You will be asked for the existing admin PIN. Enter a new PIN and set an 8 digit reset PIN. 

Quit the passwd menu with Q:

```shell
PIN changed.

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? Q
```

##Personalizing your YubiKey

At this stage you can set your name on your GPG key.

```shell
$ gpg2 --card-edit
gpg/card> name
Cardholder's surname: <your surname>
Cardholder's given name: <your forename>
```
You will now be prompted for your admin key. Enter the 8-digit admin key (the one you just changed to).

You can set a url which the public key can be retrieved from.

```shell
gpg/card> url
URL to retrieve public key: https://keybase.io/<yourusername>/<gpg-key.asc>
```
_If you have a keybase account, set the URL of your public key._

Test your changes with list

```shell
gpg/card> list

Reader ...........: 1050:0407:X:0
Application ID ...: D2760001240102010006041321720000
Version ..........: 2.1
Manufacturer .....: Yubico
Name of cardholder: <your name>
Language prefs ...: [not set]
Sex ..............: unspecified
URL of public key : https://keybase.io/<yourusername>/<gpg-key.asc>
Now quit:
gpg/card> quit
```

##Importing the key
Now all the GPG keys can be imported onto the Yubikey.

```shell
$gpg2 --list-keys
pub  4096R/13AFCE85  created: 2014-03-07  expires: 2014-06-15  usage: SC
                     trust: ultimate      validity: ultimate
sub  4096R/D7421CDF  created: 2014-03-07  expires: 2014-06-15  usage: E
sub  4096R/B4000C55  created: 2014-03-07  expires: 2014-06-15  usage: A

$gpg2 --edit-key 13AFCE85

gpg (GnuPG) 2.0.22; Copyright (C) 2013 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

pub  4096R/13AFCE85  created: 2014-03-07  expires: 2014-06-15  usage: SC
                     trust: ultimate      validity: ultimate
sub  4096R/D7421CDF  created: 2014-03-07  expires: 2014-06-15  usage: E
sub  4096R/B4000C55  created: 2014-03-07  expires: 2014-06-15  usage: A
[ultimate] (1). <your name> <user.name@org.com>

gpg> toggle

sec  4096R/13AFCE85  created: 2014-03-07  expires: 2014-06-15
ssb  4096R/D7421CDF  created: 2014-03-07  expires: never
ssb  4096R/B4000C55  created: 2014-03-07  expires: never
(1)  <your name> <user.name@org.com>

gpg> keytocard
Really move the primary key? (y/N) y
Signature key ....: [none]
Encryption key....: [none]
Authentication key: [none]
Please select where to store the key:
   (1) Signature key
   (3) Authentication key
Your selection? 1
```

Enter gpg private key passphrase. Enter admin PIN. 

Here we've just moved the primary key to the PGP Signature slot of the YubiKey.

```shell
gpg> key 1

sec  4096R/13AFCE85  created: 2014-03-07  expires: 2014-06-15
                     card-no: 0000 00000001
ssb* 4096R/D7421CDF  created: 2014-03-07  expires: never
ssb  4096R/B4000C55  created: 2014-03-07  expires: never
(1)  <your name> <user.name@org.com>

gpg> keytocard
Signature key ....: 743A 2D58 688A 9E9E B4FC  493F 70D1 D7A8 13AF CE85
Encryption key....: [none]
Authentication key: [none]

Please select where to store the key:
   (2) Encryption key
Your selection? 2
```

Enter gpg private key passphrase. Enter admin PIN. 

Here we've moved the Encryption key.

```shell
gpg> key 1

sec  4096R/13AFCE85  created: 2014-03-07  expires: 2014-06-15
                     card-no: 0000 00000001
ssb  4096R/D7421CDF  created: 2014-03-07  expires: never
                     card-no: 0000 00000001
ssb  4096R/B4000C55  created: 2014-03-07  expires: never
(1)  <your name> <user.name@org.com>

gpg> key 2

sec  4096R/13AFCE85  created: 2014-03-07  expires: 2014-06-15
                     card-no: 0000 00000001
ssb  4096R/D7421CDF  created: 2014-03-07  expires: never
                     card-no: 0000 00000001
ssb* 4096R/B4000C55  created: 2014-03-07  expires: never
(1)  <your name> <user.name@org.com>

gpg> keytocard
Signature key ....: 743A 2D58 688A 9E9E B4FC  493F 70D1 D7A8 13AF CE85
Encryption key....: 8D17 89A0 5C2F B804 22E5  5C04 8A68 9CC0 D742 1CDF
Authentication key: [none]

Please select where to store the key:
   (3) Authentication key
Your selection? 3
```

Enter gpg private key passphrase. Enter admin PIN. 

Finally we moved the Authentication key to the YubiKey.

```shell
gpg> quit
Save changes? (y/N) y
After this the keyring is saved. And that point 
Check the changes have been enforced;
$ gpg2 --card-status
Reader ...........: 1050:0407:X:0
Application ID ...: D2760001240102010006041321720000
Version ..........: 2.1
Manufacturer .....: Yubico
Name of cardholder: <your name>
Language prefs ...: [not set]
Sex ..............: unspecified
URL of public key : https://keybase.io/<yourusername>/<gpg-key.asc>
Signature key ....: 743A 2D58 688A 9E9E B4FC  493F 70D1 D7A8 13AF CE85
Encryption key....: 8D17 89A0 5C2F B804 22E5  5C04 8A68 9CC0 D742 1CDF
Authentication key....: D6AS 5C4F B804 22E5  5C04 8A68 9CC0 C721 8DEF
```

Move the current gpg folder to test that the keys are correctly bound to the yubikey. 

```shell
$ mv .gnupg/ <chooseahomefolder>/
```

Running reinitialising the key will create new configuration files

```shell
$ gpg2 --card-status
gpg: directory '/home/<userid>/.gnupg' created
gpg: new configuration file '/home/<userid>/.gnupg/dirmgr.conf' created
gpg: new configuration file '/home/<userid>/.gnupg/gpg.conf' created
gpg: keybox '/home/<userid>/.gnupg/pubring.kbx' created
Reader ...........: 1050:0407:X:0
Application ID ...: D2760001240102010006041321720000
Version ..........: 2.1
Manufacturer .....: Yubico
Name of cardholder: <your name>
Language prefs ...: [not set]
Sex ..............: unspecified
URL of public key : https://keybase.io/<yourusername>/<gpg-key.asc>
Signature key ....: 743A 2D58 688A 9E9E B4FC  493F 70D1 D7A8 13AF CE85
Encryption key....: 8D17 89A0 5C2F B804 22E5  5C04 8A68 9CC0 D742 1CDF
Authentication key....: D6AS 5C4F B804 22E5  5C04 8A68 9CC0 C721 8DEF
```

You can reimport the public gpg key, either from the usb backup or from a public url. In this example from keybase.io
```shell
$curl https://keybase.io/<username>/<pgppubickey> | gpg2 --import
```

##GPG Config File
Edit the gpg config file with the settings specified in the github [developer user environments][https://github.com/UKorg/developer_user_environments/blob/dotfiles/.gnupg/gpg.conf]

__Note the default key is the long version to avoid collision errors (under general key info, remove 0x).__

##GPG Agent File
Created the gpg agent config file with the settings specified in the github [developer user environments][https://github.com/UKorg/developer_user_environments/blob/dotfiles/.gnupg/gpg-agent.conf)]

##Update bashrc;
Update the bashrc to bind the gpg agent for the ssh authentication socket. 

```shell
export GPG=gpg2
export SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh
```

Unplug the yubikey and kill the gpg agent;

```shell
$ killall gpg-agent
```

Check the configuration is complete by plugging the Yubikey back in, reinitialise the card and list the ssh keys loaded. 

```shell
$ gpg2 --card-status
Reader ...........: 1050:0407:X:0
Application ID ...: D2760001240102010006041321720000
Version ..........: 2.1
Manufacturer .....: Yubico
Name of cardholder: <your name>
Language prefs ...: [not set]
Sex ..............: unspecified
URL of public key : https://keybase.io/<yourusername>/<gpg-key.asc>
Signature key ....: 743A 2D58 688A 9E9E B4FC  493F 70D1 D7A8 13AF CE85
Encryption key....: 8D17 89A0 5C2F B804 22E5  5C04 8A68 9CC0 D742 1CDF
Authentication key....: D6AS 5C4F B804 22E5  5C04 8A68 9CC0 C721 8DEF
General key info..: pub rsa4096/0x493F70D1D7A813AFCE85

$ ssh-add -L
ssh-rsa <yourkeyinfo>== cardno: <cardnumber>
```

  


