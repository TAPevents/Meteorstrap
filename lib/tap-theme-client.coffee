TAPtheme_collection = new Meteor.Collection 'TAPtheme'

TAPtheme = -> TAPtheme_collection.findOne('main') || {}

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
  'theme_nonReactive' : -> TAPtheme_collection.findOne('main', {reactive:false})
  'themes' : ->
    selected = TAPtheme().theme
    _.map TAPtheme().availableThemes, (theme) ->
      name: theme
      title: if theme is 'null' then 'Vanilla Bootstrap' else toTitlecase theme
      selected: theme is selected

Template.TAPtheme_bootstrap_var_table.helpers
  'rules' : ->
    rules = []
    rule_overrides = @rule_overrides || {}
    for key,val of @defaultVars
      rules.push
        key: key
        val: val
        override: rule_overrides[key]
        description: __ "describe_#{key}", { defaultValue: "" }
    return rules

Template.TAPtheme.events
  'change input.variable-override': (e) ->
    Meteor.call 'TAPtheme_updateLessVariable', @key, $(e.currentTarget).val()

  'change textarea.custom-css' : (e) ->
    Meteor.call 'TAPtheme_updateCustomCSS', $(e.currentTarget).val()

  'change select.switch-theme' : (e) ->
    Meteor.call 'TAPtheme_switchTheme', $(e.currentTarget).val()

