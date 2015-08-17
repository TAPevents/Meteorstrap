fs = Npm.require 'fs'
less = Npm.require 'less'

Themes = Meteorstrap.Themes
assetsRoot = "#{__meteor_bootstrap__.serverDir}/assets/packages/tap_meteorstrap/lib/less"
bootstrapPath = "#{assetsRoot}/bootstrap"
rootFile = "bootstrap.import.less"

# read bootstrap variables once, keep in memory for future compilation.
bootstrapLESS = fs.readFileSync "#{bootstrapPath}/#{rootFile}", 'utf8'

renderTheme = (themeId) ->
  thisTheme = Themes.findOne themeId
  # build the less file
  lessBundle = ""
  # add default bootstrap less, which includes the variables
  lessBundle+= bootstrapLESS
  # add theme defaults
  for key, val of thisTheme.defaults || {}
    if val and val isnt ''
      lessBundle+= "#{key}: #{val};\n"
  # add theme overrides
  for key, val of thisTheme.overrides || {}
    if val and val isnt ''
      lessBundle+= "#{key}: #{val};\n"
  # always add/override font path specific to Meteorstrap for glyphicons
  lessBundle+= "@icon-font-path: \"/packages/tap_meteorstrap/lib/fonts/\";\n"
  # add bootswatch theme
  lessBundle+= thisTheme.bootswatch || ""
  # add custom less
  lessBundle+= thisTheme.customLess || ""
  # now try parsing it all
  parsed = do Meteor._wrapAsync (done) ->
    less.render lessBundle,
      paths: [bootstrapPath] # include all imports
      compress: true
    , done

  return parsed?.css


# Use cfs:powerer-queue to handle throttling etc.
queue = new PowerQueue maxFailures: 1

updateTheme = (_id) ->
  queue.add (done) ->
    try
      if renderedCss = renderTheme _id
        Themes.update _id, $set: compiledCss: renderedCss, error: false
    catch
      Themes.update _id, $set: error: true
    done()

Themes.find().observeChanges
  added: (_id, doc) ->
    # on startup, compile any themes that don't have compiled CSS
    unless doc.compiledCss
      updateTheme(_id)

  changed: (_id, doc) ->
    # whenever a theme changes, re-render it
    if doc.defaults? or doc.overrides? or doc.bootswatch? or doc.customLess?
      updateTheme(_id)