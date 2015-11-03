Meteor.startup ->
  # create style tag in head for injection
  $cssInjection = $("<style></style>").prependTo 'head'

  # automatically re-inject compiled CSS
  Tracker.autorun ->
    if css = Meteorstrap.Themes.findOne(Meteorstrap.enabledTheme.get())?.compiledCss
      $cssInjection.html css
    else
      $cssInjection.html "body { display:none; } "

  # automatically re-subscribe to enabledTheme
  Tracker.autorun ->
    Meteor.subscribe 'MeteorstrapCss', Meteorstrap.enabledTheme.get()
