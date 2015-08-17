@BootstrapThemer = @BootstrapThemer || {}

Themes = BootstrapThemer.Themes

enabledTheme = BootstrapThemer.enabledTheme = new ReactiveVar BootstrapThemer.defaultTheme()

Meteor.startup ->
  # create style tag in head for injection
  $cssInjection = $("<style></style>").prependTo 'head'

  # automatically re-inject compiled CSS
  Tracker.autorun ->
    if css = Themes.findOne(enabledTheme.get())?.compiledCss
      $cssInjection.html css

  # automatically re-subscribe to enabledTheme
  Tracker.autorun ->
    Meteor.subscribe 'BootstrapThemerCss', enabledTheme.get()
