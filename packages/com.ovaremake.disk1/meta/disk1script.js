function Component()
{
    component.loaded.connect(this, Component.prototype.installerLoaded);
}

Component.prototype.installerLoaded = function()
{
	installDisk = installer.value("diskPath");
	installPath = installer.value("TargetDir");
}

Component.prototype.createOperations = function()
{
    copyInstallationFiles(installDisk, installPath);
}

var copyInstallationFiles = function(diskPath, gamePath)
{
	diskPath = diskPath + "\\movies";
	gamePath = gamePath + "\\movies";
	component.addOperation("Mkdir", gamePath);
	component.addOperation("CopyDirectory", diskPath, gamePath);
	component.addOperation("Execute", "workingdirectory=@TargetDir@", "{0}", "cmd", "/C", "@TargetDir@\\disk2.bat");
}
