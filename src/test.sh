EXPECTED = "Hello, Admin!"

OUTPUT = $(node -e "console.log(require('./app.js')('Admin'))")

echo "Output: $OUTPUT"
echo "Expected: $EXPECTED"

if [ "$OUTPUT" == "$EXPECTED" ]; then
    echo "Test passed"
    exit 0
else
    echo "Test failed"
    exit 1
fi