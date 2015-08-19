testColor = "rgb(255, 0, 0)"
# stubs
Meteorstrap.Themes =
  findOne: (_id) ->
    theme =
      defaults: {}
      overrides: {}
      bootswatch: ""
      customLess: ""
      compiledCss: ""

    if _id is 'red'
      theme.compiledCss = "body { background: #{testColor} !important };"

    return theme

if Meteor.isServer

  # TODO make less brittle; checksum needs to be updated whenever bootstrap variables update
  crypto = Npm.require 'crypto'
  Tinytest.add "Render Theme LESS", (test) ->
    compiledCss = Meteorstrap._renderTheme 'vanilla'
    checksum = crypto.createHash('md5').update(compiledCss).digest("hex")
    test.equal checksum, '6bc4d59ceda3a54ff031022016d1af9b'

if Meteor.isClient

  Tinytest.addAsync "CSS Injection", (test, done) ->
    $body = $('body')
    test.isTrue $body.css('background').indexOf(testColor) is -1
    Meteorstrap.enabledTheme.set('red')
    Meteor.setTimeout ->
      test.isTrue $body.css('background').indexOf(testColor) > -1
      done()
    , 100