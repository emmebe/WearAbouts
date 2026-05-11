#!/bin/bash
# Simple script to run the WearAbouts website

echo "Starting WearAbouts website server..."
echo "Open http://localhost:8080 in your browser"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

cd "$(dirname "$0")"
python3 -m http.server 8080