CC=emcc
CFLAGS=-s WASM=1 -s "EXPORTED_RUNTIME_METHODS=['ccall','cwrap']"
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
