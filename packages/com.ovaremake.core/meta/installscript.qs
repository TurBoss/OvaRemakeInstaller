var Dir = new function () {
    this.toNativeSparator = function (path) {
        if (systemInfo.productType === "windows")
            return path.replace(/\//g, '\\');
        return path;
    }
};

function Component() {
    component.loaded.connect(this, Component.prototype.installerLoaded);
    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
}

Component.prototype.installerLoaded = function()
{

    installer.componentByName("com.ovaremake.core.es").setValue("Default", true);
    
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

/*
Component.prototype.createOperations = function()
{
    component.createOperations();

    if (installer.isInstaller()){
        if (systemInfo.productType === "windows"){

            if (systemInfo.prettyProductName === "Windows XP") {

                dotNet40 = installer.execute("reg", new Array("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\|NET Framework Setup\\NDP\\v4\Full\\Install") );
                if ( !dotNet40)
                    //QMessageBox["warning"]( "netError", ".NET", ".NET 4.0 Not Found" );

                    component.addElevatedOperation("Execute",
                                            "{0,1602,5100}",
                                            "@TargetDir@\\dotNetFx40_Full_setup.exe",
                                            "/norestart");
                    component.addElevatedOperation("Delete", "@TargetDir@\\dotnet\\dotNetFx40_Full_setup.exe");
            }
        }
    }
}
*/
