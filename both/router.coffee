Iron.Router.plugins.BootstrapThemer = (router, options) ->
  # resolve default theme if it's a function
  # client-side hook for switching themes
  Router.onBeforeAction (router, option) ->
    BootstrapThemer.enabledTheme.set @route.options.BootstrapThemer || BootstrapThemer.defaultTheme()
    @next()

  # fastrender the routes
  if Meteor.isServer
    preloadThemes = options.preload || []
    unless options.fastRender is false
      # add the default theme to all routes
      FastRender.onAllRoutes ->
        @subscribe 'BootstrapThemerCss', BootstrapThemer.defaultTheme()
        for themeId in preloadThemes
          @subscribe 'BootstrapThemerCss', themeId