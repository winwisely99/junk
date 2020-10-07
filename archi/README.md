# Archi

The system is Layered.

- Layer 1
	- Gateway Server that does RPC.
	- Runs on Public Servers and is HA
		- 3 Nodes.
	- Provides Global Auth, AuthZ, GRPC Services, DB
	- Used for Directory Services.
	- Used for News
	- Enrollment to a Org / Project
	- Used to Signup / Login
	- Tunnel

- Layer 2
	- Relay Server (RTC)
	- Runs on Private Desktops and Servers and is able to run HA and not HA
		- For HA then just add more desktops or Rasp PI's
	- All RTC communications like Kanban, Chat, docs, Cal, etc
	- Holds the messages for the Users Devices.
		- NO DATA ON CLIENT.


The folders in this doc are structured not by stack by by Architectural function.

## LOE


Domain / Logic
- Signup
	- Get location
		- use this control. Hardcode the country to city mapping into GUI.
- How Enrollment Supply / Demand is uploaded ?
	- Options:
		- Uploading via the GUI AS JSON. Can reuse the GRPC CLI (auth and authz)
			- JSON maps to GRPC in the CLI, so no actual file upload.
		- Video is a single link. EASY.
- Dashboard
	- Thresholds Logic
		- Functionality is global, but thresholding numbers are specific to a Project.
	- Filters
		- Roles and Conditions
			- The thresholds will be shown in the filters.
		- Geo
			- Zip code ( no radius ).
	- Data Table
		- Delete a user.
		- Show email with mailto: link, so they can contact them with own system.
		- Show telephone so they can SMS them with own System.
	- Export Data
		- Just whats filtered in the data table.
		- CSV.
		- PDF. Out of scope.
	- Cron Job to Email based on:
		- Against the Enrollment Supply / Demand data.
		- Logic:
			- Threshold is 3 potentials, based on what user chose.

Crypto
- Put in settings as a Test harness demo.
- Useful for grants.

HA DB (embedded)
- stand up. 
	- Because Dashboard logic is relatively simple, a KV Store will work.

TLS
- AutoCert work.
	- Add DNS Record ( user )
	- Must store certs in the HA DB.

AUTH and AUTHZ
- JWT working in go and flutter
- Model the AuthZ in the HA DB
	- Loose schema
	- Org / Proj
	- Roles 
		- Admin (dashboard)
		- User (nothing)
- GUI or CLI to modify the AuthZ
	- Not needed.
- Email SMTP
	- Login Verify, Signup, change password.
	- Google email server.
-  Dev Telemetry
- Biz Analytics
	
