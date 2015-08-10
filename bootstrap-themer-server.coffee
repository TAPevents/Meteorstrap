fs = Npm.require 'fs'
less = Npm.require 'less'
crypto = Npm.require 'crypto'

assetPath = "#{__meteor_bootstrap__.serverDir}/assets/packages/tap_bootstrap-themer/lib/less/"
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

ThemeCollection = new Meteor.Collection 'BootstrapThemer'
Themes = new Meteor.Collection 'BootstrapThemerThemes'

Meteor.startup ->
  # check for new themes
  newThemes = 0

  # insert the vanilla bootstrap theme if there are none
  if Themes.find().count() is 0
    newThemes++
    Themes.insert
      _id: 'vanilla'
      name: 'Vanilla Bootstrap'
      defaults: {}
      less: ''
      checksum: crypto.createHash('md5').update('').digest("hex")
      predefined: true

  for themeName in fs.readdirSync themesPath
    # only add folders
    if fs.lstatSync(themesPath+themeName).isDirectory()
      thisTheme = {name: themeName}
      for file in fs.readdirSync themesPath+themeName
        thisTheme[file] = fs.readFileSync("#{themesPath}#{themeName}/#{file}").toString()

      checksum = crypto.createHash('md5').update(thisTheme['bootswatch.less'] + thisTheme['variables.less']).digest("hex")
      # use a checksum to efficiently update only when theme has changed
      unless Themes.findOne({_id: themeName, checksum: checksum})
        newThemes++
        # new/updated theme found, let's update it
        parsedLessDefaults = {}
        for line in thisTheme['variables.less'].split('\n') when line.indexOf("@") is 0
          keyVar = line.trim().split(';')[0].split(':')
          parsedLessDefaults["#{keyVar[0].trim()}"] = keyVar[1].trim()

        Themes.upsert _id: themeName,
          name: themeName
          defaults: parsedLessDefaults
          less: thisTheme['bootswatch.less']
          checksum: checksum
          predefined: true

  if newThemes
    console.log "tap:themer just installed/updated #{newThemes} themes! 😎"

renderLess = (targetLess, addTheme) ->

  customVariables = """
  //CUSTOM VARS

  """

  for key, val of ThemeCollection.findOne('main')?.rule_overrides || {}
    if val and val isnt ''
      customVariables+= "#{key}: #{val};\n"

  if addTheme
    themeName = ThemeCollection.findOne('main').theme
    themeLess = ""
    if themeName and themeName isnt 'null'
        # add theme less
        themeLess+= """
        // THEME: #{themeName}

        """
        themeLess+= fs.readFileSync "#{themesPath}#{themeName}/variables.less", 'utf8'
        themeLess+= fs.readFileSync "#{themesPath}#{themeName}/bootswatch.less", 'utf8'

  lessBundle = ""
  # add default variables
  lessBundle+= originalVariables

  # theme if present
  if addTheme
    lessBundle+= themeLess

  # add font path specific to BootstrapThemer for glyphicons
  lessBundle+= "@icon-font-path: \"/packages/tap_bootstrap-themer/lib/fonts/\";\n"

  # add rule overrides
  lessBundle+= customVariables

  # add boostrap.less or customCss
  lessBundle+= targetLess

  try
    parsed = Meteor._wrapAsync (done) ->
      parser.parse lessBundle, done
  catch err
    console.log 'Less parse error', err

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

# TODO remove getLessVars after managed_themes, do clientside

getLessVars = (lessStr) ->
  # get the computed CSS, so colorpicker works
  # use http://stackoverflow.com/a/22867621/2682159
  parseHack = ".foo {"

  lines = "#{lessStr}".split('\n')
  for line in lines
    if line.indexOf('@') is 0
      keyVar = line.split(';')[0].split(':')
      k = keyVar[0].substr(1)
      parseHack+= "#{k}: @#{k};"

  parseHack+= " };"

  parsedLess = Meteor._wrapAsync (done) ->
    parser.parse lessStr+parseHack, done

  parsedLessDefaults = {}

  cssLines = parsedLess().toCSS().split('\n').slice(1, -2)
  for line in cssLines
    keyVar = line.split(';')[0].split(':')
    parsedLessDefaults["@#{keyVar[0].trim()}"] = keyVar[1].trim()

  return parsedLessDefaults


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


# TODO Convert these to observers(?)

Meteor.methods
  'BootstrapThemer_updateLessVariable' : (key, val) ->
    if val
      update = {$set: {}}
      update.$set["rule_overrides.#{key}"] = val
    else
      update = {$unset: {}}
      update.$unset["rule_overrides.#{key}"] = ""

    ThemeCollection.update {_id:'main'}, update
    updateTheme()

  'BootstrapThemer_updateCustomCSS' : updateTheme

  'BootstrapThemer_switchTheme' : (theme) ->
    ThemeCollection.update 'main', {$set: {theme: theme}}
    updateTheme()
