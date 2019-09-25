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

function Controller()
{
    installer.setDefaultPageVisible(QInstaller.ComponentSelection, false);
    if (systemInfo.productType === "windows")
		installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
		
    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
    installer.setValue("disk",0);
	
}

Controller.prototype.IntroductionPageCallback = function()
{
    var widget = gui.currentPageWidget(); // get the current wizard page
    if (widget !== null) {
        widget.title = "TurBoInstaller"; // set the page title
        widget.MessageLabel.setText("This is a installer for the Final Fantasy 7. Requires the original 1998 installtion disks"); // set the welcome text
    }
}

Controller.prototype.LicenseAgreementPageCallback = function()
{
    var widget = gui.currentPageWidget();
    if (widget !== null) {
        widget.AcceptLicenseRadioButton.checked = true;
    }
}
