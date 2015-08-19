if Meteor.isServer
  crypto = Npm.require 'crypto'

  # TODO make less brittle; checksum needs to be updated whenever bootstrap variables update
  Tinytest.add "_renderTheme", (test) ->
    # get the vanilla raw deets, build a checksum yourself
    compiledCss = Meteorstrap._renderTheme 'vanilla' # todo pass in actual files
    checksum = crypto.createHash('md5').update(compiledCss).digest("hex")
    test.equal checksum, '6bc4d59ceda3a54ff031022016d1af9b'

  # to test the publish security later on, let's create create a custom authentication function:
  Meteorstrap.publishEditorTo = ->
    if @_params.TESTING_UNAUTHORIZED_SUBSCRIPTION?
      return false
    else
      return true

# pub/sub security
if Meteor.isClient
  Tinytest.add "Pubsub - Automatically subcribes to get the default theme", (test) ->
    # by default we should automatically subscribe to one theme
    test.equal Meteorstrap.Themes.find().count(), 1
    defaultTheme = Meteorstrap.Themes.findOne()
    # but not to the editor subscription
    test.isUndefined defaultTheme.name
    # and only to defaults
    test.isTrue defaultTheme.default

  Tinytest.addAsync "Pubsub - Can subscribe to MeteorstrapEditor by default", (test, done) ->
    # check there are no themes with names defined already
    test.isUndefined Meteorstrap.Themes.findOne({name:{$ne:undefined}})
    # once subscribed, we should find the name
    Meteor.subscribe 'MeteorstrapEditor', ->
      # all themes should now have `name` attrs
      anyTheme = Meteorstrap.Themes.findOne()
      # so, if the name exists, we're subbed to the editor
      test.isNotUndefined anyTheme.name
      @stop()
      Meteor.defer done

  Tinytest.addAsync "Pubsub - Can only subscribe to MeteorstrapEditor with authorization", (test, done) ->
    # make sure there's nothing left over
    test.isUndefined Meteorstrap.Themes.findOne({name:{$ne:undefined}})
    Meteor.subscribe 'MeteorstrapEditor', {TESTING_UNAUTHORIZED_SUBSCRIPTION:true}, ->
      anyTheme = Meteorstrap.Themes.findOne()
      @stop()
      Meteor.defer done

  # CSS Injecsion
  testColor = "rgb(255, 0, 0)"
  testTheme = 'red'
  Tinytest.addAsync "CSS Injection", (test, done) ->
    # stub just for this test
    Meteorstrap.Themes.findOne = (_id) ->
      defaults: {}
      overrides: {}
      bootswatch: ""
      customLess: ""
      compiledCss: "body { background: #{if _id is testTheme then testColor else 'inherit'} !important };"

    $body = $('body')
    # first lets set to a test theme
    Meteorstrap.enabledTheme.set testTheme
    # wait for it to render...
    Meteor.defer ->
      # background is red now
      test.isTrue $body.css('background').indexOf(testColor) > -1
      # set it back
      Meteorstrap.enabledTheme.set('vanilla')
      # wait to render again
      Meteor.defer ->
        # now we're back to white (default)
        test.isTrue $body.css('background').indexOf(testColor) is -1
        done()
