Package.describe({
  summary: 'A Reactive Bootstrap Theme Compiler',
  name: 'tap:bootstrap-themer',
  version:'0.1.0',
  git:'https://github.com/TAPevents/bootstrap-themer'
});

Npm.depends({'less':'1.7.3'})

Package.on_use(function (api) {

  api.versionsFrom('1.1.0.2');

  api.use([
    'coffeescript',
    'tap:i18n@1.5.0'
  ], ['client','server']);

  api.use([
    'templating',
    'tap:bootstrap-magic'
  ], ['client']);

  // i18n
  api.add_files(['package-tap.i18n'], ["client", "server"]);

  // Bootstrap Server-side assets
  api.add_files([
    // vanilla boostrap variables
    'lib/less/bootstrap/alerts.import.less',
    'lib/less/bootstrap/badges.import.less',
    'lib/less/bootstrap/bootstrap.import.less',
    'lib/less/bootstrap/breadcrumbs.import.less',
    'lib/less/bootstrap/button-groups.import.less',
    'lib/less/bootstrap/buttons.import.less',
    'lib/less/bootstrap/carousel.import.less',
    'lib/less/bootstrap/close.import.less',
    'lib/less/bootstrap/code.import.less',
    'lib/less/bootstrap/component-animations.import.less',
    'lib/less/bootstrap/dropdowns.import.less',
    'lib/less/bootstrap/forms.import.less',
    'lib/less/bootstrap/glyphicons.import.less',
    'lib/less/bootstrap/grid.import.less',
    'lib/less/bootstrap/input-groups.import.less',
    'lib/less/bootstrap/jumbotron.import.less',
    'lib/less/bootstrap/labels.import.less',
    'lib/less/bootstrap/list-group.import.less',
    'lib/less/bootstrap/media.import.less',
    'lib/less/bootstrap/mixins.import.less',
    'lib/less/bootstrap/modals.import.less',
    'lib/less/bootstrap/navbar.import.less',
    'lib/less/bootstrap/navs.import.less',
    'lib/less/bootstrap/normalize.import.less',
    'lib/less/bootstrap/pager.import.less',
    'lib/less/bootstrap/pagination.import.less',
    'lib/less/bootstrap/panels.import.less',
    'lib/less/bootstrap/popovers.import.less',
    'lib/less/bootstrap/print.import.less',
    'lib/less/bootstrap/progress-bars.import.less',
    'lib/less/bootstrap/responsive-utilities.import.less',
    'lib/less/bootstrap/scaffolding.import.less',
    'lib/less/bootstrap/tables.import.less',
    'lib/less/bootstrap/theme.import.less',
    'lib/less/bootstrap/thumbnails.import.less',
    'lib/less/bootstrap/tooltip.import.less',
    'lib/less/bootstrap/type.import.less',
    'lib/less/bootstrap/utilities.import.less',
    'lib/less/bootstrap/variables.import.less',
    'lib/less/bootstrap/wells.import.less',
    // bootswatch themes
    'lib/less/themes/amelia/bootswatch.less',
    'lib/less/themes/amelia/variables.less',
    'lib/less/themes/cerulean/bootswatch.less',
    'lib/less/themes/cerulean/variables.less',
    'lib/less/themes/cosmo/bootswatch.less',
    'lib/less/themes/cosmo/variables.less',
    'lib/less/themes/cyborg/bootswatch.less',
    'lib/less/themes/cyborg/variables.less',
    'lib/less/themes/darkly/bootswatch.less',
    'lib/less/themes/darkly/variables.less',
    'lib/less/themes/flatly/bootswatch.less',
    'lib/less/themes/flatly/variables.less',
    'lib/less/themes/lumen/bootswatch.less',
    'lib/less/themes/lumen/variables.less',
    'lib/less/themes/readable/bootswatch.less',
    'lib/less/themes/readable/variables.less',
    'lib/less/themes/simplex/bootswatch.less',
    'lib/less/themes/simplex/variables.less',
    'lib/less/themes/slate/bootswatch.less',
    'lib/less/themes/slate/variables.less',
    'lib/less/themes/spacelab/bootswatch.less',
    'lib/less/themes/spacelab/variables.less',
    'lib/less/themes/superhero/bootswatch.less',
    'lib/less/themes/superhero/variables.less',
    'lib/less/themes/united/bootswatch.less',
    'lib/less/themes/united/variables.less',
    'lib/less/themes/yeti/bootswatch.less',
    'lib/less/themes/yeti/variables.less'
  ],"server");

  // Bootstrap Client-side Assets
  api.add_files([
    'lib/fonts/glyphicons-halflings-regular.eot',
    'lib/fonts/glyphicons-halflings-regular.svg',
    'lib/fonts/glyphicons-halflings-regular.ttf',
    'lib/fonts/glyphicons-halflings-regular.woff',
    'lib/bootstrap.js'
  ],"client");


  // Actual package logic

  api.add_files([
    'server/main.coffee',
    'server/install-predefined-themes.coffee',
    'server/compile-less.coffee'
  ],"server");

  api.add_files([
    'client/bootstrap-themer.html',
    'client/bootstrap-themer-client.coffee',
  ],"client");




  // i18n
  api.add_files([
    'i18n/en.i18n.json'
  ],"client");

});
