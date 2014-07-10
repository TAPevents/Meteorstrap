Package.describe({
  summary: 'A Reactive Bootstrap Theme Editor for Meteor'
});

Npm.depends({'less':'1.7.3'})

// Get package assets recursively
var getPackageAssets=function(a,b){function f(a){var b=[],g=d.readdirSync(a);return c.each(g,function(c){var g=a+e.sep+c,h=d.statSync(g);h.isDirectory()?b=b.concat(f(g)):b.push(g)}),b}var c=Npm.require("underscore"),d=Npm.require("fs"),e=Npm.require("path"),g=process.cwd();process.chdir("packages"+e.sep+a);var h=f(b);return process.chdir(g),h};

Package.on_use(function (api) {
  api.use([
    'coffeescript',
    'tap-i18n'
  ], ['client','server']);

  api.use([
    'templating'
  ], ['client']);

  api.use([

  ], ['server']);

  // i18n
  api.add_files(['package-tap.i18n'], ["client", "server"]);

  // Bootstrap + Theme Assets
  api.add_files(getPackageAssets("tap-theme","lib/less"),"server");
  api.add_files(['lib/tap-theme-server.coffee'],"server");


  api.add_files([
    'lib/bootstrap.js',
    'lib/tap-theme-client-templates.html',
    'lib/tap-theme-client.coffee',
    // i18n files
    'i18n/en.i18n.json'
  ],"client");




});
