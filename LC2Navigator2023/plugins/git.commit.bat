@echo off
git commit -a -m 'Updates on https://www.letztechance.org %1'
timeout 3
git push
timeout 3