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
    ff7 = installer.execute("reg", new Array("HKEY_LOCAL_MACHINE\SOFTWARE\Square Soft, Inc.\Final Fantasy VII\AppPath"));
    if ( !ff7)
        QMessageBox["warning"]( "Error", "FF7", "Final Fantasy 7 not found" );

    if (installer.addWizardPage(component, "TargetWidget", QInstaller.TargetDirectory)) {
        var widget = gui.pageWidgetByObjectName("DynamicTargetWidget");
        if (widget != null) {
            widget.targetDirectory.textChanged.connect(this, Component.prototype.targetChanged);
            widget.targetChooser.clicked.connect(this, Component.prototype.chooseTarget);
            
            widget.windowTitle = "Installation Folder";
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
    if (checked)
        if (ComponentSelectionPage != null)
            ComponentSelectionPage.selectComponent("com.ovaremake.core.en");
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.es");
}

Component.prototype.spanishInstallToggled = function (checked) {
    if (checked)
        if (ComponentSelectionPage != null)
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.en");
            ComponentSelectionPage.selectComponent("com.ovaremake.core.es");
}

Component.prototype.originalMusicToggled = function (checked) {
    if (checked)
        if (ComponentSelectionPage != null)
            ComponentSelectionPage.selectComponent("com.ovaremake.core.original_music");
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.orchestra_music");
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.custom_music");
}

Component.prototype.orchestraMusicToggled = function (checked) {
    if (checked)
        if (ComponentSelectionPage != null)
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.original_music");
            ComponentSelectionPage.selectComponent("com.ovaremake.core.orchestra_music");
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.custom_music");
}

Component.prototype.customMusicToggled = function (checked) {
    if (checked)
        if (ComponentSelectionPage != null)
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.original_music");
            ComponentSelectionPage.deselectComponent("com.ovaremake.core.orchestra_music");
            ComponentSelectionPage.selectComponent("com.ovaremake.core.custom_music");
}
