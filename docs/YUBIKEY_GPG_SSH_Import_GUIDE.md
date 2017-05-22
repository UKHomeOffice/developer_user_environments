# GPG Import

#### Import Public gpg key

```
gpg2 --import USER.key
```

>gpg: directory '/home/USER/.gnupg' created

> gpg: new configuration file '/home/USER/.gnupg/dirmngr.conf' created

> gpg: new configuration file '/home/USER/.gnupg/gpg.conf' created

> gpg: keybox '/home/USER/.gnupg/pubring.kbx' created

> gpg: /home/USER/.gnupg/trustdb.gpg: trustdb created

> gpg: key *A47373EF*: public key "Full UserName (Example Organisation) <
first.lastname@example.net>" imported

>gpg: Total number processed: 1

>gpg:               imported: 1


#### Configure trust of your key

```
gpg2 --edit-key A47373EF
```

>gpg (GnuPG) 2.1.11; Copyright (C) 2016 Free Software Foundation, Inc.

>This is free software: you are free to change and redistribute it.

>There is NO WARRANTY, to the extent permitted by law.

>pub  rsa4096/A47373EF

>     created: 2016-04-07  expires: 2024-05-12  usage: SC  

>     trust: unknown       validity: unknown

>sub  rsa4096/D32825B7

>     created: 2016-04-07  expires: 2024-05-12  usage: E   

>sub  rsa4096/55082046

>     created: 2016-04-07  expires: 2024-05-12  usage: S   

>sub  rsa2048/59CBD5AB

>     created: 2016-11-15  expires: 2026-11-13  usage: A   

>[ unknown] (1)  Full UserName (Example Organisation) <first.lastname@example.net>

>[ unknown] (2)  [jpeg image of size 8568]



```bash
gpg> trust
```

>pub  rsa4096/A47373EF

>     created: 2016-04-07  expires: 2024-05-12  usage: SC  

>     trust: unknown       validity: unknown

>sub  rsa4096/D32825B7

>     created: 2016-04-07  expires: 2024-05-12  usage: E   

>sub  rsa4096/55082046

>     created: 2016-04-07  expires: 2024-05-12  usage: S   

>sub  rsa2048/59CBD5AB

>     created: 2016-11-15  expires: 2026-11-13  usage: A   

>[ unknown] (1)  Full UserName (Example Organisation) <first.lastname@example.net>

>[ unknown] (2)  [jpeg image of size 8568]

>

>Please decide how far you trust this user to correctly verify other users' keys

>(by looking at passports, checking fingerprints from different sources, etc.)

>

>  1 = I don't know or won't say

>  2 = I do NOT trust

>  3 = I trust marginally

>  4 = I trust fully

>  5 = I trust ultimately

>  m = back to the main menu

>

>Your decision? *5*

>Do you really want to set this key to ultimate trust? (y/N) *y*

>

>pub  rsa4096/A47373EF

>     created: 2016-04-07  expires: 2024-05-12  usage: SC  

>     trust: ultimate      validity: unknown

>sub  rsa4096/D32825B7

>     created: 2016-04-07  expires: 2024-05-12  usage: E   

>sub  rsa4096/55082046

>     created: 2016-04-07  expires: 2024-05-12  usage: S   

>sub  rsa2048/59CBD5AB

>     created: 2016-11-15  expires: 2026-11-13  usage: A   

>[ unknown] (1)  Full UserName (Example Organisation) <first.lastname@example.net>

>[ unknown] (2)  [jpeg image of size 8568]

>Please note that the shown key validity is not necessarily correct

>unless you restart the program.


### Setup Bashrc
```
echo "export SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh" ~/.bashrc
```

### Setup gpg-agent
```bash
cat <<EOF> ~/.gnupg/gpg-agent.conf
enable-ssh-support
default-cache-ttl 300
max-cache-ttl 86400
#debug-level basic
#log-file /tmp/${USER}-gpg.log
pinentry-program /usr/bin/pinentry-gtk-2
#debug-pinentry
EOF
```

Reload any running agent under your username

```bash
killall -9 gpg-agent
```

#### Load Secret Key into gpg reference

```bash
gpg2 --card-edit
quit

```

### Display Public SSH key:

```bash
ssh-add -L
```

>ssh-rsa AAAAB3NzaC1y....i6Q== cardno:000605227028
