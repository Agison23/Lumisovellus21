#!/bin/bash

echo "Running mobile-snowledge..."

echo "Running mobile backend test..."
cd Server/back_end
python server.py
python test.udpServer.py
cd ../..

echo "Running mobile frontend test..."
cd mobile_app
flutter test
cd ..

echo "Finished running mobile-snowledge tests."