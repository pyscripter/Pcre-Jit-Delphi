Push-Location Source
Copy-Item "C:\Program Files (x86)\Embarcadero\Studio\21.0\source\rtl\common\System.RegularExpressionsAPI.pas"
git apply --ignore-space-change --ignore-whitespace --whitespace=nowarn --unsafe-paths .\RegularExpressionsApi.diff
Pop-Location