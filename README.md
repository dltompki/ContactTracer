
# Fighting COVID-19 With Data
**Contact Tracer** is an app designed to store data collected by the user about their interactions during a pandemic, so that in the event of the user being tested positive, they can provide health officals with as much information as possible to help them contain the spread.
## Functionality
### HomeList
- Displays all events stored on local SQLite database
- Clicking any of the list tiles will open a detailed view of the corresponding event
### Add Event
- Accessed through the add button on the home list in the upper right corner
- **Location** 
	- Defaults to the device's current GPS location, but can be changed through the use of the search bar
	- Currently selected location can be viewed through both the map and the reverse geocoded address below the map
- **Date and Time** 
	- Defaults to the current date and time, or the most recently selected date and time
	- Can be changed through the use of the date and time pickers
	- The selected date and time are always displayed on their respective buttons
- **People**
	- Title of this section displays the selected people
	- Add button to the right of the title opens a dialogue where the user can add a new person to the checklist
		- The user can add multiple new people in one go by separating their names with a commma
	- Checklist displays all previously submitted groups and individuals, in adddition to any newly added people
### Map View
- Displays the same data as the home list in the form of markers on a full-screen google map
- The google map's camera view can be adjusted by the user
- The map defaults to being centered around the user's current location, which is displayed with a blue dot
- All of the markers can be tapped and will display the corresponding event's detailed view
### Filter By Person
- Title of checkboxes displays currently selected people
- The checkboxes can be collapsed for a cleaner view of the events, after the user has selected person(s)
- The checkboxes display all of the individuals in the database, of which the user can choose any combination of
- Events will be displayed which contain any of the selected people
- Events can be tapped to bring up their corresponding detailed view
## Motivation
Obiously the outbreak of coronavirus is a big deal, and the main motivation for this project, but there some other stuff too.
### [Code: Buffalo Hackathon](https://www.43north.org/code-buffalo/)
This project is part of my first time participating in a Hackathon. With the prompt of "helping the community", that is the big picture goal for this project.
### Learning New Technologies
In order to build this app, I have had to teach myself a few new things. Here's a list, with links for refrence:
- [Dart](https://dart.dev/)
- [Flutter](https://flutter.dev/)
- [Google Cloud (for maps api)](https://cloud.google.com/)
- [Firebase (for remote config with api keys)](https://firebase.google.com/)
- [SQLite](https://www.sqlite.org/index.html)
- [Asynchronous Programming](https://dart.dev/codelabs/async-await)
## Inspiration and Refrence
- [Contact Tracing as a concept](https://en.wikipedia.org/wiki/Contact_tracing)
- [Google and Apple's announcement of a partnership on a bluetooth contact tracing protocol](https://blog.google/inside-google/company-announcements/apple-and-google-partner-covid-19-contact-tracing-technology)
- [A similar system created by MIT](https://pact.mit.edu/)
- [SafePaths app, led by MIT, with using a path-crossing algorithm to detect if people have "crossed paths"](https://www.media.mit.edu/projects/safepaths/overview/)
## [Contact Me About This Project](https://forms.gle/ULb6ACYvJDWX3Ge68)
 Use the above link if you are interested in contributing to this project, or have a question, comment, concern, etc. Thanks for being interested in my project!