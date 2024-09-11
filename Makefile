CC = emcc
BUILD_DIR = ./build/wasm
SOURCE = ./src/main.cpp
TARGET = $(BUILD_DIR)/vosmm.js

# Compilation flags
CFLAGS = -s WASM=1 -s NO_EXIT_RUNTIME=1 \
         -s "EXPORTED_RUNTIME_METHODS=['ccall','cwrap']" \
         -s "EXPORTED_FUNCTIONS=['_malloc', '_free', '_main']" -g

# Platform-specific commands
RM = rm -rf
MKDIR = mkdir -p
COPY = cp -r

ifeq ($(OS),Windows_NT)
    RM = if exist "$(1)" del /f /q "$(1)"
    MKDIR = if not exist "$(1)" mkdir "$(1)"
    COPY = xcopy "$(1)/*" "$(2)" /e /i /q /y /f
endif

# Default target
all: $(TARGET) copy_files

# Target to compile the source code into wasm
$(TARGET): $(SOURCE) | $(BUILD_DIR)
	$(CC) $(SOURCE) -o $(TARGET) $(CFLAGS)

# Ensure the build directory exists
$(BUILD_DIR):
	$(call MKDIR,$(BUILD_DIR))

# Copy client files to the build folder
copy_files:
	$(call MKDIR,./build)
	$(call COPY,./src/client,./build)

# Clean build directory
clean:
	$(call RM,./build)

.PHONY: all clean copy_files
