var Selenium = require("../lib/index.js");
var assert = require('assert');

var url = "http://seleniumhq.org"


var browsers = [ "opera","firefox","chrome" ];

var testBrowser = function(){
	var browser = browsers.shift();
	if(browser!==undefined){

		var s = new Selenium({
			url: url,
			proxy: "localhost:#{PROXY_PORT}",
			browser: browser 
		});

		s.openBrowser(function(err,res){
			setTimeout(function(){
				res.open("/",function(){
					res.getTitle(function(err,title){
						console.log("Got title ",title,"from browser",browser);
						assert.notEqual(title.indexOf("Selenium"),-1)
						res.close();		
						testBrowser();
					});
				});
			},1000);
		});
	}

}

testBrowser();
