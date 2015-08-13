Router.configure
  layoutTemplate: 'layout'

Router.route '/', ->
  @render 'welcome'
, name: 'welcome'

Router.route 'admin'
Router.route 'about'
Router.route 'editor'


if Meteor.isClient
  Template.navbar.helpers
    activeRouteClass: (route) -> if route is Router.current().route.getName() then 'active'