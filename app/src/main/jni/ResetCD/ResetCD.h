#pragma once

#include "foxcheats/include/ScanEngine.hpp"

namespace ResetCD {

    /*
     * Konfigurasi recipe (Game Guardian):
     *
     *   Group search : 3;81;20:9
     *   Refine       : 3
     *   Edit         : 25
     *
     * Arti pola di memori (region JAVA_HEAP), semua tipe DWORD:
     *   base + 0  == 3     (nilai dasar = status cooldown)
     *   base + 4  == 81    (refine 1, offset default = ukuran DWORD)
     *   base + 9  == 20    (refine 2, offset 9 dari base sesuai ":9")
     *   lalu tulis base + 0 = 25  (reset CD: 3 -> 25)
     */
    static const char *SEARCH_VALUE = "3";
    static const char *REFINE1_VALUE = "81";
    static const long  REFINE1_OFFSET = 4;
    static const char *REFINE2_VALUE = "20";
    static const long  REFINE2_OFFSET = 9;
    static const char *WRITE_VALUE = "25";
    static const long  WRITE_OFFSET = 0;

    // Game tidak pakai library; semua data di memori java_heap
    static const RegionType SCAN_REGION = JAVA_HEAP;
    static const Type VALUE_TYPE = TYPE_DWORD;

    /*
     * Jalankan satu siklus penuh:
     * search -> refine 1 -> refine 2 -> write -> clear.
     * Panggil sekali saat toggle menyala.
     */
    void Run();

    /*
     * Versi loop: jalankan terus tiap frame selama enabled (untuk freeze/keep 25).
     */
    void Loop(bool enabled);

}
