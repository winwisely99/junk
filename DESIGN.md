# Design

Wireguard to get onto the network. It may be that we cant use this becaue it undermins webrtc

For V1 we make all calls to the Servers, to make things SIMPLE.
For V2, we hold data on the devices, and update them using PUB SUB mailboxex

Webrtc is used to allow P2P connections.

Data
- Each "Data Provider" hosts a DB somewhere. Either int he cloud or at home ( desktop or rasp PI). There has to be an owner of the data.
- This is a WebRTC host also.
- Its a PUB / SUB system pushing protobufs ( version aware so we dont break old clients )
	- https://github.com/decentraland/webrtc-broker
		- WS and WebRTCData Channels
		- Uses Protobufs: https://github.com/decentraland/webrtc-broker
		- Has AUTH: https://github.com/decentraland/webrtc-broker/tree/master/pkg/authentication
		- Broker: https://github.com/decentraland/webrtc-broker/tree/master/pkg/broker
			- Looks stateless. We need stateful

- Each Module has its own "Server" module and name space
	- So a ser account or a high level component uses the Module as tells the module to save ti s data.
	- Then it saves its own data with the equivalent of the Foreign key.
	- This works fine for a Key Value style data base system which is what we need in order to do sycnhronisation. You cant do synchronisation with a SQL Database.

Flutter Client
- No state except cache that gets filled baed on Data Subscriptions from the Data Provider.

Global
- There are many Data Providers and so we need a global system to link them.
