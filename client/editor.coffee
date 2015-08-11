Themes = BootstrapThemer.Themes
currentTheme = new ReactiveVar 'vanilla'
getCurrentTheme = -> Themes.findOne(currentTheme.get())

Template.BootstrapThemer.onCreated -> @subscribe 'BootstrapThemerEditor'

Template._BootstrapThemer.onCreated ->
  @autorun ->
    BootstrapMagic.setDefaults getCurrentTheme().defaults
    BootstrapMagic.setOverrides getCurrentTheme().overrides

Template._BootstrapThemer.helpers
  availableThemes: -> Themes.find()
  currentTheme: getCurrentTheme

Template._BootstrapThemer.events
  'change .theme-selector' : (e) ->
    currentTheme.set e.currentTarget.value

  'change .css-box' : (e) ->
    update = {}
    update[$(e.currentTarget).attr('name')] = e.currentTarget.value
    Themes.update currentTheme.get(), $set: update

BootstrapMagic.on 'change', (change) ->
  update = overrides: {}
  key = Object.keys(change)[0]
  update.overrides[key] = change[key]
  Themes.update currentTheme.get(), $set: update