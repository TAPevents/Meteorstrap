Router.plugin 'Meteorstrap', preload: ['yeti']

Router.configure layoutTemplate: 'layout'
Router.route '/', -> @render 'welcome'
Router.route 'welcome'
Router.route 'about'
Router.route 'editor'
Router.route 'admin', Meteorstrap: 'yeti'

if Meteor.isClient
  Template.navbar.helpers
    activeRouteClass: (route) -> if route is Router.current().route.getName() then 'active'