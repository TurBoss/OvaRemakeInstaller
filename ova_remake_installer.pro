TEMPLATE = aux

INSTALLER = installer

INPUT += $$PWD/config/config.xml
INPUT += $$PWD/config/controlscript.js

INPUT += $$PWD/packages/com.ovaremake.backend/meta/installscript.js
INPUT += $$PWD/packages/com.ovaremake.backend/meta/package.xml
INPUT += $$PWD/packages/com.ovaremake.backend/meta/targetwidget.ui

INPUT += $$PWD/packages/com.ovaremake.core/meta/package.xml

INPUT += $$PWD/packages/com.ovaremake.data/meta/datascript.js
INPUT += $$PWD/packages/com.ovaremake.data/meta/package.xml

INPUT += $$PWD/packages/com.ovaremake.disk1/meta/disk1script.js
INPUT += $$PWD/packages/com.ovaremake.disk1/meta/package.xml

INPUT += $$PWD/packages/com.ovaremake.disk2/meta/disk2script.js
INPUT += $$PWD/packages/com.ovaremake.disk2/meta/package.xml

INPUT += $$PWD/packages/com.ovaremake.disk3/meta/disk3script.js
INPUT += $$PWD/packages/com.ovaremake.disk3/meta/package.xml

ovaremake.input = INPUT
ovaremake.output = $$INSTALLER
ovaremake.commands = C:\Qt\Tools\QtInstallerFramework\3.0\bin\binarycreator.exe -c $$PWD/config/config.xml -p $$PWD/packages ${QMAKE_FILE_OUT}
ovaremake.CONFIG += target_predeps no_link combine

QMAKE_EXTRA_COMPILERS += ovaremake

OTHER_FILES = README
