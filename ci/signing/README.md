# Signing




here's a script in use that signs a go binary, packages in dmg, then signs and notorizes the dmg via the CLI.

https://github.com/99designs/aws-vault/pull/435
https://github.com/99designs/aws-vault/blob/master/bin/create-dmg


---

Must provide Hardened Runtime for MAC now

https://github.com/golang/go/issues/34986
- good info



Try this puppy out.
Andrei Lesnitsky
AltSign is my internal framework used by both AltStore and AltServer to communicate with Apple's servers and resign apps. For more info, check the AltSign repo.
https://github.com/rileytestut/AltSign
https://github.com/rileytestut/AltStore

