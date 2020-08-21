# News

Scrape Clean Energy Wire
- Got it working
- TO put in production will need 
	- a DB that Tracks what was scraped
	- a Cron scheduler to go out once a day a rescrape
	- Scheduled to run on Google so that their IP blockers are fooled.
	- Slowed down to not cause their scrape blockers to block us.
	- The best way would be to build it into the Mobile app itself and use a Command and Control Architecture in reality !!!!!!
		- But that requires embeding golang into the App as i keep suggesting.



Convert their HTML to Clean markdown
- will need 2nd parse to clean out any stuff we dont want.

Now we have markdown and can decide what to do with it.

Save into DB
- Need all that setup.
- Might need to be mapped against an Org.

If hosting inside the Flutter App,
- convert to common markdown format
- use a markdown plugin: https://pub.dev/packages/flutter_markdown
	- supports web and native :)

If hosting inside a Hugo that is AMP compliant
- convert the markdown to a common format
- See the hugo/amp folder for example


Then If we want users to write their own news Or clean up stuff fromthe conversion pipeline that is not clean.
- Need to a a form in FLutter that alows them to edit a Markdown document.
	- Not easy




