# Hosting

## Deploy to Hetzner

https://github.com/hetznercloud/cli

- Iceland and Germany is just enough for base Servers to have enough Privacy
- Is dirt cheap shitty servers but should be fine since we have RAFT data synchronisation

## Deploy to Google

For anything infra we need to run everything on Hetzner

- Binary Server
- Backups of data from Hetzner
- Maybe others...

### CDN

Its an added complexity but we might want to deploy the Statics to a CDN 

Options:

Google
- Can leave DNS at Google Domains i think then.
- PUt in S3
- Configure Global HTTP Load Balancer. Thats solves the HTTP Load balancing for us.
- Can Design our Server binary to push the statics to Google Bucket
	- We need this anyway to do backups / snaps shots of the Server data, so is nice and tidy.

Cloudflare
- Yeah but has lots of restrictions and i like the Google S3 bucket cause its super simple.

Our Own
- Google Load Balancing is fucking expensive
- Just ourServer binary and nothing to do except LB. I like ti :)
- Who to use ?
- Packet ? Others ? 


## DNS

Currently using Google Domains.
- Works fine
- Have to check if DNS Load balancing works

## Certs

- Expire in 90 days !!
- https://letsencrypt.org/docs/faq/#what-is-the-lifetime-for-let-s-encrypt-certificates-for-how-long-are-they-valid

## DDOS Attacking

We have Google Project Shield sponsoring and so we can use this.
- https://projectshield.withgoogle.com/sites

https://www.techradar.com/news/best-ddos-protection

https://support.projectshield.withgoogle.com/s/article/Set-up-your-website-with-Project-Shield?language=en_US

How can we automate updating the Certs to Project Shield ?
- Sent Stef an email about it and waiting to hear..

Need to setup Firewalls rules automatically on each of our Servers to limit trafic ONYL to Project Shield
-  35.235.224.0 / 20
- See bottom of page: https://support.projectshield.withgoogle.com/s/article/Set-up-your-website-with-Project-Shield?language=en_US

## Load balancing

Will be needed.
- Hate needing to put a load balancer in front. SPOF ( Single Point of Failure )
- Envoy can do it BUT very hard to control
- Investigate other options.

SO use DNS load balancing for GRPC, HTTP traffic.
- HTTP will be handled by the CDN on Google ( see above )
- What abut GRPC to our Origin Servers ?

Options:

https://godoc.org/google.golang.org/grpc/balancer?importers

- https://github.com/gfanton/grpc-quic
	- Uses QUIC and gopherjs. Cant use for this ubut maybe later when we get embedding golang in the client working.
	- https://github.com/mandu-man/cs450-k8s-quic
		- extends it with routing
		- designed for Comms between servers running in k8.

- DNS SRV records

	


