Iron.Router.plugins.BootstrapThemer = (router, options) ->
  # resolve default theme if it's a function
  # client-side hook for switching themes
  Router.onBeforeAction (router, option) ->
    console.log 'setrtting theme to',  @route.options.BootstrapThemer || BootstrapThemer.defaultTheme()
    BootstrapThemer.enabledTheme.set @route.options.BootstrapThemer || BootstrapThemer.defaultTheme()
    @next()

  # fastrender the routes
  if Meteor.isServer
    preloadThemes = options.preload || []
    unless options.fastRender is false
      # add the default theme to all routes
      FastRender.onAllRoutes ->
        @subscribe 'BootstrapThemerCss', getDefaultTheme()
        for themeId in preloadThemes
          @subscribe 'BootstrapThemerCss', themeId