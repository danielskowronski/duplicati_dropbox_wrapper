# Duplicati Dropbox Wrapper

Wrapper for Duplicati ([https://www.duplicati.com/](https://www.duplicati.com/)) client that targets Dropbox as backup location. It solves issue with very long, ugly CLI invocations and lack of Linux agent. Intented for use with cron.

For some context, especially for older version - see [https://blog.dsinf.net/2020/10/kopie-zapasowe-linuksowej-infrastruktury-i-nie-tylko-duplicati-oraz-jego-monitorowanie-za-pomoca-prometheusa/](https://www.duplicati.com/)

## Config

Example file `duplicati_wrapper.conf` should be placed in `/etc/`. It's simply *bash sourced*.

### Fields
* `DUPLICATI_PASSPHRASE` - passphrase to encrypt backups with
* `DUPLICATI_RETENTION` - see https://duplicati.readthedocs.io/en/stable/06-advanced-options/#retention-policy (the default one `1W:1D,4W:1W,12M:1M` is *smart* in Duplicati GUI)
* `DROPBOX_MASTERPATH` - folder inside `/Applications/Duplicati/` to place backup folder, that is named after hostname of machine on which script executes
* `DROPBOX_AUTHID` - see https://duplicati-oauth-handler.appspot.com/


## Usage examples

### Usage
```
$ /opt/duplicati_wrapper.sh --help
usage: /opt/duplicati_wrapper2.sh <backup,repair> SRC_PATH
$
```

### Backup
```
$ /opt/duplicati_wrapper.sh backup /var/lib/postgresql/
Backup started at 04/06/2021 18:12:23
Checking remote backup ...
  Listing remote folder ...
Scanning local files ...
  1953 files need to be examined (78.80 MB)
  Uploading file (1021 bytes) ...
  Uploading file (78.81 KB) ...
  Uploading file (925 bytes) ...
  0 files need to be examined (0 bytes)
Checking remote backup ...
  Listing remote folder ...
Verifying remote backup ...
Remote backup verification completed
  Downloading file (78.81 KB) ...
  Downloading file (925 bytes) ...
  Downloading file (1021 bytes) ...
  Duration of backup: 00:00:11
  Remote files: 38
  Remote size: 8.58 MB
  Total remote quota: 0 bytes
  Available remote quota: 0 bytes
  Files added: 0
  Files deleted: 0
  Files changed: 1
  Data uploaded: 80.71 KB
  Data downloaded: 80.71 KB
Backup completed successfully!
$
```