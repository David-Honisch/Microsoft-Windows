@echo off
set "target=%1"
set "name=%2"
echo OUT:%target%
echo set plugin=%name% >> %target%
echo set plugin=%name%  >> %target%
echo set title=%name% Plugin >> %target%
echo set version=v.0.1.121a >> %target%
@echo on