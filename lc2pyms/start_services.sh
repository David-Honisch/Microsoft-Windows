#!/bin/bash
# Unix/Linux/Mac script to start all microservices

echo "Starting Python Microservices..."
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed"
    exit 1
fi

# Install dependencies if needed
echo "Checking dependencies..."
if ! python3 -c "import flask" &> /dev/null; then
    echo "Installing dependencies..."
    pip3 install -r requirements.txt
fi

echo ""
echo "Starting services..."
echo ""

# Start Authentication Service
echo "Starting Authentication Service on port 8000..."
cd auth_service
python3 app.py &
AUTH_PID=$!
cd ..
sleep 3

# Start Service 1
echo "Starting User Management Service on port 8001..."
cd service1
python3 app.py &
SERVICE1_PID=$!
cd ..
sleep 2

# Start Service 2
echo "Starting Data Analytics Service on port 8002..."
cd service2
python3 app.py &
SERVICE2_PID=$!
cd ..
sleep 2

echo ""
echo "All services started!"
echo ""
echo "Services:"
echo "- Auth Service:     http://localhost:8000 (PID: $AUTH_PID)"
echo "- Service 1:        http://localhost:8001 (PID: $SERVICE1_PID)"
echo "- Service 2:        http://localhost:8002 (PID: $SERVICE2_PID)"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "Stopping services..."
    kill $AUTH_PID $SERVICE1_PID $SERVICE2_PID 2>/dev/null
    echo "All services stopped"
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup SIGINT SIGTERM

# Wait for user interrupt
wait