import org.openqa.selenium.Capabilities;
import org.openqa.selenium.Platform;
import org.openqa.selenium.Proxy;
import org.openqa.selenium.SeleneseCommandExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebDriverBackedSelenium;
import org.openqa.selenium.chrome.ChromeDriver;
import com.opera.core.systems.OperaDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.android.AndroidDriver;
import org.openqa.selenium.remote.CapabilityType;
import org.openqa.selenium.remote.Command;
import org.openqa.selenium.remote.DesiredCapabilities;

import com.thoughtworks.selenium.Selenium;

class SeleniumWrapper {
  WebDriver driver;
  Selenium selenium;
  DesiredCapabilities desiredCapabilities = new DesiredCapabilities();
  String baseUrl;

  public SeleniumWrapper(String baseUrl) {
    this.baseUrl = baseUrl;
  }

  public SeleniumWrapper setProxy(String uri) {
    Proxy proxy = new Proxy();
    proxy.setSslProxy(uri);
    proxy.setHttpProxy(uri);
    proxy.setFtpProxy(uri);
    desiredCapabilities.setCapability(CapabilityType.PROXY, proxy);
    return this;
  }

	public void setChromeDriverPath(String path){
		System.setProperty("webdriver.chrome.driver",path);
	}

  public Selenium openBrowser(String browser) {
		if(browser.equalsIgnoreCase("firefox")){
    	driver = new FirefoxDriver(desiredCapabilities);
		} else if(browser.equalsIgnoreCase("android")){
    	driver = new AndroidDriver();
			driver.get(this.baseUrl);
		} else if(browser.equalsIgnoreCase("chrome")){
    	driver = new ChromeDriver(desiredCapabilities);
		} else if(browser.equalsIgnoreCase("opera")){
    	driver = new OperaDriver();
			driver.navigate().to(this.baseUrl);
		}
    selenium = new WebDriverBackedSelenium(driver, this.baseUrl);
    return selenium;
  }
}
