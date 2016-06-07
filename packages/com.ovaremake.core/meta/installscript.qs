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
	
	var installationCanceled = false
	
	if (systemInfo.productType === "windows"){
		if (systemInfo.prettyProductName === "Windows xp"){
			
			ff7 = installer.execute("reg", new Array("HKEY_LOCAL_MACHINE\SOFTWARE\Square Soft, Inc.\Final Fantasy VII\AppPath"));
			if ( ff7 ){
				
				QMessageBox["warning"]( "Error", "FF7", "Final Fantasy 7 is installed please uninstall it first" );
				
				installer.setValue("FinishedText", "<font color='red' size=3>Please uninstall FF7 from your computer and make a backup of your saves.</font>");
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
		else {
			
			ff7 = installer.execute("reg", new Array("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Square Soft, Inc.\Final Fantasy VII\AppPath"));
			if ( !ff7 ){
				QMessageBox["warning"]( "Error", "FF7", "Final Fantasy 7 is installed please uninstall it first" );

				installer.setValue("FinishedText", "<font color='red' size=3>Please uninstall FF7 from your computer and make a backup of your saves.</font>");
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
	
	}

	if (!installationCanceled){
		if (installer.addWizardPage(component, "TargetWidget", QInstaller.TargetDirectory)) {
			var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
			if (widget != null) {
				widget.targetDirectory.textChanged.connect(this, Component.prototype.targetChanged);
				widget.targetChooser.clicked.connect(this, Component.prototype.chooseTarget);
				
				widget.windowTitle = "Installation Folders";
				widget.targetDirectory.text = Dir.toNativeSparator(installer.value("TargetDir"));
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
				
			}
		}
	}
}

// Callback when one is clicking on the button to select where to install your application
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
            if (installer.fileExists(text + "/components.xml")) {
                var warning = "<font color='red'>" + qsTr("A previous installation exists in this folder. If you wish to continue, everything will be overwritten.") + "</font>";
                widget.labelOverwrite.text = warning;
            } else {
                widget.labelOverwrite.text = "";
            }
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
