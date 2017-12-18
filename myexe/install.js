// This code is heavily inspired by Chris Pederick (useragentswitcher) install.js
var contentFlag         = CONTENT | PROFILE_CHROME;
var localeFlag          = LOCALE | PROFILE_CHROME;
var skinFlag            = SKIN | PROFILE_CHROME;

var displayName         = "Modify Headers";
var version             = "0.7.1.1";

var name                = "modifyheaders";
var jarName             = name + ".jar";
//var jarFolder           = "content/" + name + "/"
var jarFolder           = "content/"

var error               = null;

var folder              = getFolder("Profile", "chrome");
var prefFolder          = getFolder(getFolder("Program", "defaults"), "pref");
var compFolder          = getFolder("components");

var existsInApplication = File.exists(getFolder(getFolder("chrome"), jarName));
var existsInProfile     = File.exists(getFolder(folder, jarName));

var locales             = new Array( "en-US" );
var skins               = new Array(  ); // "modern"
// var prefs               = new Array( "modifyheaders.js" );
var prefs               = new Array(  );
var components          = new Array( "modifyheaders-service.js", "nsIModifyheaders.xpt", "mhIHeader.xpt" );

// If the extension exists in the application folder or it doesn't exist
// in the profile folder and the user doesn't want it installed to the
// profile folder
if(existsInApplication ||
    (!existsInProfile &&
      !confirm( "Do you want to install the " + displayName +
                " extension into your profile folder?\n" +
                "(Cancel will install into the application folder)")))
{
    contentFlag = CONTENT | DELAYED_CHROME;
    folder      = getFolder("chrome");
    localeFlag  = LOCALE | DELAYED_CHROME;
    skinFlag    = SKIN | DELAYED_CHROME;
}

initInstall(displayName, name, version);
setPackageFolder(folder);
error = addFile(name, version, "chrome/" + jarName, folder, null);

// If adding the JAR file succeeded
if(error == SUCCESS)
{
    folder = getFolder(folder, jarName);
    registerChrome(contentFlag, folder, jarFolder);

    // Register locales
    for (var i = 0; i < locales.length; i++) {
        // registerChrome(localeFlag, folder, "locale/" + locales[i] + "/" + name + "/");
        registerChrome(localeFlag, folder, "locale/" + locales[i] + "/");
    }

    // Register skin
    for (var i = 0; i < skins.length; i++) {
        // registerChrome(skinFlag, folder, "skin/" + skins[i] + "/" + name + "/");
        registerChrome(skinFlag, folder, "skin/" + skins[i] + "/");
    }

    // Register components
    for (var i = 0; i < components.length; i++) {
        // Add a file to the components folder
        addFile(name + " Defaults", version, "components/" + components[i], compFolder, components[i]);
    }
    
    
    for (var i = 0; i < prefs.length; i++) {
        addFile(name + " Defaults", version, "defaults/preferences/" + prefs[i], prefFolder, prefs[i], true);
    }

    error = performInstall();

    // If the install failed
    if(error != SUCCESS && error != REBOOT_NEEDED)
    {
        displayError(error);
    	cancelInstall(error);
    }
    else
    {
        alert("The installation of the " + displayName + " extension succeeded.");
    }
}
else
{
    displayError(error);
	cancelInstall(error);
}

// Displays the error message to the user
function displayError(error)
{
    // If the error code was -215
    if(error == READ_ONLY)
    {
        alert("The installation of " + displayName +
            " failed.\nOne of the files being overwritten is read-only.");
    }
    // If the error code was -235
    else if(error == INSUFFICIENT_DISK_SPACE)
    {
        alert("The installation of " + displayName +
            " failed.\nThere is insufficient disk space.");
    }
    // If the error code was -239
    else if(error == CHROME_REGISTRY_ERROR)
    {
        alert("The installation of " + displayName +
            " failed.\nChrome registration failed.");
    }
    else
    {
        alert("The installation of " + displayName +
            " failed.\nThe error code is: " + error);
    }
}