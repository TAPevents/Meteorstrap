# asset paths
assetsRoot = "#{__meteor_bootstrap__.serverDir}/assets/packages/tap_bootstrap-themer/lib/less"
share.themesPath = "#{assetsRoot}/themes"
share.bootstrapPath = "#{assetsRoot}/bootstrap"
share.bootstrapBase = "bootstrap.import.less"
share.bootstrapVariables = "variables.import.less"

# collections
share.Themes = new Meteor.Collection 'BootstrapThemerThemes'

Meteor.publish null, -> share.Themes.find()