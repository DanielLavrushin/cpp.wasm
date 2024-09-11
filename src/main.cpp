#include <iostream>
#include <emscripten.h>

using std::cin;
using std::cout;

int main()
{
    auto txt = "VideoOS Merge Media WASM Module Loaded";
    cout << txt << "\n";
    return 0;
}

extern "C"
{
    int EMSCRIPTEN_KEEPALIVE processFile(unsigned char *data, int size)
    {
        int sum = 0;
        for (int i = 0; i < size; i++)
        {
            sum += data[i];
        }
        return sum;
    }
}
