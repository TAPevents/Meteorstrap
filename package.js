Package.describe({
  summary: 'A Reactive Bootstrap Theme Editor for Meteor'
});

Npm.depends({'less':'1.7.3'})

var getPackageAssets = function(packageName,folder){
    // local imports
    var _=Npm.require("underscore");
    var fs=Npm.require("fs");
    var path=Npm.require("path");
    // helper function, walks recursively inside nested folders and return absolute filenames
    function walk(folder){
        var filenames=[];
        // get relative filenames from folder
        var folderContent=fs.readdirSync(folder);
        // iterate over the folder content to handle nested folders
        _.each(folderContent,function(filename){
            // build absolute filename
            var absoluteFilename=folder+path.sep+filename;
            // get file stats
            var stat=fs.statSync(absoluteFilename);
            if(stat.isDirectory()){
                // directory case => add filenames fetched from recursive call
                filenames=filenames.concat(walk(absoluteFilename));
            }
            else{
                // file case => simply add it
                filenames.push(absoluteFilename);
            }
        });
        return filenames;
    }
    // save current working directory (something like "/home/user/projects/my-project")
    var cwd=process.cwd();
    // chdir to our package directory
    process.chdir("packages"+path.sep+packageName);
    // launch initial walk
    var result=walk(folder);
    // restore previous cwd
    process.chdir(cwd);
    return result;
}


Package.on_use(function (api) {
  api.use([
    'coffeescript'
  ], ['client','server']);

  api.use([
    'templating'
  ], ['client']);

  api.use([

  ], ['server']);

  // Bootstrap + Theme Assets
  api.add_files(getPackageAssets("tap-theme","lib/less"),"server");
  api.add_files(['lib/tap-theme-server.coffee'],"server");

  api.add_files([
    'lib/bootstrap.js',
    'lib/tap-theme-client-templates.html',
    'lib/tap-theme-client.coffee'
  ],"client");
});
