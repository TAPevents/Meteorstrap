if Iron?
  Iron.Router.plugins.Meteorstrap = (router, options={}) ->
    # resolve default theme if it's a function
    # client-side hook for switching themes
    Router.onBeforeAction (router, option) ->
      Meteorstrap.enabledTheme.set @route.options.Meteorstrap || Meteorstrap.defaultTheme()
      @next()

    # fastrender the routes
    if Meteor.isServer
      preloadThemes = options.preload || []
      unless options.fastRender is false
        # add the default theme to all routes
        FastRender.onAllRoutes ->
          @subscribe 'MeteorstrapCss', Meteorstrap.defaultTheme()
          for themeId in preloadThemes
            @subscribe 'MeteorstrapCss', themeId
else

  if Meteor.isClient
    Tracker.autorun ->
      Meteorstrap.enabledTheme.set Meteorstrap.defaultTheme()