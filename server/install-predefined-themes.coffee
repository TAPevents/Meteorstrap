fs = Npm.require 'fs'
crypto = Npm.require 'crypto'

# coffeescript import
Themes = BootstrapThemer.Themes
themesPath = share.themesPath

Meteor.startup ->
  # check for new/updated themes on startup
  newThemes = 0

  # insert the vanilla bootstrap theme if there are none
  if Themes.find().count() is 0
    newThemes++
    Themes.insert
      # this is an 'empty' theme, so it'll just look like regular bootstrap
      defaults: {}
      bootswatch: ''
      _id: 'vanilla'
      name: 'Vanilla Bootstrap'
      checksum: crypto.createHash('md5').update('').digest("hex") # empty checksum
      predefined: true # predefined means we've added it rather than the user

  # loop through predefined themes
  for themeName in fs.readdirSync themesPath
    # only check folders folders
    if fs.lstatSync("#{themesPath}/#{themeName}").isDirectory()
      thisTheme = {}
      # get the theme less data
      for file in fs.readdirSync "#{themesPath}/#{themeName}"
        thisTheme[file] = fs.readFileSync("#{themesPath}/#{themeName}/#{file}").toString()
      # use a checksum to efficiently update only when theme has changed
      checksum = crypto.createHash('md5').update(thisTheme['bootswatch.less'] + thisTheme['variables.less']).digest("hex")
      unless Themes.findOne({_id: themeName, checksum: checksum})
        newThemes++
        # new/updated theme found, let's update it
        parsedLessDefaults = {}
        for line in thisTheme['variables.less'].split('\n') when line.indexOf("@") is 0
          keyVar = line.trim().split(';')[0].split(':')
          parsedLessDefaults["#{keyVar[0].trim()}"] = keyVar[1].trim()
        # upsert (so we insert if new, update if a checksum is changed)
        Themes.upsert _id: themeName,
          name: themeName.charAt(0).toUpperCase() + themeName.slice(1)
          defaults: parsedLessDefaults
          bootswatch: thisTheme['bootswatch.less']
          checksum: checksum
          predefined: true

  if newThemes
    # user feedback
    console.log "tap:themer just installed/updated #{newThemes} themes! 😎"
