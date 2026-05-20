local HttpService = game:GetService("HttpService")

local DatabaseURL = "https://phuoc-245b8-default-rtdb.asia-southeast1.firebasedatabase.app/KeySystem.json"

local TIME_3_MINS = 180
local TIME_7_DAYS = 7 * 24 * 60 * 60
local TIME_30_DAYS = 30 * 24 * 60 * 60
local PERMANENT = -1

local KeyCategories = {
    [TIME_3_MINS] = { -- Nhóm 3 phút (Test)
        "test-3p-1",
        "test-3p-2",
        "29448vnj-cjjend9"
    },
    
    [TIME_7_DAYS] = { -- Nhóm 7 ngày
        "key-7ngay-abc",
        "user-pro-7d",
        "farm-7d-001"
    },
    
    [TIME_30_DAYS] = { -- Nhóm 30 ngày
        "vip-30day-xyz",
        "member-premium-30",
        "key-thang-99"
    },
    
    [PERMANENT] = { -- Nhóm vĩnh viễn
        "HSi99n-HSub88-ksjU4",
        "admin-full-life",
        "boss-server-infinity"
    }
}

local Config = {
    MyKey = (getgenv().tmconfig and getgenv().tmconfig.key) or "key-mac-dinh",
    MaxTabs = (getgenv().tmconfig and getgenv().tmconfig.max_tabs) or 9999,
    DanhSachKey = {}
}

-- Tự động chuyển danh sách nhóm vào danh sách tổng để script check
for duration, keys in pairs(KeyCategories) do
    for _, kName in ipairs(keys) do
        Config.DanhSachKey[kName] = duration
    end
end

local function GetDB()
    local success, response = pcall(function()
        return request({
            Url = DatabaseURL,
            Method = "GET"
        })
    end)
    if success and response.StatusCode == 200 and response.Body ~= "null" then
        return HttpService:JSONDecode(response.Body)
    end
    return {}
end

local function SaveDB(db)
    pcall(function()
        request({
            Url = DatabaseURL,
            Method = "PUT",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(db)
        })
    end)
end

local function FormatTime(seconds)
    if seconds == -1 then return "Vĩnh viễn" end
    if seconds <= 0 then return "Đã hết hạn" end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    if days > 0 then return string.format("%d ngày, %d giờ", days, hours) end
    return string.format("%d phút, %d giây", mins, seconds % 60)
end

local MyTabID = tostring(math.random(100000, 999999))

local function CheckAuth()
    local inputKey = Config.MyKey
    local currentTime = os.time()
    local db = GetDB()

    -- 1. Check xem key có trong danh sách trắng không
    local keyDuration = Config.DanhSachKey[inputKey]
    if not keyDuration then 
        return false, "Key không tồn tại trong hệ thống!" 
    end

    -- 2. Lấy dữ liệu trên Firebase
    if not db[inputKey] then
        db[inputKey] = {StartTime = 0, IsExpired = false, ActiveTabs = {}}
    end
    local kData = db[inputKey]

    -- 3. Check xem đã bị khóa vĩnh viễn chưa
    if kData.IsExpired then 
        return false, "Key này đã hết hạn sử dụng trước đó!" 
    end

    -- 4. Kích hoạt lần đầu
    if kData.StartTime == 0 then
        kData.StartTime = currentTime
    end

    -- 5. Tính toán thời gian còn lại
    local timeLeft = -1
    if keyDuration ~= -1 then
        local timePassed = currentTime - kData.StartTime
        timeLeft = keyDuration - timePassed
        
        if timePassed >= keyDuration then
            kData.IsExpired = true
            db[inputKey] = kData
            SaveDB(db)
            return false, "Thời hạn key đã hết ("..FormatTime(keyDuration)..")!"
        end
    end

    -- 6. Quản lý số Tab (Concurrency)
    local updatedTabs = {}
    local onlineCount = 0
    for id, lastSeen in pairs(kData.ActiveTabs or {}) do
        if (currentTime - lastSeen) < 15 then
            updatedTabs[id] = lastSeen
            onlineCount = onlineCount + 1
        end
    end

    if not updatedTabs[MyTabID] then
        if onlineCount >= Config.MaxTabs then
            return false, "Key đã đạt giới hạn " .. Config.MaxTabs .. " tab!"
        end
        onlineCount = onlineCount + 1
    end

    updatedTabs[MyTabID] = currentTime
    kData.ActiveTabs = updatedTabs
    db[inputKey] = kData
    
    SaveDB(db)
    return true, onlineCount, timeLeft
end

-- ==========================================
-- 6. THỰC THI
-- ==========================================
local function StartFarmScript()
local Config = {
    Fpscap   = 13, -- fpscap / frame per second limit
    Lowset   = true, -- Auto use low settings / Low Texture ( more time loading )
    Hidemap  = true, -- Auto On Hidemap / 100% transparency ( Hidemap on = Skip Lowset )
    Norender = false, -- Auto On Norender / Hide 3d render
    EnableUi = true, -- Auto Enable ui
}
getgenv().Config = Config
loadstring(game:HttpGet("https://raw.githubusercontent.com/Nsama239/kocojdau/refs/heads/main/kocojdau"))()
    print(">>> SCRIPT FARM ĐANG CHẠY...")
end

local success, result, timeLeft = CheckAuth()

if not success then
    game.Players.LocalPlayer:Kick("dg chay" .. result)
else
    print("------------------------------------------")
    print("KEY: " .. Config.MyKey)
    print("HẠN DÙNG: " .. FormatTime(timeLeft))
    print("SỐ TAB: " .. result .. "/" .. Config.MaxTabs)
    print("------------------------------------------")

    StartFarmScript()
    
    task.spawn(function()
        while task.wait(5) do
            local ok, msg = CheckAuth()
            if not ok then
                game.Players.LocalPlayer:Kick("\n[CẢNH BÁO]\n" .. msg)
                break
            end
        end
    end)
end





-------------


repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

getgenv().tmconfig = {
    key = "test-3p-1", -- Nhập key tại đây
    max_tabs = 9999           -- Giới hạn số tab
}

loadstring(game:HttpGet("https://github.com/tain3028-crypto/melee.lua/raw/refs/heads/main/buymele-neo"))()
