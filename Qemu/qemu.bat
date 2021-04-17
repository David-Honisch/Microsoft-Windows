@ECHO OFF
pushd "%~dp0"
cd qemu
start qemu.exe  ^
-smbios type=1,manufacturer=Intel,version=1.01234,uuid=564d81c6-cd3a-d8e4-db29-756df139acb9 ^
-uuid 564d81c6-cd3a-d8e4-db29-756df139acb9 ^
-net nic,vlan=0 -net user,vlan=0 -redir tcp:1688::1688 ^
-m 350 ^
-rtc base=localtime,clock=host ^
-hda Bios\openqemupc.rom ^
-name "Tomahawk IP-127.0.0.1:1688" ^
-M pc ^
-L Bios
popd
exit