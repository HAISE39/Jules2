

// Field Offset Hooking Examples:

bool IsBoolExample1 = false;
bool IsIntExample1 = false;
bool IsFloatExample1 = false;
bool IsDoubleExample1 = false;



// Bool Field Offset Hooking Example:
void (*old_BoolExample1)(void *instance);
void BoolExample1(float *instance) {
	if (instance != NULL) {
		if (IsBoolExample1) {
			*(bool *) ((uint64_t) instance + 0x00) = true; // Or you can put return false;.
		}
	}
	return old_BoolExample1(instance);
}

// Int Field Offset Hooking Example:
void (*old_IntExample1)(void *instance);
void IntExample1(float *instance) {
	if (instance != NULL) {
		if (IsIntExample1) {
			*(int *) ((uint64_t) instance + 0x00) = 999999999; // Int Hook Value = 999,999,999
		}
	}
	return old_IntExample1(instance);
}

// Float Field Offset Hooking Example:
void (*old_FloatExample1)(void *instance);
void FloatExample1(float *instance) {
	if (instance != NULL) {
		if (IsFloatExample1) {
			*(float *) ((uint64_t) instance + 0x00) = 999999999.0f; // Float Hook Value = 999,999,999
		}
	}
	return old_FloatExample1(instance);
}

// Double Field Offset Hooking Example:
void (*old_DoubleExample1)(void *instance);
void DoubleExample1(float *instance) {
	if (instance != NULL) {
		if (IsDoubleExample1) {
			*(double *) ((uint64_t) instance + 0x00) = 999999999.0; // Double Hook Value = 999,999,999
		}
	}
	return old_DoubleExample1(instance);
}

// Multi Field Offset Hooking Example:

bool IsMultiHookExample1 = false;



void (*old_MultiHookExample1)(void *instance);
void MultiHookExample1(void *instance){
	if(instance != NULL){
		if (IsMultiHookExample1) {

			// Bool Field Offset Hooking Example:
			*(bool *)((uint64_t)instance + 0x00) = true; // Or you can put return false;.

			// Int Field Offset Hooking Example:
			*(int *)((uint64_t)instance + 0x00) = 999999999; // Int Hook Value = 999,999,999

			// Float Field Offset Hooking Example:
			*(float *)((uint64_t)instance + 0x00) = 999999999.0f; // Float Hook Value = 999,999,999

			// Double Field Offset Hooking Example:
			*(double *)((uint64_t)instance + 0x00) = 999999999.0; // Double Hook Value = 999,999,999

		}
	}
	return old_MultiHookExample1(instance);
}

// Method Offset Hooking Examples:

bool IsBoolExample2 = false;
bool IsIntExample2 = false;
bool IsFloatExample2 = false;
bool IsDoubleExample2 = false;



// Bool Method Offset Hooking Example:
bool (*old_BoolExample2)(void *instance);
bool BoolExample2(void *instance) {
	if (instance != NULL) {
		if (IsBoolExample2) {
			return true; // Or you can put return false;.
		}
	}
	return old_BoolExample2(instance);
}

// Int Method Offset Hooking Example:
int (*old_IntExample2)(void *instance);
int IntExample2(void *instance) {
	if (instance != NULL) {
		if (IsIntExample2) {
			return 999999999; // Int Hook Value = 999,999,999
		}
	}
	return old_IntExample2(instance);
}

// Float Method Offset Hooking Example:
float (*old_FloatExample2)(void *instance);
float FloatExample2(void *instance) {
	if (instance != NULL) {
		if (IsFloatExample2) {
			return 999999999.0f; // Float Hook Value = 999,999,999
		}
	}
	return old_FloatExample2(instance);
}

// Double Method Offset Hooking Example:
double (*old_DoubleExample2)(void *instance);
double DoubleExample2(void *instance) {
	if (instance != NULL) {
		if (IsDoubleExample2) {
			return 999999999.0; // Double Hook Value = 999,999,999
		}
	}
	return old_DoubleExample2(instance);
}

// Void Method Offset Hooking Examples ( With No Update Method Offset ):

bool IsBoolExample3;
int IsIntExample3;
float IsFloatExample3;
double IsDoubleExample3;



// Bool Void Method Offset Hooking Example:
void (*old_BoolExample3)(void *instance, bool value);
void BoolExample3(void *instance, bool value) {
	if (instance != NULL) {
		if (IsBoolExample3) {
			old_BoolExample3(instance, true); // Or you can put return false;.
			return;
		}
	}
	return old_BoolExample3(instance,value);
}

// Int Void Method Offset Hooking Example:
void (*old_IntExample3)(void *instance, int value);
void IntExample3(void *instance, int value) {
	if (instance != NULL) {
		if (IsIntExample3) {
			old_IntExample3(instance, 999999999); // Int Hook Value = 999,999,999
			return;
		}
	}
	return old_IntExample3(instance,value);
}

// Float Void Method Offset Hooking Example:
void (*old_FloatExample3)(void *instance, float value);
void FloatExample3(void *instance, float value) {
	if (instance != NULL) {
		if (IsFloatExample3) {
			old_FloatExample3(instance, 999999999.0f); // Float Hook Value = 999,999,999
			return;
		}
	}
	return old_FloatExample3(instance,value);
}

// Double Void Method Offset Hooking Example:
void (*old_DoubleExample3)(void *instance, double value);
void DoubleExample3(void *instance, double value) {
	if (instance != NULL) {
		if (IsDoubleExample3) {
			old_DoubleExample3(instance, 999999999.0); // Double Hook Value = 999,999,999
			return;
		}
	}
	return old_DoubleExample3(instance,value);
}

// Void Method Offset Hooking Examples ( With Update Method Offset ):

bool IsBoolExample4;
bool IsIntExample4;
bool IsFloatExample4;
bool IsDoubleExample4;



// Bool Void Method Offset Hooking Example:
void (*BoolHook1)(void *instance,bool value);
void (*old_BoolExample4)(void *instance);
void BoolExample4(void *instance) {
	if (instance != NULL) {
		if (IsBoolExample4) {
			BoolHook1(instance, true); // Or you can put return false;.
		}
	}
	return old_BoolExample4(instance);
}

// Int Void Method Offset Hooking Example:
void (*IntHook1)(void *instance,int value);
void (*old_IntExample4)(void *instance);
void IntExample4(void *instance) {
	if (instance != NULL) {
		if (IsIntExample4) {
			IntHook1(instance, 999999999); // Int Hook Value = 999,999,999
		}
	}
	return old_IntExample4(instance);
}

// Float Void Method Offset Hooking Example:
void (*FloatHook1)(void *instance,float value);
void (*old_FloatExample4)(void *instance);
void FloatExample4(void *instance) {
	if (instance != NULL) {
		if (IsFloatExample4) {
			FloatHook1(instance, 999999999.0f); // Float Hook Value = 999,999,999
		}
	}
	return old_FloatExample4(instance);
}

// Double Void Method Offset Hooking Example:
void (*DoubleHook1)(void *instance,double value);
void (*old_DoubleExample4)(void *instance);
void DoubleExample4(void *instance) {
	if (instance != NULL) {
		if (IsDoubleExample4) {
			DoubleHook1(instance, 999999999.0); // Double Hook Value = 999,999,999
		}
	}
	return old_DoubleExample4(instance);
}



// Hooking Examples For 32 - Bit ( armeabi-v7a ):

// Field Offset Hooking Examples:

bool IsBoolExample5 = false;
bool IsIntExample5 = false;
bool IsFloatExample5 = false;
bool IsDoubleExample5 = false;



// Bool Field Offset Hooking Example:
void (*old_BoolExample5)(void *instance);
void BoolExample5(float *instance) {
	if (instance != NULL) {
		if (IsBoolExample5) {
			*(bool *) ((uint32_t) instance + 0x00) = true; // Or you can put return false;.
		}
	}
	return old_BoolExample5(instance);
}

// Int Field Offset Hooking Example:
void (*old_IntExample5)(void *instance);
void IntExample5(float *instance) {
	if (instance != NULL) {
		if (IsIntExample5) {
			*(int *) ((uint32_t) instance + 0x00) = 999999999; // Int Hook Value = 999,999,999
		}
	}
	return old_IntExample5(instance);
}

// Float Field Offset Hooking Example:
void (*old_FloatExample5)(void *instance);
void FloatExample5(float *instance) {
	if (instance != NULL) {
		if (IsFloatExample5) {
			*(float *) ((uint32_t) instance + 0x00) = 999999999.0f; // Float Hook Value = 999,999,999
		}
	}
	return old_FloatExample5(instance);
}

// Double Field Offset Hooking Example:
void (*old_DoubleExample5)(void *instance);
void DoubleExample5(float *instance) {
	if (instance != NULL) {
		if (IsDoubleExample5) {
			*(double *) ((uint32_t) instance + 0x00) = 999999999.0; // Double Hook Value = 999,999,999
		}
	}
	return old_DoubleExample5(instance);
}

// Multi Field Offset Hooking Example:

bool IsMultiHookExample2 = false;



void (*old_MultiHookExample2)(void *instance);
void MultiHookExample2(void *instance){
	if(instance != NULL){
		if (IsMultiHookExample2) {

			// Bool Field Offset Hooking Example:
			*(bool *)((uint32_t)instance + 0x00) = true; // Or you can put return false;.

			// Int Field Offset Hooking Example:
			*(int *)((uint32_t)instance + 0x00) = 999999999; // Int Hook Value = 999,999,999

			// Float Field Offset Hooking Example:
			*(float *)((uint32_t)instance + 0x00) = 999999999.0f; // Float Hook Value = 999,999,999

			// Double Field Offset Hooking Example:
			*(double *)((uint32_t)instance + 0x00) = 999999999.0; // Double Hook Value = 999,999,999

		}
	}
	return old_MultiHookExample2(instance);
}

// Method Offset Hooking Examples:

bool IsBoolExample6 = false;
bool IsIntExample6 = false;
bool IsFloatExample6 = false;
bool IsDoubleExample6 = false;



// Bool Method Offset Hooking Example:
bool (*old_BoolExample6)(void *instance);
bool BoolExample6(void *instance) {
	if (instance != NULL) {
		if (IsBoolExample6) {
			return true; // Or you can put return false;.
		}
	}
	return old_BoolExample6(instance);
}

// Int Method Offset Hooking Example:
int (*old_IntExample6)(void *instance);
int IntExample6(void *instance) {
	if (instance != NULL) {
		if (IsIntExample6) {
			return 999999999; // Int Hook Value = 999,999,999
		}
	}
	return old_IntExample6(instance);
}

// Float Method Offset Hooking Example:
float (*old_FloatExample6)(void *instance);
float FloatExample6(void *instance) {
	if (instance != NULL) {
		if (IsFloatExample6) {
			return 999999999.0f; // Float Hook Value = 999,999,999
		}
	}
	return old_FloatExample6(instance);
}

// Double Method Offset Hooking Example:
double (*old_DoubleExample6)(void *instance);
double DoubleExample6(void *instance) {
	if (instance != NULL) {
		if (IsDoubleExample6) {
			return 999999999.0; // Double Hook Value = 999,999,999
		}
	}
	return old_DoubleExample6(instance);
}

// Void Method Offset Hooking Examples ( With No Update Method Offset ):

bool IsBoolExample7;
int IsIntExample7;
float IsFloatExample7;
double IsDoubleExample7;



// Bool Void Method Offset Hooking Example:
void (*old_BoolExample7)(void *instance, bool value);
void BoolExample7(void *instance, bool value) {
	if (instance != NULL) {
		if (IsBoolExample7) {
			old_BoolExample7(instance, true); // Or you can put return false;.
			return;
		}
	}
	return old_BoolExample7(instance,value);
}

// Int Void Method Offset Hooking Example:
void (*old_IntExample7)(void *instance, int value);
void IntExample7(void *instance, int value) {
	if (instance != NULL) {
		if (IsIntExample7) {
			old_IntExample7(instance, 999999999); // Int Hook Value = 999,999,999
			return;
		}
	}
	return old_IntExample7(instance,value);
}

// Float Void Method Offset Hooking Example:
void (*old_FloatExample7)(void *instance, float value);
void FloatExampl7(void *instance, float value) {
	if (instance != NULL) {
		if (IsFloatExample7) {
			old_FloatExample7(instance, 999999999.0f); // Float Hook Value = 999,999,999
			return;
		}
	}
	return old_FloatExample7(instance,value);
}

// Double Void Method Offset Hooking Example:
void (*old_DoubleExample7)(void *instance, double value);
void DoubleExample7(void *instance, double value) {
	if (instance != NULL) {
		if (IsDoubleExample7) {
			old_DoubleExample7(instance, 999999999.0); // Double Hook Value = 999,999,999
			return;
		}
	}
	return old_DoubleExample7(instance,value);
}

// Void Method Offset Hooking Examples ( With Update Method Offset ):

bool IsBoolExample8;
bool IsIntExample8;
bool IsFloatExample8;
bool IsDoubleExample8;



// Bool Void Method Offset Hooking Example:
void (*BoolHook2)(void *instance,bool value);
void (*old_BoolExample8)(void *instance);
void BoolExample8(void *instance) {
	if (instance != NULL) {
		if (IsBoolExample8) {
			BoolHook2(instance, true); // Or you can put return false;.
		}
	}
	return old_BoolExample8(instance);
}

// Int Void Method Offset Hooking Example:
void (*IntHook2)(void *instance,int value);
void (*old_IntExample8)(void *instance);
void IntExample8(void *instance) {
	if (instance != NULL) {
		if (IsIntExample8) {
			IntHook2(instance, 999999999); // Int Hook Value = 999,999,999
		}
	}
	return old_IntExample8(instance);
}

// Float Void Method Offset Hooking Example:
void (*FloatHook2)(void *instance,float value);
void (*old_FloatExample8)(void *instance);
void FloatExample8(void *instance) {
	if (instance != NULL) {
		if (IsFloatExample8) {
			FloatHook2(instance, 999999999.0f); // Float Hook Value = 999,999,999
		}
	}
	return old_FloatExample8(instance);
}

// Double Void Method Offset Hooking Example:
void (*DoubleHook2)(void *instance,double value);
void (*old_DoubleExample8)(void *instance);
void DoubleExample8(void *instance) {
	if (instance != NULL) {
		if (IsDoubleExample8) {
			DoubleHook2(instance, 999999999.0); // Double Hook Value = 999,999,999
		}
	}
	return old_DoubleExample8(instance);
}


// ImGui UI code for hook controls
void DrawImGuiHooks() {
    // 64-bit hooks section
    if (ImGui::CollapsingHeader("64-bit Hooks (arm64-v8a)")) {
        // Field Offset Hooks
        ImGui::Text("Field Offset Hooks:");
        ImGui::Checkbox("Bool Example 1", &IsBoolExample1);
        ImGui::Checkbox("Int Example 1", &IsIntExample1);
        ImGui::Checkbox("Float Example 1", &IsFloatExample1);
        ImGui::Checkbox("Double Example 1", &IsDoubleExample1);
        ImGui::Checkbox("Multi Hook Example 1", &IsMultiHookExample1);

        ImGui::Separator();

        // Method Offset Hooks
        ImGui::Text("Method Offset Hooks:");
        ImGui::Checkbox("Bool Example 2", &IsBoolExample2);
        ImGui::Checkbox("Int Example 2", &IsIntExample2);
        ImGui::Checkbox("Float Example 2", &IsFloatExample2);
        ImGui::Checkbox("Double Example 2", &IsDoubleExample2);

        ImGui::Separator();

        // Void Method Hooks (No Update Method)
        ImGui::Text("Void Method Hooks (No Update):");
        ImGui::Checkbox("Bool Example 3", &IsBoolExample3);
        ImGui::Checkbox("Int Example 3", &IsIntExample3);
        ImGui::Checkbox("Float Example 3", &IsFloatExample3);
        ImGui::Checkbox("Double Example 3", &IsDoubleExample3);

        ImGui::Separator();

        // Void Method Hooks (With Update Method)
        ImGui::Text("Void Method Hooks (With Update):");
        ImGui::Checkbox("Bool Example 4", &IsBoolExample4);
        ImGui::Checkbox("Int Example 4", &IsIntExample4);
        ImGui::Checkbox("Float Example 4", &IsFloatExample4);
        ImGui::Checkbox("Double Example 4", &IsDoubleExample4);
    }

    // 32-bit hooks section
    if (ImGui::CollapsingHeader("32-bit Hooks (armeabi-v7a)")) {
        // Field Offset Hooks
        ImGui::Text("Field Offset Hooks:");
        ImGui::Checkbox("Bool Example 5", &IsBoolExample5);
        ImGui::Checkbox("Int Example 5", &IsIntExample5);
        ImGui::Checkbox("Float Example 5", &IsFloatExample5);
        ImGui::Checkbox("Double Example 5", &IsDoubleExample5);
        ImGui::Checkbox("Multi Hook Example 2", &IsMultiHookExample2);

        ImGui::Separator();

        // Method Offset Hooks
        ImGui::Text("Method Offset Hooks:");
        ImGui::Checkbox("Bool Example 6", &IsBoolExample6);
        ImGui::Checkbox("Int Example 6", &IsIntExample6);
        ImGui::Checkbox("Float Example 6", &IsFloatExample6);
        ImGui::Checkbox("Double Example 6", &IsDoubleExample6);

        ImGui::Separator();

        // Void Method Hooks (No Update Method)
        ImGui::Text("Void Method Hooks (No Update):");
        ImGui::Checkbox("Bool Example 7", &IsBoolExample7);
        ImGui::Checkbox("Int Example 7", &IsIntExample7);
        ImGui::Checkbox("Float Example 7", &IsFloatExample7);
        ImGui::Checkbox("Double Example 7", &IsDoubleExample7);

        ImGui::Separator();

        // Void Method Hooks (With Update Method)
        ImGui::Text("Void Method Hooks (With Update):");
        ImGui::Checkbox("Bool Example 8", &IsBoolExample8);
        ImGui::Checkbox("Int Example 8", &IsIntExample8);
        ImGui::Checkbox("Float Example 8", &IsFloatExample8);
        ImGui::Checkbox("Double Example 8", &IsDoubleExample8);
    }
}




	// Field Offset Hooking Examples:
	auto BoolExample1Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD BoolExample1Update = BoolExample1Target->GetMethodOffsetByName(OBFUSCATE("Update"), 0);
	DobbyHook((void *)BoolExample1Update, (void *)BoolExample1, (void **)&old_BoolExample1);

	auto IntExample1Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD IntExample1Update = IntExample1Target->GetMethodOffsetByName(OBFUSCATE("Update"), 0);
	DobbyHook((void *)IntExample1Update, (void *)IntExample1, (void **)&old_IntExample1);

	auto FloatExample1Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD FloatExample1Update = FloatExample1Target->GetMethodOffsetByName(OBFUSCATE("Update"), 0);
	DobbyHook((void *)FloatExample1Update, (void *)FloatExample1, (void **)&old_FloatExample1);

	auto DoubleExample1Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD DoubleExample1Update = DoubleExample1Target->GetMethodOffsetByName(OBFUSCATE("Update"), 0);
	DobbyHook((void *)DoubleExample1Update, (void *)DoubleExample1, (void **)&old_DoubleExample1);

	// Multi Field Offset Hooking Example:
	auto MultiHookExample1Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD MultiHookExample1Update = MultiHookExample1Target->GetMethodOffsetByName(OBFUSCATE("Update"), 0);
	DobbyHook((void *)MultiHookExample1Update, (void *)MultiHookExample1, (void **)&old_MultiHookExample1);

	// Method Offset Hooking Examples:
	auto BoolExample2Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD BoolExample2Method = BoolExample2Target->GetMethodOffsetByName(OBFUSCATE("YourMethodName"), 0);
	DobbyHook((void *)BoolExample2Method, (void *)BoolExample2, (void **)&old_BoolExample2);

	auto IntExample2Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD IntExample2Method = IntExample2Target->GetMethodOffsetByName(OBFUSCATE("YourMethodName"), 0);
	DobbyHook((void *)IntExample2Method, (void *)IntExample2, (void **)&old_IntExample2);

	auto FloatExample2Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD FloatExample2Method = FloatExample2Target->GetMethodOffsetByName(OBFUSCATE("YourMethodName"), 0);
	DobbyHook((void *)FloatExample2Method, (void *)FloatExample2, (void **)&old_FloatExample2);

	auto DoubleExample2Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD DoubleExample2Method = DoubleExample2Target->GetMethodOffsetByName(OBFUSCATE("YourMethodName"), 0);
	DobbyHook((void *)DoubleExample2Method, (void *)DoubleExample2, (void **)&old_DoubleExample2);

	// Void Method Offset Hooking Examples (With No Update Method Offset):
	auto BoolExample3Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD BoolExample3Method = BoolExample3Target->GetMethodOffsetByName(OBFUSCATE("YourVoidMethod"), 0);
	DobbyHook((void *)BoolExample3Method, (void *)BoolExample3, (void **)&old_BoolExample3);

	auto IntExample3Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD IntExample3Method = IntExample3Target->GetMethodOffsetByName(OBFUSCATE("YourVoidMethod"), 0);
	DobbyHook((void *)IntExample3Method, (void *)IntExample3, (void **)&old_IntExample3);

	auto FloatExample3Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD FloatExample3Method = FloatExample3Target->GetMethodOffsetByName(OBFUSCATE("YourVoidMethod"), 0);
	DobbyHook((void *)FloatExample3Method, (void *)FloatExample3, (void **)&old_FloatExample3);

	auto DoubleExample3Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD DoubleExample3Method = DoubleExample3Target->GetMethodOffsetByName(OBFUSCATE("YourVoidMethod"), 0);
	DobbyHook((void *)DoubleExample3Method, (void *)DoubleExample3, (void **)&old_DoubleExample3);

	// Void Method Offset Hooking Examples (With Update Method Offset):
	auto BoolHook1Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD BoolHook1Method = BoolHook1Target->GetMethodOffsetByName(OBFUSCATE("YourVoidMethod"), 0);
	BoolHook1 = (void (*)(void *, bool))(BoolHook1Method);

	auto BoolExample4Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD BoolExample4Update = BoolExample4Target->GetMethodOffsetByName(OBFUSCATE("Update"), 0);
	DobbyHook((void *)BoolExample4Update, (void *)BoolExample4, (void **)&old_BoolExample4);

	auto IntHook1Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD IntHook1Method = IntHook1Target->GetMethodOffsetByName(OBFUSCATE("YourVoidMethod"), 0);
	IntHook1 = (void (*)(void *, int))(IntHook1Method);

	auto IntExample4Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD IntExample4Update = IntExample4Target->GetMethodOffsetByName(OBFUSCATE("Update"), 0);
	DobbyHook((void *)IntExample4Update, (void *)IntExample4, (void **)&old_IntExample4);

	auto FloatHook1Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD FloatHook1Method = FloatHook1Target->GetMethodOffsetByName(OBFUSCATE("YourVoidMethod"), 0);
	FloatHook1 = (void (*)(void *, float))(FloatHook1Method);

	auto FloatExample4Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD FloatExample4Update = FloatExample4Target->GetMethodOffsetByName(OBFUSCATE("Update"), 0);
	DobbyHook((void *)FloatExample4Update, (void *)FloatExample4, (void **)&old_FloatExample4);

	auto DoubleHook1Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD DoubleHook1Method = DoubleHook1Target->GetMethodOffsetByName(OBFUSCATE("YourVoidMethod"), 0);
	DoubleHook1 = (void (*)(void *, double))(DoubleHook1Method);

	auto DoubleExample4Target = new LoadClass("", OBFUSCATE("YourClassNameHere"));
	DWORD DoubleExample4Update = DoubleExample4Target->GetMethodOffsetByName(OBFUSCATE("Update"), 0);
	DobbyHook((void *)DoubleExample4Update, (void *)DoubleExample4, (void **)&old_DoubleExample4);


	// Added All type of hook example here..

	// You can take codes from here

// ========[ Fov Hack Code ]=============\\

bool fovFeature = false;
int fovValue = 55;
void (*Org_FovHack1)(void *instance, float fov);
void FovHack1(void *instance, float fov) {
    if (instance != NULL) {
        if (fovFeature) {
            fov = fovValue;
        }
    }
    Org_FovHack1(instance, fov);
}
float (*Org_FovHack2)(void *instance);
float FovHack2(void *instance) {
    if (instance != NULL) {
        if (fovFeature) {
            return fovValue;
        }
    }
    return Org_FovHack2(instance);
}


ImGui::Checkbox("Camera Fov", &fovFeature);
if (fovFeature)
{
ImGui::SliderInt("Fov value", &fovValue, 360, 0);
}


auto Camera = new LoadClass("UnityEngine", OBFUSCATE("Camera"));
DWORD P_View = Camera->GetMethodOffsetByName(OBFUSCATE("set_fieldOfView"), 1);
DWORD P_View2 = Camera->GetMethodOffsetByName(OBFUSCATE("get_fieldOfView"), 0);
DobbyHook((void *) P_View, (void *) FovHack1, (void **) &Org_FovHack1);
DobbyHook((void *) P_View2, (void *) FovHack2, (void **) &Org_FovHack2);


// ==================\\