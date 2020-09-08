# NoCD Continuous Delivery System

![Build Status](https://github.com/naiba/nocd/workflows/Build%20Docker%20Image/badge.svg)

**NoCD** is a lightweight and controllable continuous delivery system implemented by Go.

## Interface preview

| ![Homepage screenshot](https://github.com/naiba/nocd/raw/master/README/Homepage screenshot.png) | ![Server Management](https://github.com/naiba/nocd/raw /master/README/Server Management.png) | ![Project Management](https://github.com/naiba/nocd/raw/master/README/Project Management.png) |
| ------------------------------------------------- ----------- | -------------------------------------- ---------------------- | --------------------------- --------------------------------- |
| ![Delivery Record](https://github.com/naiba/nocd/raw/master/README/Delivery Record.png) | ![Management Center](https://github.com/naiba/nocd/raw /master/README/View log.png) | ![View log](https://github.com/naiba/nocd/raw/master/README/管理中心.png) |

## Features

-Server: Multiple deployment servers can be added
-Project: Support parsing Webhooks of various popular Git hosting platforms
-Notification: Flexible custom Webhook
-Delivery record: You can view the deployment record, and the user can stop the deployment process
-Management panel: View system status, manage users, and manage deployment processes

## Deployment means north

### Docker

1. Create a configuration file (eg `/data/nocd` folder)

   ```shell
   nano /data/nocd/app.ini
   ```

   Refer to the following for the content of the file (`web_listen = 0.0.0.0:8000` configuration do not change)

2. Run NoCD

   ```shell
   docker run -d --name=nocd -p 8000:8000 -v /data/nocd/:/data/conf docker.pkg.github.com/naiba/dockerfiles/nocd:latest
   ```

### Source code compilation

1. Clone source code

2. Enter the application directory `cd nocd/cmd/web`

3. Compile the binary

   ```shell
   go build
   ```

4. Create a configuration file in `conf/app.ini`

   ```ini
   [nocd]
   cookie_key_pair = i_love_NoCD
   debug = true
   domain = your_domain_name # or ip:port
   web_listen = 0.0.0.0:8000
   loc = Asia/Shanghai
   [third_party]
   google_analysis = "NB-XXXXXX-1" # optional
   github_oauth2_client_id = example
   github_oauth2_client_secret = example
   sentry_dsn = "https://example:xx@example.io/project_id" # optional
   ```

5. Run

   ```shell
   ./web
   ```

6. Set the callback in `GitHub`: `http(s)://your_domain_name/oauth2/callback`

## common problem

1. Why does my deployment script always fail to execute or not executed at all?

    > Please check whether your PATH path is imported, it is recommended to export the path in advance, it will not be automatically deployed
    >
    > `source .bash_profile`.

2. How to keep running in the background?

    > You can use `systemd`. It is more recommended to run in docker mode.

## License

MIT