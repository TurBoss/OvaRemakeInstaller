function Component()
{
}

Component.prototype.createOperations = function()
{
    copyInstallationFiles(installer.value("diskPath"), installer.value("TargetDir"));
}

var copyInstallationFiles = function(diskPath, gamePath)
{
    diskName = "FF7INSTALL"
	diskPath = diskPath + "\\data";
	gamePath = gamePath + "\\data";
	component.addOperation("Mkdir", gamePath);
	component.addOperation("CopyDirectory", diskPath, gamePath, "forceOverwrite");
}
