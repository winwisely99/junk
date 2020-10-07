# Telemetry

## Needs

- PECR compliant
	- https://ico.org.uk/for-organisations/guide-to-pecr/what-are-pecr/
- GDPR compliant
	- https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/lawful-basis-for-processing/consent/
-  compliant
	- https://secureprivacy.ai/what-is-ccpa-and-how-to-become-compliant/

- Dev Telemetry
	- Can be part of single binary.
		- But can be stood up itself too, because you want to be able to run long term storage.
	- GRPC Middleware
		- so easy to instrument
	- Logs
	- Metrics
			

- Biz Analytics
	- NOT Google or Google.
		- Joe do Due Diligence.
	- Functionality
		- Where users drop off in the flow.
		- Where geographically.
	- Tech options
		- GA is complex beast these days.
		- Open source GA equivalents exist.
		- Flutter Fire ...
		- Sentry

## Approach

Geo is needed for front end and for Analytics
- so include geo system as part of telemtry system.
- Just need to e able to drill down by country --> city --> postcode
- hold mapping in DB and provide GRPC API
- will require trans of the data stored in the actual DB later. Just how it is.

## Geo data

IP to countries mapping
- has geo mapping also ?

- API
	- https://github.com/oschwald/geoip2-golang
		- uses: https://github.com/oschwald/maxminddb-golang

- Core data updater
	- https://github.com/maxmind/mmdbwriter
		- uses: https://github.com/oschwald/maxminddb-golang

- Data updater
	- https://github.com/maxmind/geoipupdate
		- uses nothing else.



## Flutter fire

https://github.com/FirebaseExtended/flutterfire

- This out sources all of it to Google.
- Not all the libs work on Web or desktop though...


## open census

Now merged into: https://opentelemetry.io/

https://github.com/open-telemetry

Proto: https://github.com/open-telemetry/opentelemetry-proto
- no dart there.

opencensus

Can do Metrics and Traces and soon Logging. The 3 things we need in one.

https://github.com/census-instrumentation

https://opencensus.io/guides/grpc/go/

https://opencensus.io/integrations/redis/go/

https://opencensus.io/integrations/sql/go_sql/

https://opencensus.io/integrations/mongodb/go_driver/

https://opencensus.io/integrations/mongodb/mongostatusd/

## Sentry

- Server
	- https://github.com/jace-ys/sentry-operator
	- NOT golang so not ok.
- Flutter support is official: https://docs.sentry.io/platforms/flutter/
	- https://github.com/flutter/sentry
		- works on web
	- is updated often

## Fathom

- https://github.com/usefathom/fathom
- Way too expensive
- Open version lacks geo tracking. 
- What it does is VERY simple. Not hard to built your own actually with our standard DB
