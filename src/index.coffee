Java = require('java')
fs = require('fs')
os = require('os');
path = require('path');
Commands = require('./commands')

module.exports = class Selenium
  DEBUG: process.env.NODE_DEBUG && /selenium/.test(process.env.NODE_DEBUG)
  DEBUG_PREFIX: 'Selenium: '

  found = false
  extDir = fs.realpathSync(__dirname + '/../ext')
  fs.readdirSync(extDir).map (jarname) =>
    abspath = fs.realpathSync(extDir + '/' + jarname)
    console.log "Selenium: Jarfile = #{abspath}" if @::DEBUG
    Java.classpath.push(abspath)
    found = true

  throw new Error("Selenium RC JAR file NOT found in #{extDir}!  (did you run 'npm install'?)") unless found

  Java.classpath.push(__dirname)
  SeleniumWrapper = Java.import('SeleniumWrapper')

  constructor: (options = {}) ->
    @options = options
    @seleniumWrapper = new SeleniumWrapper(options.url || '')
    @seleniumWrapper.setProxySync(options.proxy) if options.proxy

  setChromeDriverPath: (path) ->
    @seleniumWrapper.setChromeDriverPath(path)

  openBrowser: (cb) ->
    console.log @options
    browser = (@options.browser||'firefox')
    console.log os.platform()
    if browser == 'chrome'
        console.log (path.join(path.dirname(module.filename),"../ext/chrome/",os.platform()+"_"+os.arch(),"chromedriver"))
        @setChromeDriverPath(path.join(path.dirname(module.filename),"../ext/chrome/",os.platform()+"_"+os.arch(),"chromedriver"))
    @seleniumWrapper.openBrowser browser, ( err, selenium) =>
      cb(err, @selenium = selenium)

  log: (msg) ->
    console.log "#{@DEBUG_PREFIX}#{msg}"

  for cmd in Commands
    do (cmd) =>
      @::[cmd] = (args..., cb) ->
        throw new Error("Browser has not been opened yet") unless @selenium
        @log "Calling #{cmd}" if @DEBUG
        @selenium[cmd].apply(@selenium, arguments)

