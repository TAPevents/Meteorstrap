# Meteorstrap

### The ultimate Bootstrap Theme Manager for Meteor

Meteorstrap providess an interface for creating and editing Bootstrap themes, whilst reactively compiling LESS on the server and sending that CSS back to clients.

## Features

* Rich BootstrapMagic+ Theme Editor; effortly tweak any Bootstrap LESS varaible
* Theme presets, creation, editing and switching (without restarting Meteor)
* On-the-fly css updates to all clients without refreshing their browser
* Reactive, free-type custom LESS can be added to themes
* Implements `meteorhacks:fast-render`; CSS is sent in initial payload to avoid waiting for subscription
* [TODO] Easily import/export themes in familiar Bootswatch format

## Quickstart

1. If you already use a bootstrap 3 package, remove it.
2. Add the packge using `meteor add tap:meteorstrap`
3. Include the editor template somewhere in your project using `{{> Meteorstrap}}`
4. That's it! If need to manage permissions, continue reading the guide below.

## Overview

On the client, the `[tap:bootstrap-magic-plus](https://github.com/hitchcott/meteor-bootstrap-magic)` package is implemented to allow for programmerless editing of all of Bootstrap 3's LESS variables. Project managers can also clone/edit/remove custom themes and use them as defaults - connected clients will be updated reactivley in all cases.

You can create and edit custom themes, export your themes, and require 3rd party package themes, such as `[tap:meteorstrap-bootswatch-themes](https://github.com/tapevents/meteorstrap-bootswatch-themes)`, which contains all the default [Bootswatch Themes](https://bootswatch.com/).

Whenever a varaible is edited, an `override` is set on that theme, which will trigger a theme to re-render on the server side. This will bundle and compile into CSS the following files in the following order: Bootstrap LESS, Bootstrap Variables, Theme `default` variables, Theme `override` variables, Theme LESS, Custom LESS.

This compiled CSS is published and re-injected into the `head` of clients whenever it is changed, and is sent in the initial payload of new connections by default using meteorhacks:fastrender.

## Security

Meteorstrap uses allow/deny for collection security. There is only one collection, `MeteorstrapThemes`, which contains


## Todos

```
For v0.1 (beta)
- Full english i18n
- Documentation


For v1.0 (first release)
- Import/export bootswatch files
- Unit tests

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