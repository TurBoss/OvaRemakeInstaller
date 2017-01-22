var Dir = new function () {
    this.toNativeSparator = function (path) {
        if (systemInfo.productType === "windows")
            return path.replace(/\//g, '\\');
        return path;
    }
};

function Component() {
	

    component.loaded.connect(this, Component.prototype.installerLoaded);
}

Component.prototype.installerLoaded = function()
{

	installDisk = "D:\\";
	installPath = "C:\\Games\\FF7 OVA Remake";
	var installationCanceled = false;

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

Component.prototype.installTarget = function () {
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget != null) {
		
		var diskPath = QFileDialog.getExistingDirectory("Choose your FF7 Install Disk.", "C:");
		
        if (diskPath != "") {
            widget.installDirectory.text = Dir.toNativeSparator(diskPath);
			installDisk = Dir.toNativeSparator(diskPath);
        }
    }
}

Component.prototype.installChanged = function (path) {
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget != null) {
        if (path != "") {
            if (installer.fileExists(path + "/FF7inst.exe")) {
				installDisk = Dir.toNativeSparator(path);
				
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

Component.prototype.chooseTarget = function () {
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget != null) {
        
        var newTarget = QFileDialog.getExistingDirectory("Choose your target directory.", Component.prototype.installPath);
        
        if (newTarget != "") {
            widget.targetDirectory.text = Dir.toNativeSparator(newTarget);
            installPath = Dir.toNativeSparator(newTarget);
        }
           return;
    }
}

Component.prototype.targetChanged = function (path) {
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget != null) {
        if (path != "") {
            installer.setValue("TargetDir", path);
            installPath = Dir.toNativeSparator(path);
        }
        else {
			widget.complete = false;
		}
    }
}
/*
Component.prototype.createOperations = function() {
    component.createOperations();

    if (installer.isInstaller()) {
        if (systemInfo.productType === "windows") {
			
			installer.gainAdminRights();
			
			copyInstallationFiles(installDisk, installPath, 0));
			copyInstallationFiles(installDisk, installPath, 1));
			copyInstallationFiles(installDisk, installPath, 2));
			copyInstallationFiles(installDisk, installPath, 3));
			
			component.registerPathForUninstallation(installPath + "\\data", true);
			component.registerPathForUninstallation(installPath + "\\movies", true);
			
			createSetupRegistryKeys();
			
			//component.addElevatedOperation("Execute", "{0}", "workingdirectory=@TargetDir@", "@TargetDir@/runff7config.bat");
			
			createOpenGLRegistryKeys();
        }
    }
    else if (installer.isUninstaller()) {
		QMessageBox["warning"]( "warning", "CD", "Please inser game disk" );
		//component.addElevatedOperation("Execute", "cmd", "/C", "echo", "do nothing", "UNDOEXECUTE", "cmd", "/C", "reg", "delete", "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Software\test","/f")
	}
}

copyInstallationFiles = function(diskPath, gamePath, diskNo) {
	if (diskNo == 0) {
		diskPath = diskPath + "\\data";
		gamePath = gamePath + "\\data";
		component.addElevatedOperation("Mkdir", gamePath);
		component.addElevatedOperation("CopyDirectory", diskPath, gamePath);
	}
	else if (diskNo != 0){
		QMessageBox["warning"]( "warning", "CD", "Please inser game disk " + diskNo );
		diskPath = diskPath + "\\movies";
		gamePath = gamePath + "\\movies";
		component.addElevatedOperation("Mkdir", gamePath);
		component.addElevatedOperation("CopyDirectory", diskPath, gamePath);
	}
	
}
createSetupRegistryKeys = function() {
	
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "AppPath", Dir.toNativeSparator(installer.value("TargetDir")) + "\\");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "DataPath", Dir.toNativeSparator(installer.value("TargetDir")) + "\\data\\");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "DataDrive", component.installDisk + "\\");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "MoviePath", component.installDisk + "\\FF7\\MOVIES\\");
	
	component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@", "{0}", "cmd", "/C", "reg", "import", "@TargetDir@\\Tools\\ff7_install_OVA.reg");

	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "DiskNo", 0);
	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "FullInstall", 0);

	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Graphics/DD_GUID", 0);
	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Graphics/Driver", 0);
	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Graphics/DriverPath", "ff7_opengl.fgd");
	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Graphics/Mode", 0);
	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Graphics/Options", 0);

	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/MIDI/MIDI_data", "GENERAL_MIDI");
	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/MIDI/MIDI_DeviceID", 0);
	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/MIDI/MusicVolume", 0);
	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/MIDI/Options", 0);

	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Sound/Options", 0);
	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Sound/SFXVolume", 0);
	//component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Sound/Sound_GUID", 0);

}
* 
createOpenGLRegistryKeys = function() {
	component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@", "{0}", "cmd", "/C", "reg", "import", "@TargetDir@\\Tools\\ff7_opengl_OVA.reg");
}*/
