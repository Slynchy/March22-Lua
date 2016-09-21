@echo off

pause

REM extract the archive to extracted
REM echo Extracting [4ls]_katawa_shoujo_1.3.1-[windows][A6A47E20].exe...
REM 7z x "[4ls]_katawa_shoujo_1.3.1-[windows][A6A47E20].exe" -oextracted


REM extract the rpa files somewhere
REM echo Extracting data.rpa...
REM python rpatool.py -x ./extracted/$_OUTDIR/game/data.rpa -o extracted_assets


REM decompile the script files
REM echo Decompiling .rpyc files in ./extracted/$_OUTDIR/game...
REM python unrpyc.pyc ./extracted/$_OUTDIR/game


REM copy decompiled script files somewhere
REM echo Moving script-a1-monday.rpy to RPYtoLua/scripts
REM copy "%~dp0extracted\$_OUTDIR\game\script-a1-monday.rpy" "%~dp0RPYtoLua\scripts"

REM echo Moving script-a1-tuesday.rpy to RPYtoLua/scripts
REM copy "%~dp0extracted\$_OUTDIR\game\script-a1-tuesday.rpy" "%~dp0RPYtoLua\scripts"

REM echo Moving script-a1-wednesday.rpy to RPYtoLua/scripts
REM copy "%~dp0extracted\$_OUTDIR\game\script-a1-wednesday.rpy" "%~dp0RPYtoLua\scripts"

REM echo Moving script-a1-thursday.rpy to RPYtoLua/scripts
REM copy "%~dp0extracted\$_OUTDIR\game\script-a1-thursday.rpy" "%~dp0RPYtoLua\scripts"

REM echo Moving script-a1-friday.rpy to RPYtoLua/scripts
REM copy "%~dp0extracted\$_OUTDIR\game\script-a1-friday.rpy" "%~dp0RPYtoLua\scripts"

REM echo Moving script-a1-saturday.rpy to RPYtoLua/scripts
REM copy "%~dp0extracted\$_OUTDIR\game\script-a1-saturday.rpy" "%~dp0RPYtoLua\scripts"

REM echo Moving script-a1-sunday.rpy to RPYtoLua/scripts
REM copy "%~dp0extracted\$_OUTDIR\game\script-a1-sunday.rpy" "%~dp0RPYtoLua\scripts"


REM Delete the extracted folder; it is no longer needed
REM RD /S /Q "%~dp0extracted"


REM run RPYtoLua and copy the "output" folder to PSVita/scripts
REM cd RPYtoLua
REM RPYtoLua.exe
REM cd ..
REM echo Moving script-a1-monday.rpy to RPYtoLua/scripts
REM copy "%~dp0RPYtoLua\output\script-a1-monday.lua" "%~dp0PSVita\scripts"
REM echo Moving script-a1-tuesday.rpy to RPYtoLua/scripts
REM copy "%~dp0RPYtoLua\output\script-a1-tuesday.lua" "%~dp0PSVita\scripts"
REM echo Moving script-a1-wednesday.rpy to RPYtoLua/scripts
REM copy "%~dp0RPYtoLua\output\script-a1-wednesday.lua" "%~dp0PSVita\scripts"
REM echo Moving script-a1-thursday.rpy to RPYtoLua/scripts
REM copy "%~dp0RPYtoLua\output\script-a1-thursday.lua" "%~dp0PSVita\scripts"
REM echo Moving script-a1-friday.rpy to RPYtoLua/scripts
REM copy "%~dp0RPYtoLua\output\script-a1-friday.lua" "%~dp0PSVita\scripts"
REM echo Moving script-a1-saturday.rpy to RPYtoLua/scripts
REM copy "%~dp0RPYtoLua\output\script-a1-saturday.lua" "%~dp0PSVita\scripts"
REM echo Moving script-a1-sunday.rpy to RPYtoLua/scripts
REM copy "%~dp0RPYtoLua\output\script-a1-sunday.lua" "%~dp0PSVita\scripts"

REM now the hard bit... assets.

pause