
Router.plugin 'BootstrapThemer', preload: ['vanilla']

Router.configure layoutTemplate: 'layout'
Router.route '/', -> @render 'welcome'
Router.route 'welcome'
Router.route 'about'
Router.route 'editor'
Router.route 'admin', BootstrapThemer: 'vanilla'

if Meteor.isClient
  Template.navbar.helpers
    activeRouteClass: (route) -> if route is Router.current().route.getName() then 'active'