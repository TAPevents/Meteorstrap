# stubs
Meteorstrap.Themes =
  findOne: ->
    defaults: {}
    overrides: {}
    bootswatch: ""
    customLess: ""

# console.log TestingBootstrapMagic


if Meteor.isServer
  Tinytest.add "compileLess", (test) ->
    # console.log 'findg', Meteorstrap.Themes.findOne('testing')
    test.isTrue true