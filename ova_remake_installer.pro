TEMPLATE = aux

INSTALLER = installer

INPUT += $$PWD/config/config.xml
INPUT += $$PWD/config/controlscript.js

INPUT += $$PWD/packages/com.turbo.backend/meta/installscript.js
INPUT += $$PWD/packages/com.turbo.backend/meta/package.xml
INPUT += $$PWD/packages/com.turbo.backend/meta/targetwidget.ui

INPUT += $$PWD/packages/com.turbo.core/meta/corescript.js
INPUT += $$PWD/packages/com.turbo.core/meta/package.xml

INPUT += $$PWD/packages/com.turbo.data/meta/datascript.js
INPUT += $$PWD/packages/com.turbo.data/meta/package.xml

INPUT += $$PWD/packages/com.turbo.disk1/meta/disk1script.js
INPUT += $$PWD/packages/com.turbo.disk1/meta/package.xml

INPUT += $$PWD/packages/com.turbo.disk2/meta/disk2script.js
INPUT += $$PWD/packages/com.turbo.disk2/meta/package.xml

INPUT += $$PWD/packages/com.turbo.disk3/meta/disk3script.js
INPUT += $$PWD/packages/com.turbo.disk3/meta/package.xml

turboinstaller.input = INPUT
turboinstaller.output = $$INSTALLER
turboinstaller.commands = C:\Qt\Tools\QtInstallerFramework\3.1\bin\binarycreator.exe -c $$PWD/config/config.xml -p $$PWD/packages ${QMAKE_FILE_OUT}
turboinstaller.CONFIG += target_predeps no_link combine

QMAKE_EXTRA_COMPILERS += turboinstaller

OTHER_FILES = README
