var Dir = new function ()
{
    this.toNativeSparator = function (path) {
        if (systemInfo.productType === "windows") {
			path = path.replace(/\//g, '\\');
            return path
        }
        else {
            return path;
        }
    }
}

function Component()
{
    component.loaded.connect(this, Component.prototype.installerLoaded);
}

Component.prototype.installerLoaded = function()
{
	installDisk = "D:\\";
    installPath = "C:\\Games\\Final7";
	installationCanceled = false;



//	var ff7 = 0;

//	if (systemInfo.productType === "windows"){
//        ff7 = installer.execute("reg", new Array("HKEY_LOCAL_MACHINE\\SOFTWARE\WOW6432Node\\JauriaStudios INC\\FF VII OVA Remake\\AppPath"));
//        if ( !ff7 ){
//			QMessageBox["warning"]( "Error", "FF7", "Final Fantasy 7 OVA Remake is installed please uninstall it first");

//            installer.setValue("FinishedText", "<font color='red' size=3>Please run the maintenance tool from your game install path.</font>");

//			installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
//			installer.setDefaultPageVisible(QInstaller.ReadyForInstallation, false);
//			installer.setDefaultPageVisible(QInstaller.ComponentSelection, false);
//			installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
//			installer.setDefaultPageVisible(QInstaller.PerformInstallation, false);
//			installer.setDefaultPageVisible(QInstaller.LicenseCheck, false);

//			gui.clickButton(buttons.NextButton);

//			installationCanceled = true;
//		}
//	}
	
	if (!installationCanceled){
		if (installer.addWizardPage(component, "TargetWidget", QInstaller.TargetDirectory)) {
			var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
            if (widget !== null) {

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
    if (widget !== null) {
        if (diskPath !== "") {
            widget.installDirectory.text = Dir.toNativeSparator(diskPath);
			installer.setValue("diskPath", diskPath);
        }
    }
}

Component.prototype.installChanged = function (path)
{
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget !== null) {
        if (path !== "") {
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
    if (widget !== null) {
        
        var newTarget = QFileDialog.getExistingDirectory("Choose your target directory.", Component.prototype.installPath);
        
        if (newTarget !== "") {
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
        if (path !== "") {
            installer.setValue("TargetDir", path);
        }
        else {
			widget.complete = false;
		}
    }
}

Component.prototype.createOperations = function()
{

    installer.gainAdminRights();
	
    component.createOperations();
	
    createBaseDirectory();
}

var createBaseDirectory = function()
{
	component.addOperation("Mkdir", "@TargetDir@");
}
