@BootstrapThemer = @BootstrapThemer || {}

fs = Npm.require 'fs'
crypto = Npm.require 'crypto'

# coffeescript import
Themes = BootstrapThemer.Themes

predefinedThemes = []

BootstrapThemer.registerPredefinedTheme = (theme) ->
  predefinedThemes.push theme

# make vanilla the only default theme
BootstrapThemer.registerPredefinedTheme
  defaults: {}
  bootswatch: ''
  _id: 'vanilla'
  name: 'Vanilla Bootstrap'
  author: 'Twitter'
  checksum: crypto.createHash('md5').update('').digest("hex") # empty checksum

Meteor.startup ->
  # check for new/updated themes on startup
  newThemes = 0
  # loop through registered predefined themes
  for predefinedTheme in predefinedThemes
    # resolve variables if assetPath is passed
    if predefinedTheme.assetPath
      # check the assets path
      if fs.lstatSync("#{predefinedTheme.assetPath}").isDirectory()
        thisTheme = {}
        # get the theme less data
        for file in fs.readdirSync "#{predefinedTheme.assetPath}"
          thisTheme[file] = fs.readFileSync("#{predefinedTheme.assetPath}/#{file}").toString()
        # use a checksum to efficiently update only when theme has changed
        checksum = crypto.createHash('md5').update(thisTheme['bootswatch.less'] + thisTheme['variables.less']).digest("hex")
        unless Themes.findOne({_id: predefinedTheme._id, checksum: checksum})
          # new/updated theme found, let's update it
          parsedLessDefaults = {}
          for line in thisTheme['variables.less'].split('\n') when line.indexOf("@") is 0
            keyVar = line.trim().split(';')[0].split(':')
            parsedLessDefaults["#{keyVar[0].trim()}"] = keyVar[1].trim()

          # upsert (so we insert if new, update if a checksum is changed)
          newThemes++
          Themes.upsert _id: predefinedTheme._id,
            name: predefinedTheme.name
            author: predefinedTheme.author
            defaults: parsedLessDefaults
            bootswatch: thisTheme['bootswatch.less']
            checksum: checksum
            predefined: true

    # passing a theme without assetPath, assume it's already formatted
    # don't update if the checksum is the same
    else if !(predefinedTheme.checksum and Themes.findOne({_id: predefinedTheme._id, checksum: predefinedTheme.checksum}))
      # assume variables and theme are correct already
      newThemes++
      Themes.upsert _id: predefinedTheme._id,
        name: predefinedTheme.name
        author: predefinedTheme.author
        defaults: predefinedTheme.defaults
        bootswatch: predefinedTheme.bootswatch
        checksum: predefinedTheme.checksum
        predefined: true



  if newThemes
    # user feedback
    console.log "tap:themer just installed/updated #{newThemes} themes! 😎"
