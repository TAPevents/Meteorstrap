# BootstrapThemer

**A Reactive Bootstrap Theme Editor for Meteor**

BootstrapThemer reactively compiles [Bootstrap 3](https://github.com/twbs/bootstrap) with user-defined custom variables and delivers the CSS to clients, who will have their stylesheets updated without refreshing their browser.

The [Bootstrap Magic](https://github.com/hitchcott/meteor-bootstrap-magic) package is implemented to allow easy editing of all of Bootstrap 3's LESS variables.

BootstrapThemer comes bundled with several [Bootswatch](https://github.com/thomaspark/bootswatch/) themes.

## Quickstart

If you already use a bootstrap 3 package, remove it.

Install using `meteor add tap:bootstrap-themer`

Include the editor template somewhere in your project `{{> BootstrapThemer}}`

## Features

* Theme Presets and Switching - Includes bootstswatch themes
* On-the-fly css updates to all clients without refreshing their browser
* Super-detailed tweaking without CSS knowledge using Bootsrap variables
* Free-type custom CSS overrides
* BootstrapMagic+ Theme Editor (with enhanced UI)

## Todo


```
For v0.1 (beta)
x 'Register Theme' method, rather than bundling all themes, create seperate package for tap:bootstrap-themer-bootswatch-themes
x FastRender + IronRouter integration (route-based themes)
  x Default theme
  x Set theme for all /admin/ routes, e.g. w/ fastrender
x Security for updating themes (is this 'Solved' with allow/deny?)

- Full english i18n
- Documentation


For v1.0
- Unit tests
- Import/export bootswatch files

After v1.1
- Export bootswatch / less variables file
- TAPmedia integration + UI For:
  - Font uploads
  - Backgroud images
  - Icon packs?
```

## License

MIT 2014

## Credits / Packages Used

* Bootstrap
* BootstrapMagic
* Bootswatch
* LESS Compiler

Created by [Chris Hitchcott](http://github.com/hitchcott) for [TAPevents](http://tapevents.com).