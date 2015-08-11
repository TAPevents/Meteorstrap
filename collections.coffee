@BootstrapThemer = @BootstrapThemer || {}

# collections
Themes = BootstrapThemer.Themes = new Meteor.Collection 'BootstrapThemerThemes'

if Meteor.isServer
  # TODO define publishers properly
  # TODO use `check`
  adminFields =
    defaults: 1
    overrides: 1
    name: 1
    customLess: 1
    bootswatch: 1
    predefined: 1

  publicFields =
    compiledCss: 1

  Meteor.publish 'BootstrapThemerEditor', -> Themes.find {}, {fields:adminFields}
  Meteor.publish 'BootstrapThemerCss', (themeId) -> Themes.find themeId, {fields:publicFields}

  # TODO allow/deny