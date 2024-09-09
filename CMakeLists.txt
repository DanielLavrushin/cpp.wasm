cmake_minimum_required(VERSION 3.15) # Set the minimum version of CMake

project(WasmModule)

# Set the path to the Emscripten toolchain file
set(CMAKE_TOOLCHAIN_FILE $ENV{EMSDK}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)

# Add your source files
add_executable(vosmm ./src/main.cpp)

# Specify the output .js and .wasm
set_target_properties(vosmm PROPERTIES OUTPUT_NAME "vosmm" SUFFIX ".js")

# Add the specific Emscripten flags
set_target_properties(vosmm PROPERTIES COMPILE_FLAGS "-s WASM=1")
set_target_properties(vosmm PROPERTIES LINK_FLAGS "-s WASM=1 -s 'EXPORTED_RUNTIME_METHODS=[\"ccall\",\"cwrap\"]'")
