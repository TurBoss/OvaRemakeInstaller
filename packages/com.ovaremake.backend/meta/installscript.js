var Dir = new function ()
{
    this.toNativeSparator = function (path) {
        if (systemInfo.productType == "windows")
			path = path.replace(/\//g, '\\');
            return path
        return path;
    }
}

function Component()
{
    component.loaded.connect(this, Component.prototype.installerLoaded);
}

Component.prototype.installerLoaded = function()
{
	installDisk = "D:\\";
	installPath = "C:\\games\\JauriaStudios INC\\FF7 OVA Remake";
	installationCanceled = false;
	
	/*
	var ff7 = 0;

	if (systemInfo.productType === "windows"){
		if (systemInfo.prettyProductName === "Windows xp"){
			ff7 = installer.execute("reg", new Array("HKEY_LOCAL_MACHINE\SOFTWARE\\JauriaStudios INC\\FF VII OVA Remake\\AppPath"));
		}
		else {
			ff7 = installer.execute("reg", new Array("HKEY_LOCAL_MACHINE\\SOFTWARE\WOW6432Node\\JauriaStudios INC\\FF VII OVA Remake\\AppPath"));
		}
		if ( !ff7 ){
			QMessageBox["warning"]( "Error", "FF7", "Final Fantasy 7 OVA Remake is installed please uninstall it first");

			installer.setValue("FinishedText", "<font color='red' size=3>Please uninstall FF7 OVA REMAKE from your computer and make a backup of your saves.</font>");

			installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
			installer.setDefaultPageVisible(QInstaller.ReadyForInstallation, false);
			installer.setDefaultPageVisible(QInstaller.ComponentSelection, false);
			installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
			installer.setDefaultPageVisible(QInstaller.PerformInstallation, false);
			installer.setDefaultPageVisible(QInstaller.LicenseCheck, false);

			gui.clickButton(buttons.NextButton);

			installationCanceled = true;
		}
	}
	*/
	
	if (!installationCanceled){
		if (installer.addWizardPage(component, "TargetWidget", QInstaller.TargetDirectory)) {
			var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
			if (widget != null) {

				widget.windowTitle = "Installation Directories";

				widget.complete = false;
				
				widget.targetDirectory.textChanged.connect(this, Component.prototype.targetChanged);
				widget.installDirectory.textChanged.connect(this, Component.prototype.installChanged);
				
				widget.targetChooser.clicked.connect(this, Component.prototype.chooseTarget);
				widget.installChooser.clicked.connect(this, Component.prototype.installTarget);
				
				widget.installDirectory.text = installDisk;
				widget.targetDirectory.text = installPath;
			}
		}
	}
}

Component.prototype.installTarget = function ()
{
		
	var diskPath = QFileDialog.getExistingDirectory("Choose your FF7 Install Disk.", "D:\\");
		
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget != null) {
        if (diskPath !== "") {
            widget.installDirectory.text = Dir.toNativeSparator(diskPath);
			installer.setValue("diskPath", diskPath);
        }
    }
}

Component.prototype.installChanged = function (path)
{
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget != null) {
        if (path != "") {
            if (installer.fileExists(path + "//FF7inst.exe")) {
				installer.setValue("diskPath", path);
				
				var msg = "<font color='green'>" + qsTr("installation disc found.") + "</font>";
                widget.labelOverwrite.text = msg;
                
				widget.complete = true;
            } else {
                var warning = "<font color='red'>" + qsTr("Can't find a installation disc.") + "</font>";
                widget.labelOverwrite.text = warning;
                
				widget.complete = false;
            }
			return;
        }
    }
}

Component.prototype.chooseTarget = function ()
{
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget != null) {
        
        var newTarget = QFileDialog.getExistingDirectory("Choose your target directory.", Component.prototype.installPath);
        
        if (newTarget != "") {
            widget.targetDirectory.text = Dir.toNativeSparator(newTarget);
			installer.setValue("TargetDir", newTarget);
        }
           return;
    }
}

Component.prototype.targetChanged = function (path)
{
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget !== null) {
        if (path != "") {
            installer.setValue("TargetDir", path);
        }
        else {
			widget.complete = false;
		}
    }
}

Component.prototype.createOperations = function()
{
	
    component.createOperations();
    
	installer.gainAdminRights();
	
    createBaseDirectory();
	createSetupRegistryKeys();
	createOpenGLRegistryKeys();
	createCompatibilityFlags();
	createAudioRegistryKeys();
}

var createSetupRegistryKeys = function()
{
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "AppPath", Dir.toNativeSparator(installer.value("TargetDir")) + "\\");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "DataPath", Dir.toNativeSparator(installer.value("TargetDir")) + "\\data\\");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "MoviePath", Dir.toNativeSparator(installer.value("TargetDir")) + "\\data\\movies\\");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "DataDrive", Dir.toNativeSparator(installer.value("diskPath")) + "\\");
	
	component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@\\Tools", "{0}", "cmd", "/C", "reg", "import", "@TargetDir@\\Tools\\ff7_install_OVA.reg");
}

var createOpenGLRegistryKeys = function()
{
	component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@\\Tools", "{0}", "cmd", "/C", "reg", "import", "@TargetDir@\\Tools\\ff7_opengl_OVA.reg");
}

var createAudioRegistryKeys = function()
{
	component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@\\Tools", "{0}", "cmd", "/C", "@TargetDir@\\Tools\\findSoundCard.bat");
}

var createCompatibilityFlags = function()
{
	component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@\\Tools\\fileFlags", "{0}", "@TargetDir@\\Tools\\fileFlags\\main.exe", "@TargetDir@\\ff7.exe", '"$ DWM8And16BitMitigation WINXPSP3"');
	component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@\\Tools\\fileFlags", "{0}", "@TargetDir@\\Tools\\fileFlags\\main.exe", "@TargetDir@\\Tools\\devcon.exe", '"RUNASADMIN"');

}

var createBaseDirectory = function()
{
	component.addOperation("Mkdir", "@TargetDir@");
}
