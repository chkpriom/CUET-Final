#!/bin/bash

# Local CI Check Script
# This script runs all CI checks locally before pushing to ensure they will pass

set -e  # Exit on first error

echo "🚀 Running local CI checks..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print success
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print error
error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to print info
info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    info "Installing dependencies..."
    npm ci
    echo ""
fi

# Stage 1: Lint
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Stage 1: Linting"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if npm run lint; then
    success "Linting passed"
else
    error "Linting failed"
    info "Run 'npm run lint:fix' to auto-fix issues"
    exit 1
fi
echo ""

# Stage 2: Format Check
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💅 Stage 2: Format Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if npm run format:check; then
    success "Format check passed"
else
    error "Format check failed"
    info "Run 'npm run format' to auto-format code"
    exit 1
fi
echo ""

# Stage 3: E2E Tests
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Stage 3: E2E Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check Node version
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 24 ]; then
    echo -e "${YELLOW}⚠️  Node.js 24+ required for E2E tests${NC}"
    echo -e "${YELLOW}   Current version: $(node --version)${NC}"
    echo ""
    info "Running E2E tests in Docker instead..."
    echo ""
    
    # Check if Docker is available
    if ! command -v docker &> /dev/null; then
        error "Docker not found. Please install Docker or upgrade Node.js to 24+"
        exit 1
    fi
    
    # Check if containers are running
    if ! docker compose -f docker/compose.dev.yml ps | grep -q "Up"; then
        info "Starting Docker containers..."
        docker compose -f docker/compose.dev.yml up -d
        sleep 10
    fi
    
    # Run tests in Docker
    if docker exec delineate-delineate-app-1 npm run test:e2e 2>/dev/null; then
        success "E2E tests passed (in Docker)"
    else
        error "E2E tests failed (in Docker)"
        info "Make sure Docker services are running: npm run docker:dev"
        exit 1
    fi
else
    # Run tests locally if Node 24+ is available
    if npm run test:e2e; then
        success "E2E tests passed"
    else
        error "E2E tests failed"
        info "Check test output above for details"
        exit 1
    fi
fi
echo ""

# Stage 4: Docker Build (optional - commented out by default)
# Uncomment to test Docker build locally
# echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
# echo "🐳 Stage 4: Docker Build"
# echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
# if docker build -f docker/Dockerfile.prod -t test-build .; then
#     success "Docker build passed"
#     docker rmi test-build  # Clean up
# else
#     error "Docker build failed"
#     exit 1
# fi
# echo ""

# All checks passed!
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
success "All CI checks passed! 🎉"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
info "You can now push your changes:"
echo "  git push origin <branch-name>"
echo ""
