import sys
from winreg import *

REG_PATH = r"SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"


def set_reg(name, value):

    try:
        CreateKey(HKEY_LOCAL_MACHINE, REG_PATH)
        registry_key = OpenKey(HKEY_LOCAL_MACHINE, REG_PATH, 0, KEY_ALL_ACCESS)
        SetValueEx(registry_key, name, 0, REG_SZ, value)
        CloseKey(registry_key)
        return True

    except WindowsError:
        return False


def main(path):
    if set_reg(path, "$ DWM8And16BitMitigation WINXPSP3"):
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main(sys.argv[1])
