# shell

This is a doc explaining how Dahlia shell gives a consistent UX experience across Web, Desktop and Mobile using Flutter.

Its up for debate how tis relates to fuschia.

## Current problems

Lets use an example from Gmail.

On Web and Mobile its so different and messed up.


**Use case: You want to read 2 emails, whilst writing a new email.**

- Web allows you to make micro windows to write new emails
- Web allows you to just open many tabs to read the 2 emails

- Mobile has none of what web has and is just confusing.



### Sharing, Deep-linking, Bookmarks, and Continuity

Sharing involves sending a link to another app to use it.

- Web, it does not exist, but its getting there and is called web-sharing

- Desktop, its sort of there but not yet exposed in go-flutter

- Mobile, its there.

Deep-linking involves using a HTTP link and working out what app to open.
Bookmarks in a way is the same.
- Web, yes you can do it.
- Mobile, yes you can. 
- Desktop, yes but not easily with go-flutter, but its coming.

Continuity is the idea of being al to move between all your devices and have your clipboard and layout and themes all the same.
- Does not exist at all but quite easy to do if yu really want to.


## New Approach

There are 2 ways to fix this.

1. Each App has the ability to allow many views inside itself

2. Make the App allow to have many of themselves.

The Dahlia removes the difference between web, desktop and shell.

For example an OS level deep link is passing into the Shell and then in the shall it can find the app and the route to the document inside that app.

Also you can force a new "Tab" to be opened when the Deep-link occurs.

So for the Gmail example, we can have "Tabs" representing the 2 open emails and the one email your writing.

Chrome Duet is way Chrome Mobile handles this problem.

Its a Shell and allows you to open many "Tabs" of the same web page and quickly switch between them.

Here is a good example explaining it:
https://www.androidpolice.com/2019/05/28/chrome-tests-larger-bottom-bar-for-duet-with-labels-but-you-can-disable-it/



1. Have a Single Window
	- For web we just use the browser and tabs
2. Use the mobile Google Chrome Browser metaphor
	- Home takes you to your App Icons. From them a new "Tab" is opened.
	- Bookmarks, takes you to bookmarks page. From them a new "Tab" is opened.
	- Search, takes you to the Search page, with bookmarks. From them a new "Tab" is opened.
3. Tab changing is the same as the mobile Chrome Browser
	- The Tabs button opens all tabs in the View.
	- Slide between tabs.
	- Flick sideways to close.

Web
- Just tabs 
- recommended to use a New Window.

Desktop
- The shell

Mobile
- The shell



### Sharing

You will want to share an internal App / Document link via the inbuilt IM app
- This requires custom sharing inside the shell.

SO we support external sharing ?
- Not now

Web - its just a link
Desktop - internal
Mobile - internal  

### Deep Linking & Bookmarks

Every App View has a URL and type.

There are 3 ways to get a link:

1. Web

- Here we just open the Tab ( if desktop or mobile, open the App Launcher and then the Tab)

2. Inside an external email app ( or other)

- Here we open the Web tab ( if desktop or mobile, open the App Launcher and then the Tab)
- Must have app registration for Desktop / Mobile.

So when someone sends you a link via we:
- Check the path and hence work out the right App for it.
- Open a new Tab and load it.


