#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Path to the aicm script
AICM_PATH="./aicm.sh"

# Expected version (read from package.json)
EXPECTED_VERSION="1.1.0"

echo "Running basic aicm tests..."

# Test 1: aicm list
echo -n "Test 1: aicm list... "
"$AICM_PATH" list > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}PASSED${NC}"
else
    echo -e "${RED}FAILED${NC}"
    exit 1
fi

# Test 2: aicm version
echo -n "Test 2: aicm version... "
VERSION_OUTPUT=$("$AICM_PATH" version)
if [[ "$VERSION_OUTPUT" == *"$EXPECTED_VERSION"* ]]; then
    echo -e "${GREEN}PASSED${NC}"
else
    echo -e "${RED}FAILED${NC}"
    echo "  Expected version to contain '$EXPECTED_VERSION', but got '$VERSION_OUTPUT'"
    exit 1
fi

# Test 3: aicm cleanup
echo -n "Test 3: aicm cleanup... "
"$AICM_PATH" cleanup > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}PASSED${NC}"
else
    echo -e "${RED}FAILED${NC}"
    exit 1
fi

echo -e "
All basic tests ${GREEN}PASSED${NC}"
