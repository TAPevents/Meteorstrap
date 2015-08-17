@BootstrapThemer = @BootstrapThemer || {}

# collections
Themes = BootstrapThemer.Themes = new Meteor.Collection 'BootstrapThemerThemes'

BootstrapThemer.defaultTheme = -> Themes.findOne({default:true})?._id

if Meteor.isServer
  BootstrapThemer.isEditor = -> true

  adminFields =
    name: 1
    author: 1
    defaults: 1
    overrides: 1
    customLess: 1
    bootswatch: 1
    predefined: 1
    error: 1
    default: 1

  publicFields =
    compiledCss: 1
    default: 1

  Meteor.startup ->

    # publish default theme so client knows what to sub to
    Meteor.publish null, -> Themes.find {default:true}, {fields: {default: 1}}

    # publish specific theme css
    Meteor.publish 'BootstrapThemerCss', (themeId) ->
      check themeId, String
      Themes.find themeId, {fields:publicFields}

    # publish the editor info
    Meteor.publish 'BootstrapThemerEditor', ->
      if BootstrapThemer.isEditor.apply @
        Themes.find {}, {fields:adminFields}
      else
        return null