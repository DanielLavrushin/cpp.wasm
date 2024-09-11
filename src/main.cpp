#include <emscripten.h>
#include <iostream>
using std::cout;

int main()
{
    auto txt = "Hello, World!";
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
