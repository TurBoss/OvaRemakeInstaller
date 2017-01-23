var Dir = new function ()
{
    this.toNativeSparator = function (path) {
        if (systemInfo.productType === "windows")
            return path.replace(/\//g, '\\');
        return path;
    }
}

function Controller()
{
    installer.setDefaultPageVisible(QInstaller.ComponentSelection, true);
    if (systemInfo.productType === "windows")
		installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
		
    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
    installer.setValue("disk",0);
	
}

Controller.prototype.IntroductionPageCallback = function()
{
    var widget = gui.currentPageWidget(); // get the current wizard page
    if (widget != null) {
        widget.title = "FF7 OVA Remake 1.0"; // set the page title
        widget.MessageLabel.setText("This is the installer of the FF7 OVA Remake MOD. Requires the original 1998 installtion disk UE Version"); // set the welcome text
    }
}

Controller.prototype.LicenseAgreementPageCallback = function()
{
    var widget = gui.currentPageWidget();
    if (widget != null) {
        widget.AcceptLicenseRadioButton.checked = true;
    }
}
