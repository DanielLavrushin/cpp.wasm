#include <emscripten.h>
#include <iostream>
#include <string>
#include <vector>

// FFmpeg headers
extern "C" {
#include <libavformat/avformat.h>
}

using namespace std;

int main() {
  auto txt = "VideoOS Merge Media WASM Module Loaded";
  cout << txt << "\n";
  string str = "lalala";
  vector<string> arr;

  arr.push_back("janna");

  return 0;
}

extern "C" {

// Your WebAssembly exposed function to process the file
int EMSCRIPTEN_KEEPALIVE processFile(unsigned char *data, int size) {
  // Initialize FFmpeg format context
  AVFormatContext *fmt_ctx = avformat_alloc_context();
  if (!fmt_ctx) {
    cout << "Failed to allocate format context.\n";
    return -1;
  }

  // Allocate a buffer for probing
  unsigned char *buffer = (unsigned char *)av_malloc(4096);
  if (!buffer) {
    cout << "Failed to allocate buffer.\n";
    return -1;
  }

  // Set up AVIOContext for the buffer
  AVIOContext *avio_ctx = nullptr;
  const AVInputFormat *fmt = nullptr; // Pointer to const AVInputFormat

  // Probe input buffer to determine the format
  int ret = av_probe_input_buffer2(avio_ctx, &fmt, nullptr, nullptr, 0, 4096);
  if (ret < 0) {
    cout << "File format is not recognized.\n";
    av_free(buffer);
    return -1;
  }

  cout << "Media file probed successfully. Format: "
       << (fmt ? fmt->name : "unknown") << "\n";

  // Clean up FFmpeg structures
  av_free(buffer);
  avformat_close_input(&fmt_ctx);

  // Return the sum of the file bytes (or other metadata if needed)
  int sum = 0;
  for (int i = 0; i < size; i++) {
    sum += data[i];
  }

  return sum; // For demonstration, we're returning the sum of the bytes
}
}
