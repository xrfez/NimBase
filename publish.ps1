# Docker Hub Publishing Script
# Builds and publishes the Nim development environment to Docker Hub

param(
    [Parameter(Mandatory=$true)]
    [string]$Username,
    
    [Parameter(Mandatory=$false)]
    [string]$Version = "latest",
    
    [Parameter(Mandatory=$false)]
    [switch]$NoPush,
    
    [Parameter(Mandatory=$false)]
    [switch]$NoCache
)

$ImageName = "$Username/nim-dev"

Write-Host "======================================"  -ForegroundColor Cyan
Write-Host "  Nim Docker Hub Publisher" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Image: $ImageName" -ForegroundColor Green
Write-Host "Version: $Version" -ForegroundColor Green
Write-Host ""

# Check if logged in to Docker Hub
Write-Host "Checking Docker Hub login..." -ForegroundColor Yellow
$loginCheck = docker info 2>&1 | Select-String "Username"
if (-not $loginCheck) {
    Write-Host "Not logged in to Docker Hub. Please login:" -ForegroundColor Red
    docker login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Login failed. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Build the image
Write-Host "Building Docker image..." -ForegroundColor Green
$buildArgs = @("build", "-t", "${ImageName}:${Version}")

if ($NoCache) {
    $buildArgs += "--no-cache"
}

$buildArgs += "."

Write-Host "Running: docker $($buildArgs -join ' ')" -ForegroundColor Gray
& docker @buildArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Build successful!" -ForegroundColor Green
Write-Host ""

# Tag as latest if version is specified
if ($Version -ne "latest") {
    Write-Host "Tagging as latest..." -ForegroundColor Yellow
    docker tag "${ImageName}:${Version}" "${ImageName}:latest"
    
    # Also create major and minor version tags
    if ($Version -match '^(\d+)\.(\d+)\.(\d+)$') {
        $major = $Matches[1]
        $minor = "$($Matches[1]).$($Matches[2])"
        
        Write-Host "Creating version tags: $major, $minor" -ForegroundColor Yellow
        docker tag "${ImageName}:${Version}" "${ImageName}:${major}"
        docker tag "${ImageName}:${Version}" "${ImageName}:${minor}"
    }
}

# List created tags
Write-Host ""
Write-Host "Created images:" -ForegroundColor Cyan
docker images | Select-String $ImageName

Write-Host ""

# Push to Docker Hub
if (-not $NoPush) {
    Write-Host "Pushing to Docker Hub..." -ForegroundColor Green
    
    docker push "${ImageName}:${Version}"
    
    if ($Version -ne "latest") {
        docker push "${ImageName}:latest"
        
        if ($Version -match '^(\d+)\.(\d+)\.(\d+)$') {
            $major = $Matches[1]
            $minor = "$($Matches[1]).$($Matches[2])"
            docker push "${ImageName}:${major}"
            docker push "${ImageName}:${minor}"
        }
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "======================================"  -ForegroundColor Green
        Write-Host "  Successfully published!" -ForegroundColor Green
        Write-Host "======================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your image is now available at:" -ForegroundColor Cyan
        Write-Host "  docker pull ${ImageName}:${Version}" -ForegroundColor White
        Write-Host "  https://hub.docker.com/r/${ImageName}" -ForegroundColor Gray
        Write-Host ""
    } else {
        Write-Host "Push failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Skipping push (--NoPush flag set)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To push manually:" -ForegroundColor Cyan
    Write-Host "  docker push ${ImageName}:${Version}" -ForegroundColor White
    if ($Version -ne "latest") {
        Write-Host "  docker push ${ImageName}:latest" -ForegroundColor White
    }
}
