@echo off
cd patch3_encrypted
copy /b opmv.wmv.000 + opmv.wmv.001 + opmv.wmv.002 + opmv.wmv.003 + opmv.wmv.004 opmv.wmv.merged
del opmv.wmv.???
ren opmv.wmv.merged opmv.wmv
cd ..
for %%i in (patch3_encrypted\*) do cscript //nologo XorCrypt.vbs 123 %%i %%i.xored
md patch3
move patch3_encrypted\*.xored patch3\
cd patch3
for /f "delims=" %%i in ('dir /b /a-d *.xored') do ren "%%~i" "%%~ni"
pause