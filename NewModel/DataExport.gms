$SETGLOBAL GDXFile "HCropFail"
execute 'GDXXRW.exe input=Results/%GDXFile%.gdx output=Results/%GDXFile%.xlsx Acronyms=1 @Results/export_xls.txt';
execute 'XLSTalk -O Results/%GDXFile%.xlsx';
