var page = require('webpage').create();
system = require('system');
var width = 2250;
var height = 3300;
page.viewportSize = { width: width, height: height };
page.settings.javascriptEnabled = false;

page.open(system.args[1], function() {
  page.clipRect = { top: 0, left: 0, width: width, height: height };
  page.render(system.args[2]);
  phantom.exit();
});
