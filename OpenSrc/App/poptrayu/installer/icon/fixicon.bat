::---------------------------------------------------------------------------
:: PopTrayU Icon Replacer Script
::---------------------------------------------------------------------------
:: Description:
:: Changes the Icon on the PopTrayU executable to have a Vista Quality Icon.
::
:: Usage: 
:: Double click the script icon. Review results and press any key to exit.
::---------------------------------------------------------------------------
@echo OFF
ECHO About to replace PopTrayU Icon...
@echo oN
ReplaceVistaIcon.exe ../PopTrayU.exe "poptrayuVista.ico"
@echo OFF
@echo:
ECHO If no error message is shown above, icon replacement was successful.
@echo:
pause