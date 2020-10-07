# https://github.com/getcouragenow/junk/settings/hooks/new

# 1. Run Ngrok to get the URL it creates

# 2. Config the Github hook.

# 3. Run Webhook 
init:
	# ensure binary executes
	chmod +x ./webhook

ngrok-run:
	# assumes is in GOBIN

	# Web Interface                 http://localhost:4040                                             
	# Forwarding                    http://63e8a70d638f.ngrok.io -> http://localhost:8080 
	ngrok http 8080

ngrok-open:
	open http://localhost:4040 

webhook-run:
	# Serving hooks on http://0.0.0.0:8080/hooks/{id}
	./webhook -hooks hooks-githubsimple.json -port 8080 -verbose
