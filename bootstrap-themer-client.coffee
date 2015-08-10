BootstrapThemer_collection = new Meteor.Collection 'BootstrapThemer'

@BootstrapThemer = -> BootstrapThemer_collection.findOne('main') || {}

Meteor.startup ->
  $bootstrapCSS = $("<style id='tap-bootstrap-themer-bootstrap'></style>")
  $customCSS = $("<style id='tap-bootstrap-themer-custom-css'></style>")

  $('head')
  .prepend $bootstrapCSS
  .append $customCSS

  # update <style> tags in <head> reactively
  Deps.autorun ->
    $bootstrapCSS.html BootstrapThemer().bootstrapCSS
    $customCSS.html BootstrapThemer().customCSS

toTitlecase = (str) ->
  str.replace /\w\S*/g, (txt) -> txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

Template.BootstrapThemer.helpers
  'theme' : -> BootstrapThemer()
  'theme_nonReactive' : -> BootstrapThemer_collection.findOne('main', {reactive:false})
  'themes' : ->
    selected = BootstrapThemer().theme
    _.map BootstrapThemer().availableThemes, (theme) ->
      name: theme
      title: if theme is 'null' then 'Vanilla Bootstrap' else toTitlecase theme
      selected: theme is selected


BootstrapMagic.on 'start', ->
  @setOverrides BootstrapThemer().rule_overrides
  @setDefaults BootstrapThemer().defaultVars

BootstrapMagic.on 'change', (change) ->
  key = Object.keys(change)[0]
  val = change[key]
  Meteor.call 'BootstrapThemer_updateLessVariable', key, val

Template.BootstrapThemer.events
  'change textarea.custom-css' : (e) ->
    Meteor.call 'BootstrapThemer_updateCustomCSS', $(e.currentTarget).val()

  'change select.switch-theme' : (e) ->
    Meteor.call 'BootstrapThemer_switchTheme', $(e.currentTarget).val()

# todo implement fastrender like quickCss