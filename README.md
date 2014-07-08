# tap-theme

**A Reactive Bootstrap Theme Editor for Meteor**

TAPtheme reactively compiles Bootstrap 3 with user-defined custom variables and delivers them to clients. All clients will have their CSS updated reactively without refreshing their browser.

An editor template is provided to allow easy editing of all of Bootstrap 3's LESS variables.

TAPtheme comes bundled with several Bootswatch themes.

## Quickstart

Install using meteorite

` $ mrt add tap-theme `

Add the editor template the admin section of your app

` {{> TAPtheme}} `

If you already have bootstrap-3 in your package, remove it.

` $ mrt remove bootstrap-3 `

## Coming soon

* Security for updating theme (use collection-hooks on server instead of methods, access control with regualr publish/subscribe)
* Font Uploads / Selection
* Change delivery method -- Use JSON/AJAX?
* Glyphicons Support
* More themes
* Editor UI Improvements 
  * Organized variable editor (into 'Simple', 'Advanced')
  * Controls for color picker, etc.
  * Create and Save Custom Themes

## License

MIT 2014

## Credits / Packages Used

* Bootstrap
* Bootswatch
* LESS Compiler
* Collection Hooks

Created by [Chris Hitchcott](http://github.com/hitchcott) for [TAPevents](http://tapevents.com).