@ECHO OFF
REM *******************************************************************************************************************************
REM * This is a sample script. Note that with the help of these parameters no graphical user interface will be displayed. This    *
REM * sample shows how DieboldDownloadService is to be called in order to load firmware 'TH250A142A.apc' (for example) to the     *
REM * TH250 (for example). The firmware path and communication interface can be set using config.xml.                             *
REM *******************************************************************************************************************************
SET lib_path=C:\TH2xxDownloadService\lib
SET app_path=C:\TH2xxDownloadService

set classpath=.;%lib_path%\junit-4.1.jar;%lib_path%\log4j-1.2.14.jar;%lib_path%\RXTXcomm.jar;%lib_path%\TH2xxDownloadService.jar;

::java -Djava.library.path=%lib_path% com.dn.downloadservice.DownloadFW TH210 TH210A154A.apc %app_path%
java -Djava.library.path=%lib_path% com.dn.downloadservice.DownloadFW TH250 TH250A180A.apc %app_path%
::java -Djava.library.path=%lib_path% com.dn.downloadservice.DownloadFW TH210 189-798L113.ldr %app_path%
::java -Djava.library.path=%lib_path% com.dn.downloadservice.DownloadFW TH250 189-799L113.ldr %app_path%
::java -Djava.library.path=%lib_path% com.dn.downloadservice.DownloadFW TH250 th2xxrez_pst_sample.txt %app_path%
::java -Djava.library.path=%lib_path% com.dn.downloadservice.DownloadFW TH210 -gui %app_path%
::java -Djava.library.path=%lib_path% com.dn.downloadservice.DownloadFW TH250 -gui %app_path%

