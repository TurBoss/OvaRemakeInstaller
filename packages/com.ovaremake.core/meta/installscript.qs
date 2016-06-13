var Dir = new function () {
    this.toNativeSparator = function (path) {
        if (systemInfo.productType === "windows")
            return path.replace(/\//g, '\\');
        return path;
    }
};

function Component() {

    component.loaded.connect(this, Component.prototype.installerLoaded);

    ComponentSelectionPage = gui.pageById(QInstaller.ComponentSelection);

    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
    //installer.setDefaultPageVisible(QInstaller.ComponentSelection, false);
    installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
}

Component.prototype.installerLoaded = function()
{

	var installationCanceled = false;

	if (systemInfo.productType === "windows"){
		if (systemInfo.prettyProductName === "Windows xp"){
			ff7 = installer.execute("reg", new Array("HKEY_LOCAL_MACHINE\SOFTWARE\JauriaStudiosINC.\Final Fantasy VII\AppPath"));
		}
		else {
			ff7 = installer.execute("reg", new Array("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\JauriaStudiosINC.\Final Fantasy VII\AppPath"));
		}
		if ( !ff7 ){
			QMessageBox["warning"]( "Error", "FF7", "Final Fantasy 7 OVA Remake is installed please uninstall it first" );

			installer.setValue("FinishedText", "<font color='red' size=3>Please uninstall FF7 OVA REMAKE from your computer and make a backup of your saves.</font>");

			installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
			installer.setDefaultPageVisible(QInstaller.ReadyForInstallation, false);
			installer.setDefaultPageVisible(QInstaller.ComponentSelection, false);
			installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
			installer.setDefaultPageVisible(QInstaller.PerformInstallation, false);
			installer.setDefaultPageVisible(QInstaller.LicenseCheck, false);

			gui.clickButton(buttons.NextButton);

			installationCanceled = true
		}
	}

	if (!installationCanceled){
		if (installer.addWizardPage(component, "TargetWidget", QInstaller.TargetDirectory)) {
			var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
			if (widget != null) {

				widget.windowTitle = "Installation Folders";

				//widget.installComboBox.setCurrentText("york")

				widget.targetDirectory.text = Dir.toNativeSparator(installer.value("TargetDir"));

				widget.targetDirectory.textChanged.connect(this, Component.prototype.targetChanged);
				widget.targetChooser.clicked.connect(this, Component.prototype.chooseTarget);

				widget.complete = false;
			}
		}

		if (installer.addWizardPage(component, "ComponentWidget", QInstaller.ComponentSelection)) {
			var widget = gui.pageWidgetByObjectName("DynamicComponentWidget");
			if (widget != null) {
				widget.windowTitle = "Components";

				widget.widget_language.english_install.toggled.connect(this, Component.prototype.englishInstallToggled);
				widget.widget_language.spanish_install.toggled.connect(this, Component.prototype.spanishInstallToggled);


				widget.widget_music.original.toggled.connect(this, Component.prototype.originalMusicToggled);
				widget.widget_music.orchestra.toggled.connect(this, Component.prototype.orchestraMusicToggled);
				widget.widget_music.custom.toggled.connect(this, Component.prototype.customMusicToggled);


				widget.widget_hd.minigames.toggled.connect(this, Component.prototype.minigamesToggled);

				widget.widget_hd.worldmap.toggled.connect(this, Component.prototype.worldmapToggled);

				widget.widget_hd.field_backgrounds.toggled.connect(this, Component.prototype.fieldBackgroundsToggled);
				widget.widget_hd.field_models.toggled.connect(this, Component.prototype.fieldModelsToggled);

				widget.widget_hd.battle_backgrounds.toggled.connect(this, Component.prototype.battleBackgroundsToggled);
				widget.widget_hd.battle_models.toggled.connect(this, Component.prototype.battleModelsToggled);

				//widget.complete = true;
			}
		}
	}
}
/*
Component.prototype.chooseInstall = function () {
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget != null) {
        var newTarget = QFileDialog.getExistingDirectory("Choose your target directory.", widget.targetDirectory.text);
        if (newTarget != "") {
            widget.targetDirectory.text = Dir.toNativeSparator(newTarget);
        }
    }
}
*/
Component.prototype.chooseTarget = function () {
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget != null) {
        var newTarget = QFileDialog.getExistingDirectory("Choose your target directory.", widget.targetDirectory.text);
        if (newTarget != "") {
            widget.targetDirectory.text = Dir.toNativeSparator(newTarget);
        }
    }
}

Component.prototype.targetChanged = function (text) {
    var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
    if (widget != null) {
        if (text != "") {
			widget.complete = true;
            installer.setValue("TargetDir", text);
            /*
            if (installer.fileExists(text + "/components.xml")) {
                var warning = "<font color='red'>" + qsTr("A previous installation exists in this folder. If you wish to continue, everything will be overwritten.") + "</font>";
                widget.labelOverwrite.text = warning;
            } else {
                widget.labelOverwrite.text = "";
            }
            */
            return;
        }
		widget.complete = false;
    }
}

Component.prototype.englishInstallToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.selectComponent("com.ovaremake.core.en");
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.es");
        }
    }
}

Component.prototype.spanishInstallToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.en");
            ComponentSelectionPage.selectComponent("com.ovaremake.core.es");
        }
    }
}

Component.prototype.originalMusicToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.selectComponent("com.ovaremake.core.music.original");
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.music.orchestra");
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.music.custom");
        }
    }
}

Component.prototype.orchestraMusicToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.music.original");
            ComponentSelectionPage.selectComponent("com.ovaremake.core.music.orchestra");
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.music.custom");
        }
    }
}

Component.prototype.customMusicToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.music.original");
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.music.orchestra");
            ComponentSelectionPage.selectComponent("com.ovaremake.core.music.custom");
        }
    }
}

Component.prototype.minigamesToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.selectComponent("com.ovaremake.core.hd.minigames");
        }
    }
    else {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.hd.minigames");
        }
    }
}

Component.prototype.worldmapToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.selectComponent("com.ovaremake.core.hd.worldmap");
        }
    }
    else {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.hd.worlmap");
        }
    }
}

Component.prototype.fieldBackgroundsToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.selectComponent("com.ovaremake.core.hd.fields.backgrounds");
        }
    }
    else {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.hd.fields.backgrounds");
        }
    }
}

Component.prototype.fieldModelsToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.selectComponent("com.ovaremake.core.hd.fields.models");
        }
    }
    else {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.hd.fields.models");
        }
    }
}

Component.prototype.battleBackgroundsToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.selectComponent("com.ovaremake.core.hd.battles.backgrounds");
        }
    }
    else {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.hd.battles.backgrounds");
        }
    }
}

Component.prototype.battleModelsToggled = function (checked) {
    if (checked) {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.selectComponent("com.ovaremake.core.hd.battles.models");
        }
    }
    else {
        if (ComponentSelectionPage != null) {
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.hd.battles.models");
        }
    }
}

Component.prototype.createOperations = function() {
    component.createOperations();

    if (installer.isInstaller()) {
        if (systemInfo.productType === "windows") {
			     createRegistryKeys();
        }
    }
    else if (installer.isUninstaller()) {
		QMessageBox["warning"]( "Error", "FF7", "test123" );
		//component.addElevatedOperation("Execute", "cmd", "/C", "echo", "do nothing", "UNDOEXECUTE", "cmd", "/C", "reg", "delete", "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Software\test","/f")
	}
}

createRegistryKeys = function() {
	
	component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@", "{0}", "cmd", "/C", "reg", "import", "@TargetDir@\\ff7_install_Jauria.reg");
	
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "AppPath", Dir.toNativeSparator(installer.value("TargetDir")) + "\\");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "DataPath", Dir.toNativeSparator(installer.value("TargetDir")) + "\\data");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "DataFrive", "F:\\");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "MoviePath", "F:\\FF7\\MOVIES\\");
	
	QMessageBox["warning"]( "Error", "FF7", "FF7 Config will start. Please select a sound card under the soud tab" );
	
	component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@", "@TargetDir@\\FF7Config.exe", "/lol");
	
	component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@", "{0}", "cmd", "/C", "reg", "import", "@TargetDir@\\ff7_opengl_Jauria.reg");
	
	/*
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "DiskNo", 0);
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "FullInstall", 0);

	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Graphics/DD_GUID", 0);
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Graphics/Driver", 0);
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Graphics/DriverPath", "ff7_opengl.fgd");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Graphics/Mode", 0);
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Graphics/Options", 0);

	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/MIDI/MIDI_data", "GENERAL_MIDI");
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/MIDI/MIDI_DeviceID", 0);
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/MIDI/MusicVolume", 0);
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/MIDI/Options", 0);

	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Sound/Options", 0);
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Sound/SFXVolume", 0);
	component.addElevatedOperation("GlobalConfig", "SystemScope", "JauriaStudios INC", "FF VII OVA Remake", "1.00/Sound/Sound_GUID", 0);
	*/
}
