fs = Npm.require 'fs'
less = Npm.require 'less'

assetPath = './assets/packages/tap-theme/lib/less/'
bootstrapPath = assetPath+'bootstrap/'
themesPath = assetPath+'themes/'
variablesFile = 'variables.import.less'
rootFile = 'bootstrap.import.less'
# read once, keep in memory for future use
originalVariables = fs.readFileSync "#{bootstrapPath}#{variablesFile}", 'utf8'
bootstrapLESS = fs.readFileSync "#{bootstrapPath}#{rootFile}", 'utf8'

parser = new less.Parser
  paths: [bootstrapPath]
  filename: rootFile

ThemeCollection = new Meteor.Collection 'TAPtheme'

# HELPERS

renderLess = (targetLess, addTheme) ->

  customVariables = """
  //CUSTOM VARS

  """

  for key, val of ThemeCollection.findOne('main')?.rule_overrides || {}
    if val and val isnt ''
      customVariables+= "#{key}: #{val};\n"

  if addTheme
    themeName = ThemeCollection.findOne('main').theme
    themeLess = """
    // THEME: #{themeName}
    """
    if themeName and themeName isnt 'null'
        # theme less
        themeLess+= fs.readFileSync "#{themesPath}#{themeName}/variables.less", 'utf8'
        themeLess+= fs.readFileSync "#{themesPath}#{themeName}/bootswatch.less", 'utf8'

  lessBundle = ""
  # add default variables
  lessBundle+= originalVariables

  # theme if present
  if addTheme
    lessBundle+= themeLess

  # add font path specific to TAPtheme for glyphicons
  lessBundle+= "@icon-font-path: \"/packages/tap-theme/lib/fonts/\";\n"

  # add rule overrides
  lessBundle+= customVariables

  # add boostrap.less or customCss
  lessBundle+= targetLess

  try
    parsed = Meteor._wrapAsync (done) ->
      parser.parse lessBundle, done

  return parsed().toCSS({compress:true})

updateTheme = (customLESS) ->
  # render main bootstrap
  update =
    bootstrapCSS : renderLess bootstrapLESS, true

  # render custom css if present
  if customLESS?
    update.customLESS = customLESS
    update.customCSS = renderLess customLESS

  # update collection with rendered css
  ThemeCollection.update 'main', {$set: update}

getThemes = ->
  themes = ['null']
  for themeFolder in fs.readdirSync themesPath
    # only add folders
    if fs.lstatSync(themesPath+themeFolder).isDirectory()
      themes.push themeFolder

  ThemeCollection.update 'main',
    $set:
      availableThemes: themes


getLessVars = (lessStr) ->
  lines = lessStr.split('\n')
  lessVars = {}
  for line in lines
    if line.indexOf('@') is 0
      keyVar = line.split(';')[0].split(':')
      lessVars[keyVar[0]] = keyVar[1].trim()
  return lessVars





# populate variables on first load
if ThemeCollection.find().count() is 0

  ThemeCollection.insert
    _id: 'main'
    defaultVars: getLessVars originalVariables

  # generate vanilla boostrap on first load
  updateTheme()


# always get themes on startup
getThemes()


# always publish the ThemeCollection's relevent fields
# TODO make this only publish CSS fields

Meteor.publish null, -> ThemeCollection.find()




# TODO Convert these to observe

Meteor.methods
  'TAPtheme_updateLessVariable' : (key, val) ->
    if val
      update = {$set: {}}
      update.$set["rule_overrides.#{key}"] = val
    else
      update = {$unset: {}}
      update.$unset["rule_overrides.#{key}"] = ""

    ThemeCollection.update {_id:'main'}, update
    updateTheme()

  'TAPtheme_updateCustomCSS' : updateTheme

  'TAPtheme_switchTheme' : (theme) ->
    ThemeCollection.update 'main', {$set: {theme: theme}}
    updateTheme()
