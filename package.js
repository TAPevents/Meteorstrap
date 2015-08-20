Package.describe({
  summary: 'A Reactive Bootstrap Theme Editor and Compiler',
  name: 'tap:meteorstrap',
  version:'0.1.0',
  git:'https://github.com/TAPevents/meteorstrap'
});

Npm.depends({'less':'2.5.1'})

Package.on_use(function (api) {

  api.versionsFrom('1.1.0.3');

  api.use([
    'coffeescript',
    'underscore',
    'meteorhacks:fast-render@2.8.1',
    'tap:i18n@1.5.1'
  ], ['client','server']);

  api.use([
    'cfs:micro-queue',
    'cfs:power-queue@0.9.11'
  ], 'server')

  api.use([
    'less', // just for internal styling!
    'templating',
    'tracker',
    'reactive-var',
    'hitchcott:ez-modal@0.1.3',
    'tap:bootstrap-magic@0.1.1'
  ], ['client']);

  // i18n
  api.add_files(['package-tap.i18n'], ["client", "server"]);

  // Bootstrap Server-side assets
  api.add_files([
    // boostrap mixins
    'lib/less/bootstrap/mixins/alerts.import.less',
    'lib/less/bootstrap/mixins/background-variant.import.less',
    'lib/less/bootstrap/mixins/border-radius.import.less',
    'lib/less/bootstrap/mixins/buttons.import.less',
    'lib/less/bootstrap/mixins/center-block.import.less',
    'lib/less/bootstrap/mixins/clearfix.import.less',
    'lib/less/bootstrap/mixins/forms.import.less',
    'lib/less/bootstrap/mixins/gradients.import.less',
    'lib/less/bootstrap/mixins/grid-framework.import.less',
    'lib/less/bootstrap/mixins/grid.import.less',
    'lib/less/bootstrap/mixins/hide-text.import.less',
    'lib/less/bootstrap/mixins/image.import.less',
    'lib/less/bootstrap/mixins/labels.import.less',
    'lib/less/bootstrap/mixins/list-group.import.less',
    'lib/less/bootstrap/mixins/nav-divider.import.less',
    'lib/less/bootstrap/mixins/nav-vertical-align.import.less',
    'lib/less/bootstrap/mixins/opacity.import.less',
    'lib/less/bootstrap/mixins/pagination.import.less',
    'lib/less/bootstrap/mixins/panels.import.less',
    'lib/less/bootstrap/mixins/progress-bar.import.less',
    'lib/less/bootstrap/mixins/reset-filter.import.less',
    'lib/less/bootstrap/mixins/reset-text.import.less',
    'lib/less/bootstrap/mixins/resize.import.less',
    'lib/less/bootstrap/mixins/responsive-visibility.import.less',
    'lib/less/bootstrap/mixins/size.import.less',
    'lib/less/bootstrap/mixins/tab-focus.import.less',
    'lib/less/bootstrap/mixins/table-row.import.less',
    'lib/less/bootstrap/mixins/text-emphasis.import.less',
    'lib/less/bootstrap/mixins/text-overflow.import.less',
    'lib/less/bootstrap/mixins/vendor-prefixes.import.less',
    // boostrap variables
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
    'lib/less/bootstrap/responsive-embed.import.less',
    'lib/less/bootstrap/responsive-utilities.import.less',
    'lib/less/bootstrap/scaffolding.import.less',
    'lib/less/bootstrap/tables.import.less',
    'lib/less/bootstrap/theme.import.less',
    'lib/less/bootstrap/thumbnails.import.less',
    'lib/less/bootstrap/tooltip.import.less',
    'lib/less/bootstrap/type.import.less',
    'lib/less/bootstrap/utilities.import.less',
    'lib/less/bootstrap/variables.import.less',
    'lib/less/bootstrap/wells.import.less'
  ],"server");

  // Bootstrap Client-side Assets
  api.add_files([
    'lib/fonts/glyphicons-halflings-regular.eot',
    'lib/fonts/glyphicons-halflings-regular.svg',
    'lib/fonts/glyphicons-halflings-regular.ttf',
    'lib/fonts/glyphicons-halflings-regular.woff',
    'lib/fonts/glyphicons-halflings-regular.woff2',
    'lib/bootstrap.js'
  ],"client");


  // Actual package logic
  api.add_files([
    'both/collections.coffee',
    'both/router.coffee'
  ],["server","client"]);

  api.add_files([
    'server/install-predefined-themes.coffee',
    'server/less-compiler.coffee'
  ],"server");

  api.add_files([
    'client/editor.html',
    'client/editor.less',
    'client/editor.coffee',
    'client/injector.coffee'
  ],"client");

  // i18n
  api.add_files([
    'i18n/en.i18n.json',
    'i18n/zh.i18n.json'
  ],["client", "server"]);

});

Package.on_test(function (api) {

  api.use([
    'tinytest',
    'coffeescript',
    'mongo',
    'tap:meteorstrap'
  ], ['client','server']);

  api.add_files([
    'tests/meteorstrap-tests.coffee'
  ], ['client', 'server'])

});



