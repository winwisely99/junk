
## Security

The security is applied outside any code a the control plane level.

## How it works

k8 Envoy filters inspect the endpoint and apply the security.
The data driving the Authz is distributed by K8 automatically to all servers pods.

We use the following open source libraries.

## Authz
Opa ( Open Policy Framework ) allows AuthZ policies to be described and then enforced by K8 and Envoy.

- Web: https://www.openpolicyagent.org/
- Docs: https://www.openpolicyagent.org/docs/latest/
- Code: https://github.com/open-policy-agent/gatekeeper

## Auth

Ory Provides a pure golang stack for all the primitives needed.

- Web: https://www.ory.sh/

- Docs: https://www.ory.sh/docs/

- Code: https://github.com/ory

- Versions: https://www.ory.sh/docs/ecosystem/versioning


Hydra is an OAuth 2.0 and OpenID Connect Provider

- Docs: https://www.ory.sh/docs/hydra/
- Code: https://github.com/ory/hydra
	- is the only one production ready.
	- Storage using Cockroach or MySQL

ORY Oathkeeper authorizes incoming HTTP requests

- Docs: https://www.ory.sh/docs/oathkeeper/

ORY Keto is a permission server that implements best practice access control mechanisms
- Docs: https://www.ory.sh/docs/keto/
- all driven via OPA

## Client

Client Signin using: https://github.com/xebia-france/x-qrcode-flutter
- This can be included into ANY flutter app because its oAuth is so reusable.
- secrets in the secure store chip.
- QR code 
- Types / Primitives

	- Attendee: https://github.com/xebia-france/x-qrcode-flutter/blob/master/lib/visitors/attendee.dart

 	- Users and Roles: https://github.com/xebia-france/x-qrcode-flutter/blob/master/lib/organization/user.dart
	
	- Role: https://github.com/xebia-france/x-qrcode-flutter/blob/master/lib/common/common_models.dart

- Test Server env: https://github.com/xebia-france/x-qrcode-flutter/blob/master/.env

- GUI Drawer with gravatar.