@echo off
cd patch3_encrypted
copy /b opmv.wmv.000 + opmv.wmv.001 + opmv.wmv.002 + opmv.wmv.003 + opmv.wmv.004 opmv.wmv.merged
del opmv.wmv.???
ren opmv.wmv.merged opmv.wmv
cd ..
md patch3
for %%I in ("patch3_encrypted\*") do XorCrypt 123 "%%~I" "patch3\%%~nxI"
md "V1.3 Patch"
move patch3\evz01_10.png "V1.3 Patch\patch3.xp3"