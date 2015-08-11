@BootstrapThemer = @BootstrapThemer || {}

Themes = BootstrapThemer.Themes

enabledTheme = BootstrapThemer.enabledTheme = new ReactiveVar 'vanilla'

Meteor.startup ->
  # create style tag in head for injection
  $cssInjection = $("<style></style>").appendTo 'head'

  # automatically re-inject compiled CSS
  Tracker.autorun ->
    $cssInjection.html Themes.findOne(enabledTheme.get())?.compiledCss

  # automatically re-subscribe to enabledTheme
  Tracker.autorun ->
    Meteor.subscribe 'BootstrapThemerCss', enabledTheme.get()
