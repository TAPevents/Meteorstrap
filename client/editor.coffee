Themes = BootstrapThemer.Themes
currentTheme = new ReactiveVar 'vanilla'
getCurrentTheme = -> Themes.findOne(currentTheme.get())

Template.BootstrapThemer.onCreated -> @subscribe 'BootstrapThemerEditor'

Template._BootstrapThemer.onCreated ->
  @autorun ->
    thisTheme = getCurrentTheme()
    BootstrapMagic.setDefaults thisTheme.defaults
    BootstrapMagic.setOverrides thisTheme.overrides || {}
    # TODO remove this:
    BootstrapThemer.enabledTheme.set thisTheme._id

Template._BootstrapThemer.onRendered -> @$('.dropdown-toggle').dropdown()

Template._BootstrapThemer.helpers
  currentTheme: getCurrentTheme
  availableThemes: -> Themes.find()
  canReset: ->
    theTheme = getCurrentTheme()
    if theTheme.customLess
      return true
    else if Object.keys(theTheme.overrides||{}).length isnt 0
      return true
    else
      return false

Template._BootstrapThemer.events
  'click .change-theme' : (e) ->
    currentTheme.set @_id

  'click .clone-theme' : ->
    EZModal
      dataContext:
        newTheme: true
        theme: getCurrentTheme
      template: 'BootstrapThemerCloneModal'

  'click .delete-theme' : ->
    themeToDelete = getCurrentTheme()
    EZModal
      title: 'Please Confirm'
      body: "Are you sure you want to delete #{themeToDelete.name}?"
      leftButtons: [
        color: 'default'
        html: 'Cancel'
      ]
      rightButtons: [
        color: 'danger'
        html: 'Delete Theme'
        fn: (e, tmpl) ->
          Themes.remove themeToDelete._id
          currentTheme.set 'vanilla'
          @EZModal.modal 'hide'
      ]

  'click .reset-theme' : ->
    themeToReset = getCurrentTheme()
    EZModal
      title: 'Please Confirm'
      body: "Are you sure you want to reset #{themeToReset.name}?"
      leftButtons: [
        color: 'default'
        html: 'Cancel'
      ]
      rightButtons: [
        color: 'primary'
        html: 'Reset Theme'
        fn: (e, tmpl) ->
          # reset by removing custom less and overrides
          Themes.update themeToReset._id, $set: customLess:'', overrides:{}
          @EZModal.modal 'hide'
      ]

  'change .css-box' : (e) ->
    update = {}
    update[$(e.currentTarget).attr('name')] = e.currentTarget.value
    Themes.update currentTheme.get(), $set: update

Template.BootstrapThemerCloneModal.events
  'submit form' : (e, tmpl) ->
    e.preventDefault()
    oldTheme = getCurrentTheme()
    newTheme = {}
    # popoulate name and author
    $('input', e.currentTarget).each ->
      $this = $(this)
      newTheme[$this.attr('name')] = $this.val()
    # custom less gets appended to bootswatch
    newTheme.bootswatch = "#{oldTheme.bootswatch or ''}\n\n#{oldTheme.customLess or ''}"
    # overrides become the new  defaults
    newTheme.defaults = oldTheme.defaults
    for key, val of oldTheme.overrides
      newTheme.defaults[key] = val
    # set the theme to the new theme
    currentTheme.set Themes.insert newTheme
    @EZModal.modal('hide')


BootstrapMagic.on 'change', (change) ->
  key = Object.keys(change)[0]
  if change[key]?
    update = {$set:{}}
    update['$set']["overrides.#{key}"] = change[key]
  else
    update = {$unset:{}}
    update['$unset']["overrides.#{key}"] = 1

  Themes.update currentTheme.get(), update