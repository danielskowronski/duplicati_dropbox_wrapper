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
