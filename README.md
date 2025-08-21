# zccembackup - Autometic Backup and Google Drive Upload Script for Zextras Carbonio CE

This script is forked from [anahuac.eu/from-zmbackup-to-cmbackup](https://www.anahuac.eu/from-zmbackup-to-cmbackup/)

Tested on Latest Zextras Carbonio CE 25.6.1

=========

For many many years Luca’s [zmbackup](https://github.com/lucascbeyeler/zmbackup) saved our lives and souls with his Free Software zmbackup implementation. So, let me start congratulating and thanking him deeply. Zmbackup have all needed functions to backup and restore Zimbra’s mailboxes fully and incremental.

Once Zextras Carbonio CE became the right Zimbra OSE alternative we needed a tool to do the same job in the same way on it. So I took the easiest path: rename zmbackup to cmbackup.
Fixing command paths in the code and adding a minor change to prevent timeout in restore and that was it. I hope you enjoy it.



[![Carbonio CE Version](https://img.shields.io/badge/Carbonio%20CE-25.6.1-orange.svg)](https://zextras.com/carbonio-community-edition)
![Linux Distro](https://img.shields.io/badge/platform-CentOS%20%7C%20Red%20Hat%20%7C%20Ubuntu-blue.svg)
![Branch](https://img.shields.io/badge/Branch-Stable-green.svg)
![Release](https://img.shields.io/badge/Release-1.2.9-green.svg)


Features
------------
* Online Backup and Restore - no need to stop the server to do;
* Backup routines for one, many, or all mailbox, accounts, alias and distribution lists;
* Restore the routines in your respective places, or inside another account using Restore on Account;
* Multithreading - Execute each rotine quickly as possible;
* Have some insights about eacho backup routine;
* Receive alert everytime a backup session begins;
* Better internal garbage manager;
* Filter the accounts that should not be execute with blocked lists;
* Log management compatible with rsyslog;
* Sessions stored in a relational database - SQLITE3 only - or TXT file;

Installation
------------
Inside the project folder, execute the script **install.sh** and follow all the instructions to install the project. To validate if the script is installed, change to your server's zimbra user and execute cmbackup -v.

```
# cd cmbackup
# ./install.sh
# su - zextras
$ cmbackup -v
  cmbackup version: 1.2.6
```

Usage
------------

To check all the options available to cmbackup, just execute **cmbackup -h** or **cmbackup --help**. This will return for you a list with all the options, what each one of them does, and the syntax.

```
$ cmbackup -h
usage: cmbackup -f [-m,-dl,-al,-ldp, -sig] [-d,-a] <mail/domain>
       cmbackup -i <mail>
       cmbackup -r [-m,-dl,-al,-ldp, -sig] [-d,-a] <session> <mail>
       cmbackup -r [-ro] <session> <mail_origin> <mail_destination>
       cmbackup -d <session>
       cmbackup -m

Options:

 -f,  --full                      : Execute full backup of an account, a list of accounts, or all accounts.
 -i,  --incremental               : Execute incremental backup for an account, a list of accounts, or all accounts.
 -l,  --list                      : List all backup sessions that still exist in your disk.
 -r,  --restore                   : Restore the backup inside the users account.
 -d,  --delete                    : Delete a session of backup.
 -hp, --housekeep                 : Execute the Housekeep to remove old sessions - Zmbhousekeep
 -m,  --migrate                   : Migrate the database from TXT to SQLITE3 and vice versa.
 -v,  --version                   : Show the cmbackup version.
 -h,  --help                      : Show this help

Full Backup Options:

 -m,   --mail                     : Execute a backup of an account, but only the mailbox.
 -dl,  --distributionlist         : Execute a backup of a distributionlist instead of an account.
 -al,  --alias                    : Execute a backup of an alias instead of an account.
 -ldp, --ldap                     : Execute a backup of an account, but only the ldap entry.
 -sig, --signature                : Execute a backup of a signature.
 -d,   --domain                   : Execute a backup of only a set of domains, comma separated
 -a,   --account                  : Execute a backup of only a set of accounts, comma separated

Restore Backup Options:

 -m,   --mail                     : Execute a restore of an account,  but only the mailbox.
 -dl,  --distributionlist         : Execute a restore of a distributionlist instead of an account.
 -al,  --alias                    : Execute a restore of an alias instead of an account.
 -ldp, --ldap                     : Execute a restore of an account, but only the ldap entry.
 -ro,  --restoreOnAccount         : Execute a restore of an account inside another account.
 -sig, --signature                : Execute a restore of a signature.
 -d,   --domain                   : Execute a backup of only a set of domains, comma separated
 -a,   --account                  : Execute a backup of only a set of accounts, comma separated
```

To execute a full backup routine, which include by default the mailbox and the ldiff, just run the script with the option **-f** or **--full**. Depending of the ammount of accounts or the number of proccess you set in the option **MAX_PARALLEL_PROCESS**, this will take sometime before conclude.

```
$ cmbackup -f
```

You can filter for what you want using the options **-m** for Mailbox, **-ldp** for Accounts, **-al** for Alias, and **-dl** for Distribution List. REMEMBER - This options doesn't stack with each other, so don't try -dl and -al at the same time (The script will only broke if you do this).

**CORRECT**
```
$ cmbackup -f -m
```

**INCORRECT**
```
$ cmbackup -f -m -ldp
```

Aside from the full backup action, cmbackup still have a option to do incremental backups. This works like this: before a incremental be executed, cmbackup should check the date for the latest routine for each account, and execute a restore action based on that date. At the moment, the incremental will backup the ldap account and the mailbox, and accept no paramenter aside the list of accounts to be backed up.

```
$ cmbackup -i
```

To restore a backup, you use the option **-r** or **--restore**, but this time you should inform the ID session you want to restore. You can check the sessionID with the command cmbackup -l.

```
$ cmbackup -l
+---------------------------+--------------+--------------+----------+----------------------------+
|       Session Name        |    Start     |    Ending    |   Size   |        Description         |
+---------------------------+--------------+--------------+----------+----------------------------+
| full-20180408160227       |  04/08/2018  |  04/08/2018  | 76K      | Full Account               |
| mbox-20180408160808       |  04/08/2018  |  04/08/2018  | 40K      | Mailbox                    |
+---------------------------+--------------+--------------+----------+----------------------------+


$ cmbackup -r full-20170621201603
```

The restoreOnAccount act different of the rest of the restore actions, as you should inform the account you want to restore, and the destination of that account, aside from the sessionID. This will dump all the content inside that account from that session in the destination account.

```
$ cmbackup -r -ro full-20170621201603 slayerofdemons@boletaria.com chosenundead@lordran.com
```

To remove a backup session, you only need to use the option **-d** or **--delete**, and inform the session you want to delete. Or, if you want to remove all the backups before X days, you can use the option **-hp** or **--housekeep** to execute the Housekeep process. **WARNING**: The housekeep can take sometime depending the ammount of data you want to remove.

```
$ cmbackup -d full-20170621201603
$ cmbackup -hp
```

cmbackup is capable to migrate from TXT to SQLite3, if you want to store you data inside a relational database. The advantage of doing this is more efficience when trying to list the sessions, and more details when you do this (like the beginning and conclusion of the session). To enable the SQLite3, first edit the option SESSION_TYPE insinde cmbackup.conf:

```
# vim /etc/cmbackup/cmbackup.conf
...
SESSION_TYPE=SQLITE3
```

With the SQLITE3 option enabled, now you need to migrate your entire sessions.txt to the relational database using the option **-m** or **--migrate**. After the end of the migration, you can run all cmbackup commands again.

```
$ cmbackup -m
```

**REMEMBER:** at this moment, this migration activity is a only one way road. There is no rollback, and, if you try to do a rollback, you will lost your sessions file.

Scheduling backups
------------

The installer script automatically creates a cron config file in `/etc/cron.d/cmbackup`. You can customize backup routines editing that file.
