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
	gamePath = gamePath + "\\data\\movies";
	fileCheck = diskPath + "\\biglight.avi";
	
	component.addOperation("Execute", "workingdirectory=@TargetDir@", "{0}", "cmd", "/C", "@TargetDir@\\Tools\\disk.exe", fileCheck, "2");
	component.addOperation("CopyDirectory", diskPath, gamePath, "forceOverwrite");
}
