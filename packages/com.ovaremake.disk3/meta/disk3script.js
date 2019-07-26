function Component()
{
}

Component.prototype.createOperations = function()
{
    copyInstallationFiles(installer.value("diskPath"), installer.value("TargetDir"));
}

var copyInstallationFiles = function(diskPath, gamePath)
{
    diskName = "FF7DISC3"
	diskPath = diskPath + "\\ff7\\movies";
	gamePath = gamePath + "\\data\\movies";
	fileCheck = diskPath + "\\boogdown.avi";
	
	component.addOperation("Execute", "workingdirectory=@TargetDir@", "{0}", "cmd", "/C", "@TargetDir@\\Tools\\disk.exe", fileCheck, "3");
	component.addOperation("CopyDirectory", diskPath, gamePath, "forceOverwrite");
}
