#include <jni.h>
#include <android/native_activity.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <iostream>
#include <fstream>
#include <stdio.h>
#include <sstream>
#include <vector>
#include <pthread.h>
#include <codecvt>
#include <chrono>
#include <unordered_map>
#include <vector>
#include <queue>
#include "ImGui/imgui_internal.h"
#include "ImGui/imgui.h"
#include "ImGui/backends/imgui_impl_android.h"
#include "ImGui/backends/imgui_impl_opengl3.h"
#include <EGL/egl.h>
#include <GLES3/gl3.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include <sys/system_properties.h>
#include <string>
#include "ImGui/FONTS/DEFAULT.h"
#include <Includes/Utils.h>
#include <Includes/Dobby/dobby.h>
#include "KittyMemory/MemoryPatch.h"

#include "ImGui/Verdana.h"

#include "includes/Dobby/dobby.h"
#include "Includes/obfuscate.h"
#include "Includes/Utils.h"
#include "Includes/ByNameModding.h"
uintptr_t G_IL2CPP;
int screenWidth;
int screenHeight;
bool g_Initialized = false;
ImGuiWindow* g_window = NULL;
#include <Substrate/SubstrateHook.h>
#include <Substrate/CydiaSubstrate.h>
#include "Unity/Vector3.h"
#include "And64InlineHook/And64InlineHook.hpp"

#include "monostring.h"

#include <dlfcn.h>
#include <android/log.h>
#include <cmath>
#include <iostream>
#include "Includes/msg.h"
#include <dlfcn.h>
#include <string>
#include "ResetCD/ResetCD.h"

const char* MineLib = OBFUSCATE("libGLESv2.so");
static bool enableRainbow = false, enableRainbowWall = false;
static bool enableResetCD = false;
const char* Chams[] = {
    "OFF",
    "Default",
    "Shading",
    "Wireframe",
    "Outline",
    "Visibility Check Outline",
    "Visibility Check Shading",
    "Visibility Check Shading + Outline"
};

#include "RGB.h"
#include "Chams.h"

bool show_window;
extern "C" {

    JNIEXPORT void JNICALL Java_com_mycompany_application_GLES3JNIView_init(JNIEnv* env, jclass cls);
    JNIEXPORT void JNICALL Java_com_mycompany_application_GLES3JNIView_resize(JNIEnv* env, jobject obj, jint width, jint height);
    JNIEXPORT void JNICALL Java_com_mycompany_application_GLES3JNIView_step(JNIEnv* env, jobject obj);
    JNIEXPORT void JNICALL Java_com_mycompany_application_GLES3JNIView_imgui_Shutdown(JNIEnv* env, jobject obj);
    JNIEXPORT void JNICALL Java_com_mycompany_application_GLES3JNIView_MotionEventClick(JNIEnv* env, jobject obj,jboolean down,jfloat PosX,jfloat PosY);
    JNIEXPORT jstring JNICALL Java_com_mycompany_application_GLES3JNIView_getWindowRect(JNIEnv *env, jobject thiz);
    JNIEXPORT void JNICALL Java_com_mycompany_application_GLES3JNIView_real(JNIEnv* env, jobject obj, jint width, jint height);

};

void GreenStyle() // Imgui Theme
{
    ImGuiStyle &style = ImGui::GetStyle();

      // Colors
    ImColor darkBg = ImColor(0, 0, 0, 225);        // Darker background with transparency
    ImColor darkGreen = ImColor(225, 0, 0, 255);   // Darker green for some accents
    ImColor brightGreen = ImColor(255, 200, 0, 255); // Brighter green for highlights
    ImColor black = ImColor(0, 0, 0, 255);
    ImColor white = ImColor(255, 255, 255, 255);
    ImColor transparent = ImColor(0, 0, 0, 0);

    // Spacing and sizing
    style.WindowPadding = ImVec2(10.0f, 10.0f);
    style.FramePadding = ImVec2(5.0f, 5.0f);
    style.ItemSpacing = ImVec2(10.0f, 5.0f);
    style.ItemInnerSpacing = ImVec2(5.0f, 5.0f);
    style.TouchExtraPadding = ImVec2(0.0f, 0.0f);
    style.IndentSpacing = 25.0f;
    style.ScrollbarSize = 15.0f;

    // Rounding
    style.WindowRounding = 0.0f;
    style.ChildRounding = 0.0f;
    style.FrameRounding = 0.0f;
    style.PopupRounding = 0.0f;
    style.ScrollbarRounding = 0.0f;
    style.GrabRounding = 0.0f;
    style.TabRounding = 0.0f;

    // Borders
    style.WindowBorderSize = 1.0f;
    style.ChildBorderSize = 1.0f;
    style.PopupBorderSize = 1.0f;
    style.FrameBorderSize = 1.0f;
    style.TabBorderSize = 0.0f;

    // Set colors to match the screenshot
    style.Colors[ImGuiCol_Text] = white;
    style.Colors[ImGuiCol_TextDisabled] = ImColor(128, 128, 128, 255);

    // Window backgrounds
    style.Colors[ImGuiCol_WindowBg] = darkBg;
    style.Colors[ImGuiCol_ChildBg] = darkBg;
    style.Colors[ImGuiCol_PopupBg] = darkBg;

    // Borders
    style.Colors[ImGuiCol_Border] = brightGreen;
    style.Colors[ImGuiCol_BorderShadow] = transparent;

    // Frame backgrounds (for widgets)
    style.Colors[ImGuiCol_FrameBg] = black;
    style.Colors[ImGuiCol_FrameBgHovered] = black;
    style.Colors[ImGuiCol_FrameBgActive] = black;

    // Title bar
    style.Colors[ImGuiCol_TitleBg] = darkBg;
    style.Colors[ImGuiCol_TitleBgActive] = darkBg;
    style.Colors[ImGuiCol_TitleBgCollapsed] = darkBg;

    // Menu bar
    style.Colors[ImGuiCol_MenuBarBg] = darkBg;

    // Scrollbar
    style.Colors[ImGuiCol_ScrollbarBg] = darkBg;
    style.Colors[ImGuiCol_ScrollbarGrab] = brightGreen;
    style.Colors[ImGuiCol_ScrollbarGrabHovered] = brightGreen;
    style.Colors[ImGuiCol_ScrollbarGrabActive] = brightGreen;

    // Widgets
    style.Colors[ImGuiCol_CheckMark] = brightGreen;
    style.Colors[ImGuiCol_SliderGrab] = brightGreen;
    style.Colors[ImGuiCol_SliderGrabActive] = brightGreen;

    // Buttons
    style.Colors[ImGuiCol_Button] = black;
    style.Colors[ImGuiCol_ButtonHovered] = darkGreen;
    style.Colors[ImGuiCol_ButtonActive] = brightGreen;

    // Headers (for collapsing headers, tree nodes)
    style.Colors[ImGuiCol_Header] = darkGreen;
    style.Colors[ImGuiCol_HeaderHovered] = darkGreen;
    style.Colors[ImGuiCol_HeaderActive] = brightGreen;

    // Separator
    style.Colors[ImGuiCol_Separator] = brightGreen;
    style.Colors[ImGuiCol_SeparatorHovered] = brightGreen;
    style.Colors[ImGuiCol_SeparatorActive] = brightGreen;

    // Tabs
    style.Colors[ImGuiCol_Tab] = darkGreen;
    style.Colors[ImGuiCol_TabHovered] = brightGreen;
    style.Colors[ImGuiCol_TabActive] = brightGreen;
    style.Colors[ImGuiCol_TabUnfocused] = darkGreen;
    style.Colors[ImGuiCol_TabUnfocusedActive] = darkGreen;

    // Plot
    style.Colors[ImGuiCol_PlotLines] = brightGreen;
    style.Colors[ImGuiCol_PlotLinesHovered] = brightGreen;
    style.Colors[ImGuiCol_PlotHistogram] = brightGreen;
    style.Colors[ImGuiCol_PlotHistogramHovered] = brightGreen;

    // Table
    style.Colors[ImGuiCol_TableHeaderBg] = darkGreen;
    style.Colors[ImGuiCol_TableBorderStrong] = brightGreen;
    style.Colors[ImGuiCol_TableBorderLight] = darkGreen;
    style.Colors[ImGuiCol_TableRowBg] = transparent;
    style.Colors[ImGuiCol_TableRowBgAlt] = ImColor(0, 0, 0, 50);

    // Miscellaneous
    style.Colors[ImGuiCol_TextSelectedBg] = darkGreen;
    style.Colors[ImGuiCol_NavHighlight] = brightGreen;
    style.Colors[ImGuiCol_NavWindowingHighlight] = brightGreen;
    style.Colors[ImGuiCol_NavWindowingDimBg] = ImColor(0, 0, 0, 180);
    style.Colors[ImGuiCol_ModalWindowDimBg] = ImColor(0, 0, 0, 180);
}


/*###################*/
// Esp Codes start

bool esp = false;
ImVec4 espLineColor = ImVec4(0.0f, 1.0f, 0.0f, 1.0f);
static float espMaxDistance = 999.0f; // Default max distance
static float linePositionX = 0.5f; // 0.5 = middle of screen
static float linePositionY = 1.0f; // 1.0 = bottom of screen
static float hue = 0.0f;
static bool autoChangeColor = true;


std::vector<Vector3> espPoints;
void (*setpitchyaw)(float, float);
Vector3 (*WorldToScreenPoint)(void *instance, Vector3);
Vector3 (*get_position)(void *instance);
void *(*get_main)();
void *(*get_transform)(void *instance);
void (*old_Player_update)(void *player);
void Player_update(void* player) {
    if (player) {
        Vector3 pos = get_position(get_transform(player));
        Vector3 screen = WorldToScreenPoint(get_main(), {pos.x, pos.y, pos.z});

        if (screen.z >= 1.0f) {
            screen.y = screenHeight - screen.y;
            espPoints.push_back(screen);
        }
    }
    old_Player_update(player);
}

JNIEXPORT void JNICALL
Java_com_mycompany_application_GLES3JNIView_init(JNIEnv* env, jclass cls) {

    //SetUpImGuiContext
    if(!g_Initialized) {
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO();

    int screenWidth = io.DisplaySize.x;
    int screenHeight = io.DisplaySize.y;

    ImGui_ImplOpenGL3_Init("#version 100");
    ImGui::GetStyle().ScaleAllSizes(3.0f);

    GreenStyle();

    ImGuiStyle* style = &ImGui::GetStyle();
    style->WindowRounding = 12.0f;
    style->FrameRounding = 12.0f;
    style->WindowTitleAlign = ImVec2(0.5f, 0.5f);
	style->GrabRounding = 12.f;


    io.Fonts->AddFontFromMemoryTTF(Verdana, 30, 30.0f);

    g_Initialized = true;
    }
    return;
}

JNIEXPORT void JNICALL
Java_com_mycompany_application_GLES3JNIView_resize(JNIEnv* env, jobject obj, jint width, jint height) {
    if (g_Initialized) {
    screenWidth = (int) width;
    screenHeight = (int) height;
    ImGuiIO &io = ImGui::GetIO();
    io.IniFilename = NULL;
    ImGui::GetIO().DisplaySize = ImVec2((float)width, (float)height);
    }
    return;
}


// This code is for Imgui Menu Background Style
void RenderBackgroundAnimation(ImDrawList* drawList, const ImVec2& windowPos, const ImVec2& windowSize)
{
    static float time = 0.0f;
    time += ImGui::GetIO().DeltaTime * 0.4f; // Control animation speed

    // Get window bounds
    ImVec2 topLeft = windowPos;
    ImVec2 bottomRight = ImVec2(windowPos.x + windowSize.x, windowPos.y + windowSize.y);

    // Grid animation parameters
    const float gridSpacing = 40.0f;
    const float gridThickness = 1.0f;
    const float gridAlpha = 0.15f;

    // Create grid pattern
    for (float x = fmodf(topLeft.x - time * 20.0f, gridSpacing); x < bottomRight.x; x += gridSpacing)
    {
        float alpha = gridAlpha * (0.8f + 0.2f * sinf(time + x * 0.01f));
        drawList->AddLine(
            ImVec2(x, topLeft.y),
            ImVec2(x, bottomRight.y),
            ImGui::ColorConvertFloat4ToU32(ImVec4(0.0f, 1.0f, 0.0f, alpha)),
            gridThickness
        );
    }

    for (float y = fmodf(topLeft.y - time * 20.0f, gridSpacing); y < bottomRight.y; y += gridSpacing)
    {
        float alpha = gridAlpha * (0.8f + 0.2f * sinf(time + y * 0.01f));
        drawList->AddLine(
            ImVec2(topLeft.x, y),
            ImVec2(bottomRight.x, y),
            ImGui::ColorConvertFloat4ToU32(ImVec4(0.0f, 1.0f, 0.0f, alpha)),
            gridThickness
        );
    }

    // Add animated border glow
    const float borderGlowThickness = 2.0f;
    const float borderGlowIntensity = 0.5f + 0.5f * sinf(time * 2.0f);
    ImU32 borderGlowColor = ImGui::ColorConvertFloat4ToU32(ImVec4(0.0f, 1.0f, 0.0f, 0.7f * borderGlowIntensity));

    drawList->AddRect(
        ImVec2(topLeft.x - 1.0f, topLeft.y - 1.0f),
        ImVec2(bottomRight.x + 1.0f, bottomRight.y + 1.0f),
        borderGlowColor,
        0.0f,
        ImDrawFlags_None,
        borderGlowThickness
    );

    // Add circuit-like pattern in corners
    const int numCircuitLines = 3;
    const float circuitLength = 40.0f;
    const float circuitThickness = 1.5f;
    const float cornerOffset = 15.0f;

    // Top-left corner circuits
    ImVec2 tlCorner = ImVec2(topLeft.x + cornerOffset, topLeft.y + cornerOffset);
    for (int i = 0; i < numCircuitLines; i++) {
        float offset = i * 8.0f;
        float alpha = 0.6f + 0.4f * sinf(time * 3.0f + i * 0.5f);
        ImU32 circuitColor = ImGui::ColorConvertFloat4ToU32(ImVec4(0.0f, 1.0f, 0.0f, alpha));

        // Horizontal line
        drawList->AddLine(
            tlCorner,
            ImVec2(tlCorner.x + circuitLength - offset, tlCorner.y),
            circuitColor,
            circuitThickness
        );

        // Vertical line
        drawList->AddLine(
            tlCorner,
            ImVec2(tlCorner.x, tlCorner.y + circuitLength - offset),
            circuitColor,
            circuitThickness
        );
    }

    // Bottom-right corner circuits
    ImVec2 brCorner = ImVec2(bottomRight.x - cornerOffset, bottomRight.y - cornerOffset);
    for (int i = 0; i < numCircuitLines; i++) {
        float offset = i * 8.0f;
        float alpha = 0.6f + 0.4f * sinf(time * 3.0f + i * 0.5f + 3.14f);
        ImU32 circuitColor = ImGui::ColorConvertFloat4ToU32(ImVec4(0.0f, 1.0f, 0.0f, alpha));

        // Horizontal line
        drawList->AddLine(
            brCorner,
            ImVec2(brCorner.x - circuitLength + offset, brCorner.y),
            circuitColor,
            circuitThickness
        );

        // Vertical line
        drawList->AddLine(
            brCorner,
            ImVec2(brCorner.x, brCorner.y - circuitLength + offset),
            circuitColor,
            circuitThickness
        );
    }

    // Create floating particles
    const int numParticles = 15;
    static float particleOffsets[numParticles][4] = {0}; // x, y, speed, size
    static bool initialized = false;

    if (!initialized) {
        for (int i = 0; i < numParticles; i++) {
            particleOffsets[i][0] = static_cast<float>(rand()) / RAND_MAX * windowSize.x;
            particleOffsets[i][1] = static_cast<float>(rand()) / RAND_MAX * windowSize.y;
            particleOffsets[i][2] = 0.2f + static_cast<float>(rand()) / RAND_MAX * 0.5f; // Speed
            particleOffsets[i][3] = 1.0f + static_cast<float>(rand()) / RAND_MAX * 2.0f; // Size
        }
        initialized = true;
    }

    // Draw and update particles
    for (int i = 0; i < numParticles; i++) {
        // Update position
        particleOffsets[i][1] -= particleOffsets[i][2]; // Move upwards

        // Reset if out of bounds
        if (particleOffsets[i][1] < 0) {
            particleOffsets[i][0] = static_cast<float>(rand()) / RAND_MAX * windowSize.x;
            particleOffsets[i][1] = windowSize.y;
        }

        // Calculate position and alpha
        ImVec2 particlePos = ImVec2(
            topLeft.x + particleOffsets[i][0],
            topLeft.y + particleOffsets[i][1]
        );

        float particleAlpha = 0.3f + 0.3f * sinf(time * 2.0f + i * 0.3f);
        float particleSize = particleOffsets[i][3] * (0.8f + 0.4f * sinf(time * 3.0f + i));

        ImU32 particleColor = ImGui::ColorConvertFloat4ToU32(ImVec4(0.0f, 1.0f, 0.0f, particleAlpha));
        drawList->AddCircleFilled(particlePos, particleSize, particleColor);
    }
}

void BeginDrawWithAnimation() {
    ImGuiIO &io = ImGui::GetIO();

    ImVec2 windowSize = ImVec2(screenWidth * 0.40, screenHeight * 0.70);
    ImGui::SetNextWindowSize(windowSize, ImGuiCond_Once);

    ImVec2 screenBottom(screenWidth * linePositionX, screenHeight * linePositionY);

    ImGui::Begin("<<<----::: BROKEN MAD BOY :::---->>>");
    g_window = ImGui::GetCurrentWindow();

    // Apply the background animation to the current window
    RenderBackgroundAnimation(ImGui::GetWindowDrawList(), g_window->Pos, g_window->Size);

    if (autoChangeColor) {
        hue += 0.0005f;
        if (hue >= 1.0f) hue = 0.0f;
        ImGui::ColorConvertHSVtoRGB(hue, 1.0f, 1.0f,
            espLineColor.x, espLineColor.y, espLineColor.z);
        espLineColor.w = 1.0f;
    }

    static int currentTab = 0;

    // Custom implementation for tabs that fill the window width
    const char* tabs[] = { "Chams Menu", "Memory Hack", "MY LIFE INFO" };
    const int numTabs = IM_ARRAYSIZE(tabs);

    // Calculate available width and tab size
    float windowWidth = ImGui::GetWindowContentRegionWidth();
    float tabWidth = windowWidth / numTabs;

    // Add some styling for the tabs
    ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 0);
    ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(0, 0));

    // Create the tabs that stretch to fill the width
    for (int i = 0; i < numTabs; i++) {
        if (i > 0) ImGui::SameLine(0, 0);

        // Set width for each button to fill the space evenly
        ImGui::PushStyleColor(ImGuiCol_Button,
            (currentTab == i) ? ImGui::GetColorU32(ImGuiCol_TabActive) : ImGui::GetColorU32(ImGuiCol_TabUnfocused));
        ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImGui::GetColorU32(ImGuiCol_TabHovered));
        ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImGui::GetColorU32(ImGuiCol_TabActive));

        if (ImGui::Button(tabs[i], ImVec2(tabWidth, 0))) {
            currentTab = i;
        }

        ImGui::PopStyleColor(3);
    }

    ImGui::PopStyleVar(2);

    // Add a separator line
    ImGui::Separator();

    // Tab content based on selected tab
    switch (currentTab) {


        case 0: // Chams Menu
            ImGui::PushItemWidth(400);
            ImGui::Text("Chams Type BY MAD BOY");
            ImGui::Combo("##Chams Type", &chamsint, Chams, IM_ARRAYSIZE(Chams));

            if (chamsint > 1) {
                ImGui::Separator();
                ImGui::PushItemWidth(45);
                ImGui::Text("Visible Color");
                ImGui::ColorEdit3("##VisibleColor", (float*)&visibleColor);
                ImGui::SameLine();
                ImGui::Checkbox("RGB##Visible", &enableRainbow);
            }
			if (chamsint == 6 || chamsint == 7) {
                ImGui::Separator();
                ImGui::Text("In Wall Color");
                ImGui::ColorEdit3("##InWallColor", (float*)&inWallColor);
                ImGui::SameLine();
                ImGui::Checkbox("RGB##Wall", &enableRainbowWall);
            }
			for (const std::string& shader : shaders) {
                ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1, 1, 1, 1));
                if (mineShader == shader) ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0, 1, 0, 1));
                ImGui::PushID(shader.c_str());
                ImGui::Text("-> %s", shader.c_str());
                ImGui::SameLine();
                if (ImGui::Button("<-::Set")) {
                    mineShader = shader;
                }
                ImGui::Separator();
                ImGui::PopID();
            }
            ImGui::PopStyleColor();

            break;

        case 1: // Memory Hack
            ImGui::Text("Memory Scan Feature (Game Guardian Style)");
            ImGui::Separator();
            ImGui::Text("Trigger GG Recipe: 3;81;20:9 -> Edit 25");
            if (ImGui::Button("Trigger Reset CD Once")) {
                ResetCD::Run();
            }
            ImGui::Separator();
            ImGui::Checkbox("Auto Freeze Reset CD (Continuous)", &enableResetCD);
            if (enableResetCD) {
                ResetCD::Loop(enableResetCD);
            }
            break;

        case 2: // About Me
            ImGui::Text("MAD BOY LOVE ONLY NUSRAT");
            break;
    }

    // ESP Drawing Code (unchanged)
    ImU32 espLineColorU32 = ImGui::ColorConvertFloat4ToU32(espLineColor);
    ImVec4 espLineColorDark = ImVec4(espLineColor.x * 0.7f, espLineColor.y * 0.7f,
                                     espLineColor.z * 0.7f, espLineColor.w);
    ImU32 espLineColorDarkU32 = ImGui::ColorConvertFloat4ToU32(espLineColorDark);

    static float animTime = 0.0f;
    animTime += ImGui::GetIO().DeltaTime;

    for (const auto& point : espPoints) {
        if (!esp) continue;

        float dx = point.x - screenBottom.x;
        float dy = point.y - screenBottom.y;
        float distance = sqrtf(dx * dx + dy * dy);

        if (distance > espMaxDistance)
            continue;

        ImGui::GetBackgroundDrawList()->AddLine(
            ImVec2(screenBottom.x + 2, screenBottom.y + 2),
            ImVec2(point.x + 2, point.y + 2),
            espLineColorDarkU32,
            2.5f
        );

        ImGui::GetBackgroundDrawList()->AddLine(
            screenBottom,
            ImVec2(point.x, point.y),
            espLineColorU32,
            2.0f
        );

        float pulseSize = 18.0f + 3.0f * sinf(animTime);
        ImVec4 glowColor = ImVec4(espLineColor.x, espLineColor.y, espLineColor.z, 0.2f);
        ImU32 glowColorU32 = ImGui::ColorConvertFloat4ToU32(glowColor);

        ImGui::GetBackgroundDrawList()->AddCircleFilled(
            ImVec2(point.x, point.y),
            pulseSize + 4.0f,
            glowColorU32,
            16
        );

        ImGui::GetBackgroundDrawList()->AddCircle(
            ImVec2(point.x + 2, point.y + 2),
            pulseSize,
            espLineColorDarkU32,
            16,
            1.5f
        );

        ImGui::GetBackgroundDrawList()->AddCircle(
            ImVec2(point.x, point.y),
            pulseSize,
            espLineColorU32,
            16,
            1.5f
        );

        float crossSize = 7.0f;
        ImGui::GetBackgroundDrawList()->AddLine(
            ImVec2(point.x - crossSize, point.y),
            ImVec2(point.x + crossSize, point.y),
            espLineColorU32,
            1.5f
        );
        ImGui::GetBackgroundDrawList()->AddLine(
            ImVec2(point.x, point.y - crossSize),
            ImVec2(point.x, point.y + crossSize),
            espLineColorU32,
            1.5f
        );
    }
    espPoints.clear();
	if (enableRainbow) {
        visibleColor.x = redd / 255.0f;
        visibleColor.y = greenn / 255.0f;
        visibleColor.z = bluee / 255.0f;
    }
    if (enableRainbowWall) {
        inWallColor.x = redd / 255.0f;
        inWallColor.y = greenn / 255.0f;
        inWallColor.z = bluee / 255.0f;
    }
    performRGBChange();
}









void *hack_thread(void *) {
    ProcMap mineMap;
    do {
        mineMap = KittyMemory::getLibraryMap(MineLib);
		handle = NULL;
		handle = dlopen(OBFUSCATE("libGLESv2.so"), RTLD_LAZY);
    } while (!mineMap.isValid());

	RenderHook();

    ProcMap il2cppMap;
    do {
        sleep(1);
    } while (!isLibraryLoaded(libName));


	//🫵🏻🫵🏻👇👇 SET AND CHANGE YOUR GAME LIB FILE NAME 👇👇🫵🏻🫵🏻

    G_IL2CPP = findLibrary("libcombatsoldier.so");/////////------------------------
    sleep(5);

    return NULL;
}
   //////////)//////////////🫵🏻🫵🏻🫵🏻☝️☝️☝️☝️☝️☝️🫵🏻🫵🏻🫵🏻🫵🏻////////////////


JNIEXPORT void JNICALL
Java_com_mycompany_application_GLES3JNIView_step(JNIEnv* env, jobject obj) {
    if (g_Initialized) {
    ImGuiIO& io = ImGui::GetIO();

    ImGui_ImplOpenGL3_NewFrame();
    ImGui::NewFrame();

    BeginDrawWithAnimation();
    RenderNotifications();


    ImGui::EndFrame();

    ImGui::Render();
    glClear(GL_COLOR_BUFFER_BIT);
    ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
    }
}

JNIEXPORT void JNICALL Java_com_mycompany_application_GLES3JNIView_imgui_Shutdown(JNIEnv* env, jobject obj){
    if (!g_Initialized)
        return;
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplAndroid_Shutdown();
    ImGui::DestroyContext();
    g_Initialized=false;
}

JNIEXPORT void JNICALL Java_com_mycompany_application_GLES3JNIView_MotionEventClick(JNIEnv* env, jobject obj,jboolean down,jfloat PosX,jfloat PosY){
    if (g_Initialized) {
    ImGuiIO & io = ImGui::GetIO();
    io.MouseDown[0] = down;
    io.MousePos = ImVec2(PosX,PosY);
    }
}

JNIEXPORT jstring JNICALL Java_com_mycompany_application_GLES3JNIView_getWindowRect(JNIEnv *env, jobject thiz) {
    if (g_Initialized) {
    char result[512]="0|0|0|0";
    if(g_window){
        sprintf(result,"%d|%d|%d|%d",(int)g_window->Pos.x,(int)g_window->Pos.y,(int)g_window->Size.x,(int)g_window->Size.y);
    }
    return env->NewStringUTF(result);
    }
}

JNIEXPORT jint JNICALL
JNI_OnLoad(JavaVM *vm, void *reserved) {
    JNIEnv *globalEnv;
    vm->GetEnv((void **) &globalEnv, JNI_VERSION_1_6);

   pthread_t gameThread = NULL;
    if (gameThread = pthread_self()) {
        pthread_create(&gameThread, NULL, hack_thread, NULL);
    }

    return JNI_VERSION_1_6;
}

JNIEXPORT void JNICALL
JNI_OnUnload(JavaVM *vm, void *reserved) {}
