# admin

We have a dashboard for an Org Manager.
Its in: https://github.com/getcouragenow/packages/tree/master/mod-main
	- Has Makefile to do everything

We need a Dashboard GUI for Admin and for Ops
- Admin is for the person installing the system on a computer.
- Ops is for Ops / devs to see whats going on.

## Approach
Use GRPC because of codegen reasons and easy ability to tap into Server code.

Get it to the point that they drop the binary somewhere, run it and get an IP, and then open a Web browser to get to the IP Admin

Reuse Code from the Layer 1 Org Dashboard which allows Filtering and a Data Table and export of data.

A Setup screen for installation
- No Http yet, so they can tell use the domain they want to use and then we do the Lets Encrypt under the hood.
A Single Dashboard that gives a summary
- Metrics probably

Each Server / Service we run can have its own Route, to keep things seperate

## Lang

Use the Bootstrapper/tool/Lang tool at https://github.com/getcouragenow/bootstrap/tree/master/tool/i18n

It works off Gsheets, but thats too much work and too loose.
- Instead make it work off files in the git code and call it directly from the makefiles.

### Uses

Flutter arbs
- Generates the data for them 

MarkDown
- Generates all the langs for it.

DB
- Generates Json from JSOn that cna be loaded into the DB
- Maybe do it with Protobufs later to make it clean as using Protobufs to talk to the DB keeps everything in sync.

## Docs

DOCS really, and not admin.
https://github.com/learn-flutter-dev/flutter-widget-livebook
https://flutter-widget.live/widgets/Stepper
https://github.com/learn-flutter-dev/flutter-widget-livebook/blob/master/pages/widgets/Stepper.mdx
- Flutter Web that renders markdown but is live ....
- Its JS wrapping Flutter ( See the UI explorer)
- If we wanted to document the system from a GUI usage perspecive its not too bad.

## WebSite

https://github.com/sbis04/explore
https://sbis04.github.io/explore/#/
- workflow for dev
	- https://github.com/sbis04/explore/blob/master/.github/workflows/workflow.yml
	- simple and clean. We can point to our Server with cors.
- using:
	- https://github.com/sbis04/sign_in_flutter
		- Doc: https://medium.com/flutter-community/flutter-implementing-google-sign-in-71888bca24ed
		- works well for us
- Dev:
	- Single page loads everything: https://github.com/sbis04/explore/blob/master/lib/screens/home_page.dart

## Signin

https://github.com/funwithflutter/lit_firebase_auth
https://github.com/funwithflutter/lit_firebase_auth_ui_demo
- works with all plus custom.

https://github.com/lymtechx/easy_firebase_auth
- alsp good.


## Data

https://github.com/flutterdata
- This uses Hive and Riverpod and looks perfect
	- This makes the Flutter Code testable !!!
- docs
	- https://flutterdata.dev/cookbook/models/

- Best Example
	- https://github.com/flutterdata/flutter_data_setup_app
		- code and abstraction looks clean
		- Needs Protobuf layer but thast easy because it can marshall into JSON 
- data
	- https://github.com/flutterdata/demo
		- NIce way to prototype.
		- Called from here: https://github.com/flutterdata/flutter_data_todos/blob/master/lib/models/_adapters.dart

## Video

https://pub.dev/packages/video_player
- Works for Web now :)

## Markdown

Use markdown to drive the content
- inline of from URL.

## Forms

Need this because we will have a tons of forms.

https://github.com/joanpablo/reactive_forms
- Looks like the right mix 
- Has Validators for local and remote data ( calls to Serevr and back).


