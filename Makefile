CC=emcc
CFLAGS=-s WASM=1 -s NO_EXIT_RUNTIME=1 -s  "EXPORTED_RUNTIME_METHODS=['ccall','cwrap']" -s "EXPORTED_FUNCTIONS=['_malloc', '_free', '_main']" -g --no-entry --no-heap-copy -s "ALLOW_MEMORY_GROWTH=1"
TARGET=./build/wasm/vosmm.js
SOURCE=./src/main.cpp

all: $(TARGET) copy_files

$(TARGET): $(SOURCE)
	if exist ".\build" rd /s /q ".\build"
	mkdir .\build\wasm
	$(CC) $(SOURCE) -o $(TARGET) $(CFLAGS)
	
copy_files:
	if not exist ".\build" mkdir ".\build"
	xcopy .\src\client .\build\ /f /i /e /q /y

clean:
	if exist "$(TARGET)" del /f /q "$(TARGET)"
	if exist ".\build\client" rd /s /q ".\build\client"
