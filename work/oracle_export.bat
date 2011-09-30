@echo off

set rwc_user=rwc
set rwc_pwd=rwc
set nsi_user=nsi
set nsi_pwd=nsi
set etran_user=etran
set etran_pwd=etran

set srv_name=prof

set TNS_ADMIN=D:\oraclecl\product\10.2.0\client_1\


:====================================================================

set dumpdir=C:\Dumps\%date%
mkdir %dumpdir%

set backupdir=f:\Backup\%date%\oracle
mkdir %backupdir%

:====================================================================

cd %dumpdir%

:==================================

@echo .....Create dump-file RWC .....
exp %rwc_user%/%rwc_pwd%@%srv_name% file=%dumpdir%\rwc consistent=y compress=y log=%dumpdir%\rwc.log
@echo .....Dump-file RWC created .....
@echo 

start /wait /low winrar a %dumpdir%\rwc.rar %dumpdir%\rwc.dmp
del %dumpdir%\rwc.dmp

:--------------------------------------------------------------------

@echo .....Create dump-file NSI .....
exp %nsi_user%/%nsi_pwd%@%srv_name% file=%dumpdir%\nsi consistent=y compress=y log=%dumpdir%\nsi.log
@echo .....Dump-file NSI created .....
@echo 

start /wait /low winrar a %dumpdir%\nsi.rar %dumpdir%\nsi.dmp
del %dumpdir%\nsi.dmp

:-----------------------------------------------------------

@echo .....Create dump-file ETRAN .....
exp %etran_user%/%etran_pwd%@%srv_name% file=%dumpdir%\etran consistent=y compress=y log=%dumpdir%\etran.log
@echo .....Dump-file ETRAN created .....
@echo 

:--------------------------------------------------------------------

start /wait /low winrar a %dumpdir%\etran.rar %dumpdir%\etran.dmp
del %dumpdir%\etran.dmp

copy %dumpdir% %backupdir%

