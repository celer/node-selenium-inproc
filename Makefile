SELENIUM_JAR = $(wildcard ext/*.jar)

.PHONY: default
default: coffee lib/SeleniumWrapper.class

.PHONY: install
install:
	@mkdir -p ext
	$(if $(SELENIUM_JAR),,cd ext; wget $(npm_package_selenium_url))
	@mkdir -p ext/chrome
	(cd ext/chrome && wget $(npm_package_chrome_driver_mac) -O darwin_x64.zip && unzip darwin_x64.zip -d darwin_x64)
	(cd ext/chrome && wget $(npm_package_chrome_driver_linux32) -O linux_x32.zip && unzip linux_x32.zip -d linux_x32)
	(cd ext/chrome && wget $(npm_package_chrome_driver_linux64) -O linux_x64.zip && unzip linux_x64.zip -d linux_x64)
	@mkdir -p ext/safari
	(cd ext/safari && wget $(npm_package_safari_driver) -O safari.zip && unzip safari.zip)
	#(cd ext/chrome && rm *.zip)	

.PHONY: coffee
coffee: 
	coffee -c -o lib src

lib/SeleniumWrapper.class: src/SeleniumWrapper.java
	javac -d lib/ -classpath $(SELENIUM_JAR) src/SeleniumWrapper.java

