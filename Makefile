CC = emcc
BUILD_DIR = ./build/wasm
SOURCE = ./src/main.cpp
TARGET = $(BUILD_DIR)/vosmm.js

# FFmpeg directories
FFMPEG_DIR = ./ffmpeg/ffmpeg
FFMPEG_BUILD_DIR = $(FFMPEG_DIR)/build
FFMPEG_INCLUDE_DIR = $(FFMPEG_BUILD_DIR)/include
FFMPEG_LIB_DIR = $(FFMPEG_BUILD_DIR)/lib

# FFmpeg libraries to link against
FFMPEG_LIBS = \
    $(FFMPEG_LIB_DIR)/libavcodec.a \
    $(FFMPEG_LIB_DIR)/libavformat.a \
    $(FFMPEG_LIB_DIR)/libavutil.a \
    $(FFMPEG_LIB_DIR)/libswscale.a 

# Compilation flags
CFLAGS = -s WASM=1 -s NO_EXIT_RUNTIME=1 \
         -s "EXPORTED_RUNTIME_METHODS=['ccall','cwrap']" \
         -s "EXPORTED_FUNCTIONS=['_malloc', '_free', '_main']" -g

# Platform-specific commands
RM = rm -rf
MKDIR = mkdir -p
COPY = cp -r

# Check if we are on Windows
ifeq ($(OS),Windows_NT)
    SHELL := cmd.exe
    RM = if exist "$(1)" rmdir "$(1)" /s /q
    MKDIR = if not exist "$(1)" mkdir "$(1)"
    COPY = xcopy "$(1)/*" "$(2)" /e /i /q /y /f
else
    # Assume a Unix-like system (Linux, macOS, etc.)
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        # Ubuntu or any other Linux
        RM = rm -rf $(1)
        MKDIR = mkdir -p $(1)
        COPY = cp -r $(1)/* $(2)
    endif
    ifeq ($(UNAME_S),Darwin)
        # macOS
        RM = rm -rf $(1)
        MKDIR = mkdir -p $(1)
        COPY = cp -r $(1)/* $(2)
    endif
endif

.PHONY: all clean copy_files ffmpeg-configure ffmpeg-build

# Default target
all: $(TARGET) copy_files

# Target to compile the source code into wasm
$(TARGET): $(SOURCE) | $(BUILD_DIR)
	$(CC) $(SOURCE) -o $(TARGET)  -I$(FFMPEG_INCLUDE_DIR) $(CFLAGS) $(FFMPEG_LIBS)

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

# FFmpeg configuration target
ffmpeg-configure:
	cd $(FFMPEG_DIR) && \
	emconfigure ./configure \
		--prefix=$(FFMPEG_BUILD_DIR) \
		--cc="emcc" \
		--ar="emar" \
		--ranlib="emranlib" \
		--target-os=none \
		--arch=x86_32 \
		--enable-cross-compile \
		--disable-x86asm \
		--disable-inline-asm \
		--disable-programs \
		--disable-doc \
		--disable-network \
		--disable-everything \
		--enable-decoder=h264 \
		--enable-parser=h264 \
		--enable-demuxer=mov \
		--enable-protocol=file \
		--enable-small

# FFmpeg build target
ffmpeg-build: ffmpeg-configure
	cd $(FFMPEG_DIR) && \
	emmake make -j$(shell nproc) && \
	emmake make install