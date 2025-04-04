#include <windows.h>

#include <stdio.h>


extern int emInit();

extern HWND emCreateWindow(const char* title, int width, int height, int x, int y);

extern void emDestroyWindow();

extern void emTerminate();


int main() {

    if (!emInit()) printf("not init");

   

    HWND hwnd = emCreateWindow("EMBER Window", 800, 600, 100, 100);


    if (hwnd == NULL) {

        fprintf(stderr, "Failed to create window.\n");

        emTerminate();

        return 1;

    }


    MSG msg;

    while (GetMessageA(&msg, NULL, 0, 0)) {

        TranslateMessage(&msg);

        DispatchMessageA(&msg);

    }


    emDestroyWindow();

    emTerminate();


    return 0;

} 