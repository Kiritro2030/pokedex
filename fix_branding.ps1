# Script para corregir el branding después de regenerar splash
Write-Host "Copiando branding.png con tamaño original..." -ForegroundColor Cyan
Copy-Item assets\branding.png android\app\src\main\res\drawable-mdpi\branding.png -Force
Copy-Item assets\branding.png android\app\src\main\res\drawable-hdpi\branding.png -Force
Copy-Item assets\branding.png android\app\src\main\res\drawable-xhdpi\branding.png -Force
Copy-Item assets\branding.png android\app\src\main\res\drawable-xxhdpi\branding.png -Force
Copy-Item assets\branding.png android\app\src\main\res\drawable-xxxhdpi\branding.png -Force
Write-Host "✓ Branding corregido!" -ForegroundColor Green
