# embed

Embedder code written in golang.

Used for all services provided to clients.

Why ?

- Flutter is great at GUI. Foreground App
- Golang is great at networking. Background Service

## Architecture:

! Use the 15 minute poller Flutter Technique., not a background app.


- Foreground runs the Flutter Apps
- Background singleton service runs the golang code for all networking.
- IPC options
	- GRPC based IO between them OS IPC mechanism.
		- Desktop will be easy
  		- Mobile not so easy
		- Protocol buffers not GRPC

  	- Or GRPC uses a GRPC socket and so we do not have to get into the weeds of IPC.
    	- Often used approach
    	- Will be much secure if we use a Cert between Foreground and Background. Can be bootstrapped from the Server on startup.


Golang compilers:

- Web:  Golang cross compiled using TinyGO ( https://github.com/tinygo-org/tinygo ) to WASM using the Web Worker, which is basically a PUB SUB channel.

- Desktop: Golang running as a Desktop Service Or System Tray

- Mobile: Golang cross compiled using GoMobile ( https://github.com/golang/mobile ) , and running as a Background Service.


## Rationale

We are moving to a Foreground and Background process model and so embedding is not needed.

Why ? 

- UX Ergonomics

	- Apps can be segregated to all the UX multi tasking experience to be high ergonomics.

	- Allows the GUI to not stutter because of the multi threading.

- Security

	- Having the data and networking in a separate process provides more security at development time and runtime. 

	- SSO (single Sign on) is centralised to one place.

	- Multi-tenant can be done in one place independent of the OS.

- Notifications

	- Background is always running ( OS ) and so notification wake ups can be do not need the Google and Apple notification gateways and leak data.

- Data synchronisation

	- Runs in the background and so UX on app started up is instant.
  
	- Allows offline editing to work much better because the data is less old.

- Alignment

	- Mobile and Desktop have same Topology.
	
	- Web just bypasses the local golang background service and uses the Cloud Server that acts on the users behalf.

	- The same Services can run on the devices as in the cloud such as:
		- Search indexer
		- KV Store
		- VPN 
		- and other goodies that Flutter cant do.

- Interoperability

	- Others can build Apps in any languages they want.




## Flutter Dev aspects


- The background process is best thought of as a PUB SUB topic based Network.

- At Flutter GUI are essentially working at the Domain Model layer and so your models do not have to match one to one to the PUB SUB topics.

- You can remap them how you want. Its gives the Flutter app the ability to compose their Domain Models to not be a one for one match as the PUB SUB topics in the network.

- When a record changes in the Background process it will just tell the Flutter foreground app over the GRPC stream.

- We can set it up so the common Flutter code just puts it directly into HIVE, and so you just forget about it.
