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

toTitlecase = (str) ->
  str.replace /\w\S*/g, (txt) -> txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

Template.TAPtheme.helpers
  'theme' : -> TAPtheme()
  'themes' : ->
    selected = TAPtheme().theme
    _.map TAPtheme().availableThemes, (theme) ->
      name: theme
      title: if theme is 'null' then 'Vanilla Bootstrap' else toTitlecase theme
      selected: theme is selected

Template.TAPtheme_bootstrap_var_table.helpers
  'override' : ->
    # use nonReactive for rule overrides, otherwise blaze has to reredner every box on update
    TAPtheme_collection.findOne('main', {reactive:false}).rule_overrides?[@name]

Template.TAPtheme.events
  'change input.variable-override': (e) ->
    Meteor.call 'TAPtheme_updateLessVariable', @.name, $(e.currentTarget).val()

  'change textarea.custom-css' : (e) ->
    Meteor.call 'TAPtheme_updateTheme', $(e.currentTarget).val()

  'change select.switch-theme' : (e) ->
    Meteor.call 'TAPtheme_switchTheme', $(e.currentTarget).val()

