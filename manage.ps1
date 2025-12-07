# NimBase Docker Helper Script
# Convenience commands for managing the Nim development container
# Usage: .\manage.ps1 <command>

param(
    [Parameter(Position=0)]
    [string]$Command = "help"
)

function Show-Help {
    Write-Host "======================================"  -ForegroundColor Cyan
    Write-Host "  Nim Docker Environment Manager" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\manage.ps1 <command>" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Green
    Write-Host "  start         - Start the container" -ForegroundColor White
    Write-Host "  stop          - Stop the container" -ForegroundColor White
    Write-Host "  restart       - Restart the container" -ForegroundColor White
    Write-Host "  build         - Build/rebuild the container" -ForegroundColor White
    Write-Host "  shell         - Enter the container shell" -ForegroundColor White
    Write-Host "  logs          - View container logs" -ForegroundColor White
    Write-Host "  status        - Show container status" -ForegroundColor White
    Write-Host "  clean         - Remove container and images" -ForegroundColor White
    Write-Host "  clean-all     - Remove container, images, and volumes" -ForegroundColor White
    Write-Host "  vscode        - Open in VS Code" -ForegroundColor White
    Write-Host "  help          - Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Green
    Write-Host "  .\manage.ps1 start" -ForegroundColor Gray
    Write-Host "  .\manage.ps1 shell" -ForegroundColor Gray
    Write-Host "  .\manage.ps1 build" -ForegroundColor Gray
    Write-Host ""
}

function Start-Container {
    Write-Host "Starting Nim development container..." -ForegroundColor Green
    docker-compose up -d
    Write-Host "Container started! Use '.\manage.ps1 shell' to enter." -ForegroundColor Cyan
}

function Stop-Container {
    Write-Host "Stopping Nim development container..." -ForegroundColor Yellow
    docker-compose down
    Write-Host "Container stopped." -ForegroundColor Cyan
}

function Restart-Container {
    Write-Host "Restarting Nim development container..." -ForegroundColor Yellow
    docker-compose restart
    Write-Host "Container restarted." -ForegroundColor Cyan
}

function Build-Container {
    Write-Host "Building Nim development container..." -ForegroundColor Green
    docker-compose up -d --build
    Write-Host "Build complete!" -ForegroundColor Cyan
}

function Enter-Shell {
    Write-Host "Entering container shell..." -ForegroundColor Green
    docker-compose exec nim-dev bash
}

function Show-Logs {
    Write-Host "Showing container logs (Ctrl+C to exit)..." -ForegroundColor Green
    docker-compose logs -f nim-dev
}

function Show-Status {
    Write-Host "Container Status:" -ForegroundColor Cyan
    docker-compose ps
    Write-Host ""
    Write-Host "Docker Images:" -ForegroundColor Cyan
    docker images | Select-String "nim-dev"
    Write-Host ""
    Write-Host "Docker Volumes:" -ForegroundColor Cyan
    docker volume ls | Select-String "nim-dev"
}

function Clean-Container {
    Write-Host "Removing container and images..." -ForegroundColor Yellow
    $confirmation = Read-Host "Are you sure? (y/N)"
    if ($confirmation -eq 'y') {
        docker-compose down
        docker rmi nim-dev:latest -f
        Write-Host "Cleaned up container and images." -ForegroundColor Cyan
    } else {
        Write-Host "Cancelled." -ForegroundColor Gray
    }
}

function Clean-All {
    Write-Host "Removing container, images, AND volumes..." -ForegroundColor Red
    Write-Host "WARNING: This will delete all cached packages!" -ForegroundColor Red
    $confirmation = Read-Host "Are you sure? (y/N)"
    if ($confirmation -eq 'y') {
        docker-compose down -v
        docker rmi nim-dev:latest -f
        Write-Host "Cleaned up everything." -ForegroundColor Cyan
    } else {
        Write-Host "Cancelled." -ForegroundColor Gray
    }
}

function Open-VSCode {
    Write-Host "Opening in VS Code..." -ForegroundColor Green
    code .
    Write-Host "Use F1 -> 'Dev Containers: Reopen in Container' to start" -ForegroundColor Cyan
}

# Main command router
switch ($Command.ToLower()) {
    "start" { Start-Container }
    "stop" { Stop-Container }
    "restart" { Restart-Container }
    "build" { Build-Container }
    "shell" { Enter-Shell }
    "logs" { Show-Logs }
    "status" { Show-Status }
    "clean" { Clean-Container }
    "clean-all" { Clean-All }
    "vscode" { Open-VSCode }
    "help" { Show-Help }
    default {
        Write-Host "Unknown command: $Command" -ForegroundColor Red
        Write-Host ""
        Show-Help
        exit 1
    }
}
