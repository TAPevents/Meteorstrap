# Meteorstrap (beta)

### A Reactive Bootstrap Theme Manager for Meteor

Meteorstrap provides an interface for effortlessly creating and editing Bootstrap Themes, whilst reactively compiling and delivering theme CSS to clients. It's a replacement for the static Bootstrap package for Meteor, and it allows you to edit your project's theme in-app and without having to know how to write CSS.

## Features

* **Rich Theme Editor**; BootstrapMagic+ allows you to effortlessly tweak any Bootstrap LESS variable
* **On-the-fly CSS updates** in-app, to all clients without refreshing their session
* **Route-based themes**; you can style `admin` routes differently without worrying about namespacing (currently supports Iron-Router only)
* **Free-type custom LESS** to build or tweak your themes
* **Fast-rendered CSS** is sent in initial payload
* **Free themes**; optionally include all [Bootswatch](http://bootswatch.com) themes via `tap:meterostrap-bootswatch`
* **Full i18n** via tap-i18n; pull requests in your locale encouraged!  
* [TODO] **Easily import/export** themes in familiar Bootswatch format

## Quickstart

**Want to jump right in?** Clone this repo and run `meteor` in the `/example/` project for a sample implementation.

For new/existing Meteor projects: 

1. If you already use a Bootstrap 3 package, remove it.
2. Add the Meteorstrap package using `meteor add tap:meteorstrap` (and `tap:meteorstrap-bootswatch` if you want some free themes to get you going)
3. Include the editor template somewhere in your project using `{{> Meteorstrap}}`

If you are using Iron-Router in your project, initialize your routes with `Router.plugin 'Meteorstrap'`, otherwise you're already done.

That's it! If need to manage permissions, continue reading below.

If you want to enable i18n, you'll also need to add `tap:bootstrap-magic` to your project for languages to switch properly.

## What does it do?

On the client, a template is provided that uses [`tap:bootstrap-magic`](https://github.com/hitchcott/meteor-bootstrap-magic) to allow for programmerless editing of all of Bootstrap 3's LESS variables. Editors can clone/edit/remove custom themes, edit custom LESS, and set which theme is used as the default for your project. You can also require and edit 3rd party themes, such as [`tap:meteorstrap-bootswatch`](https://github.com/tapevents/meteorstrap-bootswatch), which contains all the latest [Bootswatch Themes](https://bootswatch.com/).

Whenever you update a theme, it will be automatically updated and sent to clients. If you edit or set the default theme, clients' active sessions CSS will update reactively. If a theme variable is edited, an `override` is set on that theme, which will trigger a CSS re-render on the server side. This will bundle and compile into CSS the following files in the following order: Bootstrap itself, Theme `default` variables, Theme `override` variables, Theme LESS, Custom LESS.

This compiled CSS is published and re-injected into the `head` of clients whenever it is changed, and is sent in the initial payload of new connections by default using [`meteorhacks:fastrender`](https://github.com/meteorhacks/fast-render).

## Editing Themes

Once you're set up and can access the GUI, we can step through how to edit themes. For more information specific to BootstrapMagic+, please refer to those docs. We'll briefly cover some of those features below, but not extensively.

For a tutorial on how to get started with editing, please read this guide and for the video-learners, watch this video: [TBC]

An [introductory tutorial for the editor](https://github.com/tapevents/meteorstrap/TUTORIAL.md) is also available, which covers:

* Editing Variables
* Custom LESS
* Resetting Themes
* Cloning Theme
* Deleting Themes

## Custom Routes

Meteorstrap will, by default, render the `default` theme on all routes, the default theme can be set the GUI. If you'd like to have different themes for different routes, Meteorstrap supports this by hooking into iron:router:

```coffeescript
Router.plugin 'Meteorstrap', preload: ['yeti']
Router.route 'admin', Meteorstrap: 'yeti'
```

The above shows all you'd need to do to use the bootswatch theme `yeti` on the admin route. The optional `preload` setting shown above will cause the CSS to be injected into the initial response HTML, making the loading of the subscription instantaneous.

## Security

Meteorstrap uses allow/deny for collection security. There is only one collection, `MeteorstrapThemes`, which contains all available themes including user generated themes. Please secure this selection using typical (allow/deny pattern):

```coffeescript
Meteorstrap.Themes.allow # or `Meteorstrap.Themes.deny`
  insert: -> ... # custom logic here
  update: -> ... # custom logic here
  remove: -> ... # custom logic here
```

Meteorstrap does not provide rate limiting, and the expensive rendering of CSS occurs every time any of the following fields change: `defaults`, `overrides`, `bootswatch`, `customLess`. So make sure only your admin users can modify this collection!

Additionally, there is one publication that you might want to limit access to, but there's nothing secret in there except for CSS. You can override the authentication function to secure the publication. Return any truthy value to allow access.

```
Meteorstrap.publishEditorTo = ->
  # `this` is the publication context, for example:
  Roles.userIsInRole @userId, 'admin'
```

By default, `publishEditorTo` returns `true`, so all themes can be accessible by all clients.

Apart from this, there is one unsecured publication called `MeteorstrapCss` which is automatically subscribed to by clients and contains the compiled CSS, and a `null` publication, which only contains the `default` theme `_id`. There is no need to secure these publications.

## Advanced

Meteorstrap is designed to work out of the box with minimal setup for project developers, but this section will help you understand how it works and what's available as a package developer.

Here's every method available in a project that includes Meteorstrap:

```coffeescript
# client and server
Meteorstrap.Themes # The 'MeteorstrapThemes' mongo collection
Meteorstrap.defaultTheme() # Returns a single theme with `default` set to `true`

# client only
Meteorstrap.enabledTheme() # reactiveVar, returns currently enabled theme

# server only
Meteorstrap.publishEditorTo # can be overwritten with function, see 'security' above
Meteorstrap.registerPredefinedTheme() # see 'creating a custom predefined theme' below
```

BootstrapMagic+ also exposes some useful methods that are covered in [its documentation](http://github.com/tapevents/meteor-bootstrap-magic).


### Creating a Predefined Theme

Predefined themes are any themes that are included as packages via the `registerPredefinedTheme` method. Non-predefined themes (user-defined) are always cloned from an existing theme (or plain bootstrap).

Have a look at the [meteorstrap-bootswatch](https://github.com/TAPevents/meteorstrap-bootswatch) package for an example of how to package a custom theme that's compatible with Meteorstrap. It's basically a case of copy-pasting the Bootswatch format (`bootswatch.less` and `variables.less`), adding it as an asset, and invoking:

```coffeescript
BootstrapThemer.registerPredefinedTheme
  _id: "someUniqueString" # meteor-compatible string used for upserting this theme
  name: "Calm Blue Ocean"
  author: "Chris H"
  assetPath: "#{__meteor_bootstrap__.serverDir}/assets/packages/package_name/theme"   

```

A `checksum` is automatically created based on the theme assets, which will be used to automatically re-insert the theme if you update the package.

Alternatively, if you don't have an `assetPath`, you can pass in `defaults` and `bootswatch` parameters, and a custom `checksum`. Make sure the `checksum` is different if you release a new version of the package.

```coffeescript
Meteorstrap.registerPredefinedTheme
  _id: 'ugly'
  name: 'Ugly Bootstrap'
  author: 'Not Twitter'
  checksum: 'v3.3.5'
  bootswatch: 'body { background: @gray-darker; }'
  defaults:
  	'@gray-darker':'#000'
  	'@brand-primary':'red'
```

## Internationalization

This project uses [tap:i18n](https://github.com/tapevents/tap-i18n), and currently supports:

* English
* Chinese (thanks to Sarah L)

Pull requests in your native language are appreciated!

## Todos

```
For v1.0 (public release)
- Video Tutorial
- Import/Export bootswatch files
- "Sticky" Previews (follow scrolling)
- Flow-router integration
- use registerBuildPlugin for meteorstrap.bootswatch.less, meteorstrap.variables.less
  - create JS strings that gets evaluated on the server

After v1.1
- TAPmedia integration + UI For:
  - Font uploads
  - Background images
  - Icon packs
```

## Contributions

Originally created by [Chris Hitchcott](http://github.com/hitchcott) for [TAPevents](http://tapevents.com).

Contributions by [Talia S](https://github.com/titaniumtails) and Sarah L.

Pull Requests for new features and bugfixes are always welcome.

**MIT License** 2015, TAPevents - we make [apps for events](http://tapevents.com).
