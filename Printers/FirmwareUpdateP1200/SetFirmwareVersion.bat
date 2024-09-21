set JAVA_HOME="%~dp0_JRE\bin"

xcopy "%~dp0_Firmware\P1200_Firmware_00.54" c:\windows\temp\P1200_Firmware_00.54\ /S /Y /E
%JAVA_HOME%\java -Djava.library.path="%~dp0lib" -jar "%~dp0DNPrinterUtility.jar" -U -d -p c:\windows\temp\P1200_Firmware_00.54\P1200_MAJ_FRM0054_ForcePrint.xml
