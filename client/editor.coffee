editingTheme = new ReactiveVar()
getEditingTheme = -> Meteorstrap.Themes.findOne(editingTheme.get())

Template.Meteorstrap.onCreated -> @subscribe 'MeteorstrapEditor'

Template._Meteorstrap.onCreated ->
  editingTheme.set Meteorstrap.Themes.findOne({default:true})._id
  @autorun ->
    thisTheme = getEditingTheme()
    BootstrapMagic.setDefaults thisTheme.defaults
    BootstrapMagic.setOverrides thisTheme.overrides || {}

Template._Meteorstrap.onRendered -> @$('.dropdown-toggle').dropdown()

Template._Meteorstrap.helpers
  editingTheme: getEditingTheme
  availableThemes: -> Meteorstrap.Themes.find({},{sort:{name:1}})
  canReset: ->
    theTheme = getEditingTheme()
    if theTheme.customLess
      return true
    else if Object.keys(theTheme.overrides||{}).length isnt 0
      return true
    else
      return false

Template._Meteorstrap.events
  'click .change-theme' : (e) ->
    editingTheme.set @_id

  'click .clone-theme' : ->
    EZModal
      dataContext:
        newTheme: true
        theme: getEditingTheme
      template: 'MeteorstrapCloneModal'

  'click .make-default' : ->
    # make others not default
    for theme in Meteorstrap.Themes.find().fetch()
      if theme.default
        Meteorstrap.Themes.update theme._id, $unset: default: 1
    # make this default
    Meteorstrap.Themes.update getEditingTheme()._id, $set: default: true

  'click .delete-theme' : ->
    themeToDelete = getEditingTheme()
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
          Meteorstrap.Themes.remove themeToDelete._id
          editingTheme.set 'vanilla'
          @EZModal.modal 'hide'
      ]

  'click .reset-theme' : ->
    themeToReset = getEditingTheme()
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
          Meteorstrap.Themes.update themeToReset._id, $set: customLess:'', overrides:{}
          @EZModal.modal 'hide'
      ]

  'change .css-box' : (e) ->
    update = {}
    update[$(e.currentTarget).attr('name')] = e.currentTarget.value
    Meteorstrap.Themes.update editingTheme.get(), $set: update

Template.MeteorstrapCloneModal.events
  'submit form' : (e, tmpl) ->
    e.preventDefault()
    oldTheme = getEditingTheme()
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
    editingTheme.set Meteorstrap.Themes.insert newTheme
    @EZModal.modal('hide')


BootstrapMagic.on 'change', (change) ->
  key = Object.keys(change)[0]
  if change[key]?
    update = {$set:{}}
    update['$set']["overrides.#{key}"] = change[key]
  else
    update = {$unset:{}}
    update['$unset']["overrides.#{key}"] = 1

  Meteorstrap.Themes.update editingTheme.get(), update