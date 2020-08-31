# vfs

Local dekstops should hide all data

https://github.com/capnspacehook/pandorasbox

https://github.com/FiloSottile/yubikey-agent
- save ssh and other data to yubikey

https://github.com/Avalanche-io/c4
- obfuscate anything
- database tables and filds

https://github.com/cloudflare/utahfs
- Is exactly like Google Drive, but that you control
- Backup to Minio: https://github.com/cloudflare/utahfs/blob/master/docs/setup-minio.md
- This can be part of our product.
- Just need minio in HA mode: https://docs.min.io/docs/distributed-minio-quickstart-guide.html
- Then Federate them using DNS for access: https://docs.min.io/docs/minio-federation-quickstart-guide.html
- Then deplyo on Digital Ocean: https://anthonysterling.com/posts/creating-a-distributed-minio-cluster-on-digital-ocean.html
