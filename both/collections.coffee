@BootstrapThemer = @BootstrapThemer || {}

# collections
Themes = BootstrapThemer.Themes = new Meteor.Collection 'BootstrapThemerThemes'

if Meteor.isServer
  # TODO define publishers properly
  # TODO use `check`
  adminFields =
    name: 1
    author: 1
    defaults: 1
    overrides: 1
    customLess: 1
    bootswatch: 1
    predefined: 1

  publicFields =
    compiledCss: 1

  Meteor.publish 'BootstrapThemerCss', (themeId) -> Themes.find themeId, {fields:publicFields}
  Meteor.publish 'BootstrapThemerEditor', -> Themes.find {}, {fields:adminFields}

  # TODO allow/deny