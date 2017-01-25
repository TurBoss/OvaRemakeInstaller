function Component()
{
}

Component.prototype.createOperations = function()
{
    copyInstallationFiles(installer.value("diskPath"), installer.value("TargetDir"));
}

var copyInstallationFiles = function(diskPath, gamePath)
{
	diskPath = diskPath + "\\ff7\\movies";
	gamePath = gamePath + "\\movies";
	fileCheck = diskPath + "\\bike.avi";
	
	component.addOperation("Mkdir", gamePath);
	component.addOperation("Execute", "workingdirectory=@TargetDir@", "{0}", "cmd", "/C", "@TargetDir@\\Tools\\disk.exe", fileCheck, "1");
	component.addOperation("CopyDirectory", diskPath, gamePath, "forceOverwrite");
}
