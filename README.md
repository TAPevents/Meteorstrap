# Meteorstrap

### The Ultimate Bootstrap Theme Manager for Meteor

Meteorstrap providess an interface for effortlessly creating and editing Bootstrap Themes, whilst reactively compiling and delivering theme CSS to clients. It's a replaement for the static Bootstrap package for Meteor, and it allows you to edit your project's Boostrap CSS themes in-app and without any CSS knowledge.

Meteorstrap was created by [TAPevents](http://github.com/tapevents) - we make [apps for events](http://tapevents.com).

## Features

* **Rich Theme Editor**; BootstrapMagic+ allows you to effortly tweak any Bootstrap LESS varaible
* **On-the-fly CSS updates** in-app, to all clients without refreshing their session
* **Route-based themes**; you can style `/admin` routes differently without worrying about namespacing
* **Free-type custom LESS** to build or tweak your themes
* **Fast-rendered CSS** is sent in initial payload
* [TODO] **Easily import/export** themes in familiar Bootswatch format
* **Free themes** optionally include all [Bootswatch](http://bootswatch.com) themes
* **Full i18n** via tap-i18n; pull requests in your locale encouraged!

## Quickstart

**Want to jump right in?** Clone this repo and run `meteor` in the `/example/` project for a sample implementaiton.

For new/existing Meteor projects: 

1. If you already use a Bootstrap 3 package, remove it.
2. Add the packge using `meteor add tap:meteorstrap` (and `tap:meteorstrap-bootswatch` if you want some free themes to get you going)
3. Include the editor template somewhere in your project using `{{> Meteorstrap}}`

That's it! If need to manage permissions, continue reading below.

## What does it do?

On the client, a template is provided that uses [`tap:bootstrap-magic-plus`](https://github.com/hitchcott/meteor-bootstrap-magic) to allow for programmerless editing of all of Bootstrap 3's LESS variables. Editors can clone/edit/remove custom themes, edit custom LESS, and set which theme is used as the default for your project. You can also require and edit 3rd party themes, such as [`tap:meteorstrap-bootswatch-themes`](https://github.com/tapevents/meteorstrap-bootswatch-themes), which contains all the latest [Bootswatch Themes](https://bootswatch.com/).

Whenever you update a theme, it will be automatically updated and sent to clients. If you edit or set the default theme, clients' active sessions CSS will update reactively. If a theme varaible is edited, an `override` is set on that theme, which will trigger a CSS re-render on the server side. This will bundle and compile into CSS the following files in the following order: Bootstrap itself, Theme `default` variables, Theme `override` variables, Theme LESS, Custom LESS.

This compiled CSS is published and re-injected into the `head` of clients whenever it is changed, and is sent in the initial payload of new connections by default using `meteorhacks:fastrender`.

## Editing Themes

Once you're set up and can access the GUI, we can step through how to edit themes. For more information specific to BootstrapMagic+, please refer to those docs. We'll briefly cover some of those features below, but not extensively.

For a tutorial on how to get started with editing, please read this guide and for the video-learners, watch this video: [TBC]

### Tweaking Theme Variables

By default, Meteorstrap will come with at least one theme, Vanilla Bootstrap by Twitter, which is plain old Bootstrap with no custom variables and no custom LESS. If you've changed the default theme to something else, change it back to Vanilla Bootstrap for the sake of this guide.

Visit the editor page, and you'll see Custom LESS and Theme Less. Ignore those for now. Scroll down a bit to the variables section, peruse the available options, navigate around, and search for `@grey-base`. Let's override this with `red`. As soon as you make the change, you should notice that all of the text is now red! Wow. Meteorstrap just re-compiled Bootstrap but with a red grey-base.

Whenever you override a variable in the editor, an `override` is created for that particular variable, which is used instead of the `default` variable. Each time you change a varaible the theme is recompiled, so as you tweak the variables in the editor, you'll notice the CSS automatically changes with in a few seconds.

Play around for a bit, and try to make your theme as ugly as possible.

Now let's reset the theme to default Vanilla Bootstrap, by clicking the 'Editing: ...' button at the top and hitting 'Reset Theme'. After confirming, you'll be back to plain old Bootstrap.

### Edit Custom LESS

You can also enter custom LESS (including variables) in the custom LESS box. To try this out, let's write the following: 

```less
body { 
  background: lighten(@brand-primary, 40%); 
}
```
This is LESS, which is similar to CSS (and is backwards compatible), but allows you to have functions and variables as above. Read more about less over at http://lesscss.org/. The example above should turn your background a nice baby blue. Feel free to write your own other LESS/CSS.

If you notice an error message appear above this box, there was a problem compiling the theme which probably means there is a syntax error somewhere. It's most likely in custom CSS but could also be in any of the variables boxes.

### Creating a Custom Theme

When you're happy with your changes, why not convert this into a new theme? This way, you can always revert back to Vanilla Bootstrap if you want to.

Simply click the 'Clone Theme' button, which will prompt you to enter a theme name and an author name. It will copy the current theme and use it to generate a new user-defined theme. All that's happening here is that vanilla `overrides` are being saved as `defaults` of the new theme and Custom LESS is being added to vanilla Theme LESS.

You can then go on to make your own overrides and custom less on your theme and can revert back at any time. Remember, the flow for building your own theme goes as follows:

1. Identify a 'base theme' you wish to build from
2. Enter all of the overrides and custom CSS you want
3. Use 'clone theme' once it's ready
4. Reset the old theme unless you want to tweak it further


## Custom Routes

Meteorstrap will, by default, render the `default` theme on all routes, the default theme can be set the GUI. If you'd like to have different themes for different routes, Meteorstrap supports this by hooking into iron:router:

```coffeescript
Router.plugin 'Meteorstrap', preload: ['yeti']
Router.route 'admin', Meteorstrap: 'yeti'
```

The above shows all you'd need to do to use the bootswatch theme `yeti` on the admin route. The optional `preload` setting shown above will cause the CSS to be injected into the intial response HTML, making the loading of the sucscription instantaneous.

## Security

Meteorstrap uses allow/deny for collection security. There is only one collection, `MeteorstrapThemes`, which contains all available themes including user generated themes. Please secure this selection using typical (allow/deny pattern):

```coffeescript
Meteorstrap.Themes.allow # or `Meteorstrap.Themes.deny`
  insert: -> ... # custom logic here
  update: -> ... # custom logic here
  remove: -> ... # custom logic here
```

Meteorstrap does not provide rate limiting, and the expensive rendering of CSS occurs every time any of the following fields change: `defaults`, `overrides`, `bootswatch`, `customLess`. So make sure only your admin users can modify this collection!

Additioanlly, there is one publication that you might want to limit access to, but there's nothing secret in there except for CSS. You can override the authentication function to secure the publication. Return any truthy value to allow access.

```
Meteorstrap.publishEditorTo = ->
  # `this` is the publication context, for example:
  Roles.userIsInRole @userId, 'admin'
```

By default, `publishEditorTo` returns `true`, so all themes can be accessible by all clients.

Apart from this, there is one unsecured publication called `MeteorstrapCss` which is automatically subscribed to by clients and contains the compiled CSS, and a `null` publication, which only contains the `default` theme `_id`. There is no need to secure these publications.

## Advanced

Meteorstrap is designed to work out of the box with minimal setup for project devleopers, but this section will help you understand how it works and what's available as a package developer.

Here's every method avialable in a project that includes Meterostrap:

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

BootstrapMagic+ also exposes some useful methods that are covered in it's documentation.


### Creating a Predefined Theme

Predefined themes are any themes that are included as packages via the `registerPredefinedTheme` method. Non-predefined themes (user-defiend) are always cloned from an existing theme (or plain bootstrap).

Have a look at the meteorstrap-bootswatch-themes package for an example of how to package a custom theme that's compatible with Meteorstrap. It's basically a case of copy-pasting the Bootswatch format (`bootswatch.less` and `variables.less`), adding it as an asset, and envoking:

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

## Todos

```
For v0.1 (beta)
- Documentation
- english i18n

For v1.0 (public release)
- Import/export bootswatch files
- Unit tests

After v1.1
- Export bootswatch / less variables file
- Option for user-defined themes
- TAPmedia integration + UI For:
  - Font uploads
  - Backgroud images
  - Icon packs
```

## License

MIT, 2014

## Credits / Packages Used

* Bootstrap
* BootstrapMagic
* Bootswatch
* LESS Compiler

Created by [Chris Hitchcott](http://github.com/hitchcott) for [TAPevents](http://tapevents.com).