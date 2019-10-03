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
}


Component.prototype.createOperations = function()
{

    installer.gainAdminRights();

    component.createOperations();
    createSetupRegistryKeys();
    createOpenGLRegistryKeys();
    createCompatibilityFlags();
    createAudioRegistryKeys();
    createDesktopIcon();
}

var createSetupRegistryKeys = function()
{

    installer.gainAdminRights();
    component.addElevatedOperation("GlobalConfig", "SystemScope", "Square Soft, Inc.", "Final Fantasy VII", "AppPath", Dir.toNativeSparator(installer.value("TargetDir")) + "\\");
    component.addElevatedOperation("GlobalConfig", "SystemScope", "Square Soft, Inc.", "Final Fantasy VII", "DataPath", Dir.toNativeSparator(installer.value("TargetDir")) + "\\data\\");
    component.addElevatedOperation("GlobalConfig", "SystemScope", "Square Soft, Inc.", "Final Fantasy VII", "MoviePath", Dir.toNativeSparator(installer.value("TargetDir")) + "\\data\\movies\\");
    component.addElevatedOperation("GlobalConfig", "SystemScope", "Square Soft, Inc.", "Final Fantasy VII", "DataDrive", Dir.toNativeSparator(installer.value("diskPath")));

    component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@\\Tools", "{0}", "cmd", "/C", "reg", "import", "@TargetDir@\\Tools\\ff7_install.reg");
}

var createOpenGLRegistryKeys = function()
{

    installer.gainAdminRights();
    component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@\\Tools", "{0}", "cmd", "/C", "reg", "import", "@TargetDir@\\Tools\\ff7_opengl.reg");
}

var createCompatibilityFlags = function()
{

    installer.gainAdminRights();
    component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@\\Tools\\fileFlags", "{0}", "@TargetDir@\\Tools\\fileFlags\\main.exe", "@TargetDir@\\ff7.exe", '"$ DWM8And16BitMitigation WINXPSP3"');
    component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@\\Tools\\fileFlags", "{0}", "@TargetDir@\\Tools\\fileFlags\\main.exe", "@TargetDir@\\Tools\\devcon.exe", '"RUNASADMIN"');

}

var createAudioRegistryKeys = function()
{

    installer.gainAdminRights();
    component.addElevatedOperation("Execute", "workingdirectory=@TargetDir@\\Tools", "{0}", "cmd", "/C", "@TargetDir@\\Tools\\findSoundCard.bat");
}

var createDesktopIcon = function()
{
    component.addOperation("CreateShortcut", "@TargetDir@/ff7.exe", "@DesktopDir@/ff7.lnk");
}
