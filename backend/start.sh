#!/bin/bash
# Ludus Trading Platform - Quick Start Script

set -e

echo "🚀 Starting Ludus Trading Platform Backend..."
echo ""

# Ensure main trading config exists (auto-create from example if missing)
if [ ! -f "config/trading_config.yaml" ]; then
    if [ -f "config/trading_config.yaml.example" ]; then
        echo "ℹ️  config/trading_config.yaml not found, creating from template..."
        cp "config/trading_config.yaml.example" "config/trading_config.yaml"
        echo "✅ Created config/trading_config.yaml from config/trading_config.yaml.example"
        echo ""
    else
        echo "❌ config/trading_config.yaml not found and no template config/trading_config.yaml.example present."
        echo "Please add a config file under backend/config first."
        echo ""
        exit 1
    fi
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "Please run setup first:"
    echo ""
    echo "  python3.13 -m venv venv"
    echo "  source venv/bin/activate"
    echo "  pip install -e ."
    echo ""
    exit 1
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "Please create .env file from .env.example and configure it."
    echo ""
    exit 1
fi

# Activate virtual environment and start
echo "✅ Activating virtual environment..."
source venv/bin/activate

echo "✅ Starting backend server..."
echo ""
python -m roma_trading.main

