@echo off
setlocal enabledelayedexpansion


echo Samsung Easy Debloater - Coded by @emikodes on GitHub.
echo.


set "packageFile=packages.txt"


if not exist "%packageFile%" (
    echo Errore: Il file packages.txt non esiste. Crea un file nella stessa directory in cui lo script viene eseguito, seguendo il formato NomePacchetto|DescrizionePacchetto
    pause
    exit /b
)


set count=0
for /f "usebackq tokens=1,2 delims=|" %%a in ("%packageFile%") do (
    set /a count+=1
    set "package[!count!]=%%a"
    set "description[!count!]=%%b"
    echo !count!. %%a - %%b
)

:: Chiede i pacchetti da rimuovere
echo.
set "selection="
set /p "selection=Inserisci i numeri dei pacchetti da rimuovere, separati da spazi: "

:: Conferma
echo.
echo Hai selezionato i seguenti pacchetti:
for %%n in (%selection%) do (
    echo !package[%%n]! - !description[%%n]!
)
echo.
set /p "confirm=Sei sicuro di voler procedere? (S/N): "
if /i not "!confirm!"=="S" (
    echo Operazione annullata.
    pause
    exit /b
)

:: Rimuove i pacchetti selezionati tramite adb
echo.
echo Inizio rimozione dei pacchetti...
for %%n in (%selection%) do (
    echo Rimuovo: !package[%%n]!
    adb shell pm uninstall --user 0 !package[%%n]!
    if !errorlevel! == 0 (
        echo Pacchetto !package[%%n]! rimosso con successo.
    ) else (
        echo Errore durante la rimozione del pacchetto !package[%%n]!.
    )
)
echo Debloating terminato.
echo Samsung Easy Debloater - Coded by @emikodes on GitHub.

pause
exit /b
