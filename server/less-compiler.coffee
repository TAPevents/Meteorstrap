fs = Npm.require 'fs'
less = Npm.require 'less'

Themes = BootstrapThemer.Themes
assetsRoot = "#{__meteor_bootstrap__.serverDir}/assets/packages/tap_bootstrap-themer/lib/less"
themesPath = "#{assetsRoot}/themes"
bootstrapPath = "#{assetsRoot}/bootstrap"
rootFile = "bootstrap.import.less"
variablesFile = "variables.import.less"

# initialize less parser
parser = new less.Parser
  paths: [bootstrapPath] # include all bootstrap files
  filename: rootFile

# read bootstrap variables once, keep in memory for future compilation. is this efficient?
originalVariables = fs.readFileSync "#{bootstrapPath}/#{variablesFile}", 'utf8'
bootstrapLESS = fs.readFileSync "#{bootstrapPath}/#{rootFile}", 'utf8'

renderTheme = (themeId) ->
  thisTheme = Themes.findOne themeId
  # build the less file
  lessBundle = ""
  # add default bootstrap less
  lessBundle+= bootstrapLESS
  # add default bootstrap variables
  lessBundle+= originalVariables
  # add theme defaults
  for key, val of thisTheme.defaults || {}
    if val and val isnt ''
      lessBundle+= "#{key}: #{val};\n"
  # add theme overrides
  for key, val of thisTheme.overrides || {}
    if val and val isnt ''
      lessBundle+= "#{key}: #{val};\n"
  # always add/override font path specific to BootstrapThemer for glyphicons
  lessBundle+= "@icon-font-path: \"/packages/tap_bootstrap-themer/lib/fonts/\";\n"
  # add bootswatch theme
  lessBundle+= thisTheme.bootswatch || ""
  # add custom less
  lessBundle+= thisTheme.customLess || ""
  # now try parsing it all
  try
    parsed = Meteor._wrapAsync (done) ->
      parser.parse lessBundle, done
  catch err
    new Meteor.error "Less parse error: #{err}"

  return parsed().toCSS({compress:true})


# Use cfs:powerer-queue to handle throttling etc.

queue = new PowerQueue()

updateTheme = (_id) ->
  queue.add (done) ->
    try
      Themes.update _id, $set: compiledCss: renderTheme _id
    done()

Themes.find().observeChanges
  added: (_id, doc) ->
    # on startup, compile any themes that don't have compiled CSS
    unless doc.compiledCss
      updateTheme(_id)

  changed: (_id, doc) ->
    # whenever a theme changes, re-render it
    if doc.overrides? or doc.bootswatch? or doc.customLess?
      updateTheme(_id)