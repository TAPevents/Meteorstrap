TAPtheme_collection = new Meteor.Collection 'TAPtheme'

@TAPtheme = -> TAPtheme_collection.findOne('main') || {}

Meteor.startup ->
  $bootstrapCSS = $("<style id='tap-theme-bootstrap'></style>")
  $customCSS = $("<style id='tap-theme-custom-css'></style>")

  $('head')
  .prepend $bootstrapCSS
  .append $customCSS

  Deps.autorun ->
    $bootstrapCSS.html TAPtheme().bootstrapCSS
    $customCSS.html TAPtheme().customCSS


Template.TAPtheme.helpers
  'theme' : -> TAPtheme()
  'isSelected' : (theme) -> TAPtheme().theme is theme

Template.TAPtheme_bootstrap_var_table.helpers
  'override' : -> TAPtheme().rule_overrides?[@name]

Template.TAPtheme.events
  'change input.variable-override': (e) ->
    Meteor.call 'TAPtheme_updateLessVariable', @.name, $(e.currentTarget).val()

  'change textarea.custom-css' : (e) ->
    Meteor.call 'TAPtheme_updateTheme', $(e.currentTarget).val()

  'change select.switch-theme' : (e) ->
    Meteor.call 'TAPtheme_switchTheme', $(e.currentTarget).val()

