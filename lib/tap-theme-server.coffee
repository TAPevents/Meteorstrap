fs = Npm.require 'fs'
less = Npm.require 'less'

assetPath = './assets/packages/tap-theme/lib/less/'
bootstrapPath = assetPath+'bootstrap/'
themesPath = assetPath+'themes/'
variablesFile = 'variables.import.less'
rootFile = 'bootstrap.import.less'

parser = new less.Parser
  paths: [bootstrapPath]
  filename: rootFile

# read once, keep in memory for future use
originalVariables = fs.readFileSync "#{bootstrapPath}#{variablesFile}", 'utf8'
bootstrapLESS = fs.readFileSync "#{bootstrapPath}#{rootFile}", 'utf8'

ThemeCollection = new Meteor.Collection 'TAPtheme'

Meteor.publish null, -> ThemeCollection.find()

renderLess = (targetLess, addTheme) ->

  customVariables = """
  //CUSTOM VARS

  """

  for key, val of ThemeCollection.findOne('main')?.rule_overrides || {}
    if val and val isnt ''
      customVariables+= "#{key}: #{val};"

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
  if customLESS
    update.customLESS = customLESS
    update.customCSS = renderLess customLESS

  # update collection with rendered css
  ThemeCollection.update 'main', {$set: update}

# bootstrap coillection on first load
if ThemeCollection.find().count() is 0
  # move me to be handled by TAPi18n
  descriptions =
    "@gray-dark" : "Main Body Text"
    "@body-bg" : "Background Colour"
    "@brand-primary" : "Button Colours"
  # do a test with only original vars
  defaultVaraibles = Meteor._wrapAsync (done) ->
    parser.parse originalVariables, (err,cssTree) ->
      lessVars = []
      for rule in cssTree.rules
        unless rule.silent
          try
            lessVar =
              name: rule.name
              val: rule.value.toCSS()

            lessVar.desc = descriptions[lessVar.name] # USE TAPi18n

            lessVars.push lessVar

      done null, lessVars

  ThemeCollection.insert
    _id: 'main'
    variables: defaultVaraibles()

  updateTheme()

getThemes = ->
  themes = ['null']
  for themeFolder in fs.readdirSync themesPath
    # only add folders
    if fs.lstatSync(themesPath+themeFolder).isDirectory()
      themes.push themeFolder

  ThemeCollection.update 'main',
    $set:
      availableThemes: themes

# get themes on startup
getThemes()


Meteor.methods
  'TAPtheme_updateLessVariable' : (key, val) ->
    update = {}
    update["rule_overrides.#{key}"] = val || null
    ThemeCollection.update {_id:'main'}, {$set: update}
    updateTheme()

  'TAPtheme_updateTheme' : updateTheme

  'TAPtheme_switchTheme' : (theme) ->
    ThemeCollection.update 'main', {$set: {theme: theme}}
    updateTheme()
