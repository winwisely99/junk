# Daemon

Making servers run on Desktops and Servers reliably and to be able to update them will little to not downtime is hard.

## Backup

Prob need 2 types of backup to s3:
- We really just want to backup data.
- We could backup everything including the caddyfiles and binaries themselves also in case we loose everything.


https://github.com/restic/restic
- works on all OS's

## Caddy Proxy and LB

First on the Gateway we need Caddy V2 running as a Reverse Proxy.

Then the golang binaries are running as daemons, and self updating.
- Not sure if the Proxy will loose connection when the daemon updates. Lets see.
- The binaries will update from Github or somewhere.

examples:

https://github.com/techknowlogick/caddy-s3browser


https://docs.humio.com/integrations/proxies/how-to-configure-the-caddy-reverse-proxy-with-humio/

## Daemon runner

https://github.com/takama/daemon
- looks strong

## Restart Servers

https://github.com/jpillora/overseer
- does auto update and restart

## Restart Desktops

https://github.com/sanbornm/go-selfupdate
- Flutter Desktop can use this with go-flutter
