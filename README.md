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
For v1.0
- Custom Theme Creation / Removing (create a new theme by cloning an old theme, use the overrides as defaults, move CustomCSS to end of bootswatch)
- FastRender + IronRouter integration (route-based themes)
  - Default theme
  - Set theme for all /admin/ routes, e.g. w/ fastrender
- Security for updating themes (is this 'Solved' with allow/deny?)
- 'Register Theme' method, rather than bundling all themes, create seperate package for bootswatch themes
- Basic unit tests
- Documentation

For v1.1
- TAPmedia integration + UI For:
  - Font uploads
  - Backgroud images
  - Icon packs?
- Full i18n

After v1.1 / Icebucket
- Export bootswatch / less variables file
```

## License

MIT 2014

## Credits / Packages Used

* Bootstrap
* BootstrapMagic
* Bootswatch
* LESS Compiler

Created by [Chris Hitchcott](http://github.com/hitchcott) for [TAPevents](http://tapevents.com).