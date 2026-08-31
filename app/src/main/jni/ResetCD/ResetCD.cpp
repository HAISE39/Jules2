#include "ResetCD.h"
#include <android/log.h>

using namespace kFox;

#define TAG "ResetCD"

namespace ResetCD {

    // Casting helper agar string literal const char* bisa diteruskan ke API
    // yang bertipe char* (sesuai ScanEngine.hpp).
    static char *S(const char *s) { return const_cast<char *>(s); }

    void Run() {
        // 1. Batasi hasil agar tidak membebani memori (opsional)
        SetMaxResult(4096);

        // 2. Pilih region scan: semua data game ada di java_heap
        SetSearchRange(SCAN_REGION);

        // 3. Search nilai dasar "3"
        MemorySearch(S(SEARCH_VALUE), VALUE_TYPE);

        // 4. Refine: cek base+4 == 81
        MemoryOffset(S(REFINE1_VALUE), REFINE1_OFFSET, VALUE_TYPE);

        // 5. Refine: cek base+9 == 20
        MemoryOffset(S(REFINE2_VALUE), REFINE2_OFFSET, VALUE_TYPE);

        // 6. Edit: tulis 25 di base+0 (reset CD)
        MemoryWrite(S(WRITE_VALUE), WRITE_OFFSET, VALUE_TYPE);

        // 7. Bersihkan hasil untuk siklus berikutnya
        ClearResult();

        __android_log_print(ANDROID_LOG_INFO, TAG,
                            "Reset CD selesai: search=%s refine+%ld=%s,+%ld=%s write %s @+%ld",
                            SEARCH_VALUE, REFINE1_OFFSET, REFINE1_VALUE,
                            REFINE2_OFFSET, REFINE2_VALUE, WRITE_VALUE, WRITE_OFFSET);
    }

    void Loop(bool enabled) {
        if (enabled) Run();
    }

}
