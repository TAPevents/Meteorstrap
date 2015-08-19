@Meteorstrap = @Meteorstrap || {}

# collections
Themes = Meteorstrap.Themes = new Meteor.Collection 'MeteorstrapThemes'

Meteorstrap.defaultTheme = -> Themes.findOne({default:true})?._id

if Meteor.isClient
  Meteorstrap.enabledTheme = new ReactiveVar Meteorstrap.defaultTheme()

if Meteor.isServer
  Meteorstrap.publishEditorTo = -> true

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
    Meteor.publish 'MeteorstrapCss', (themeId) ->
      Match.Optional themeId, String
      Themes.find themeId, {fields:publicFields}

    # publish the editor info
    Meteor.publish 'MeteorstrapEditor', ->
      if Meteorstrap.publishEditorTo.apply @
        return Themes.find {}, {fields:adminFields}
      else
        return null