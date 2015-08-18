adminTheme = 'simplex'

Router.plugin 'Meteorstrap', preload: [adminTheme]

Router.configure layoutTemplate: 'layout'
Router.route '/', -> @render 'welcome'
Router.route 'welcome'
Router.route 'about'
Router.route 'editor'
Router.route 'admin', Meteorstrap: adminTheme

if Meteor.isClient
  Template.navbar.helpers
    activeRouteClass: (route) -> if route is Router.current().route.getName() then 'active'

# this example has no authentication, but you would want to do something like:
# if Meteor.isServer
#   Meteorstrap.publishEditorTo = -> Roles.userIsInRole @userId, 'admin'