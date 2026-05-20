-- Lấy bảng Config do người dùng thiết lập
local userConfig = getgenv().Config

-- Danh sách các Key hợp lệ (Bạn có thể thêm/xóa key ở đây để kiểm soát người dùng)
local ValidKeys = {
    ["HSi99n-HSub88-ksjU4"] = true,
    ["KEY-VIP-9999"] = true,
    ["HIEN-TAI-CHUA-CO-KEY-123"] = true, -- Ví dụ key thử nghiệm
}

-- Kiểm tra xem người dùng đã thiết lập Config và điền Key chưa
if not userConfig or not userConfig.Key then
    game:GetService("Players").LocalPlayer:Kick("Thất bại: Không tìm thấy Key cấu hình!")
    return
end

-- Kiểm tra Key có nằm trong danh sách hợp lệ không
if not ValidKeys[userConfig.Key] then
    game:GetService("Players").LocalPlayer:Kick("Key không chính xác hoặc đã hết hạn!")
    return
end

-----------------------------------------------------------
-- PHẦN DƯỚI ĐÂY LÀ TOÀN BỘ SCRIPT CHÍNH (NOKEY CŨ CỦA BẠN)
-----------------------------------------------------------
print("Xác thực thành công! Đang khởi chạy script...")

-- Ví dụ cách gọi cấu hình người dùng cài đặt trong code của bạn:
if userConfig.Hidemap then
    print("Đang ẩn map...")
    -- Code ẩn map của bạn ở đây
end
local Config = {
    Fpscap   = 13, -- fpscap / frame per second limit
    Lowset   = true, -- Auto use low settings / Low Texture ( more time loading )
    Hidemap  = true, -- Auto On Hidemap / 100% transparency ( Hidemap on = Skip Lowset )
    Norender = true, -- Auto On Norender / Hide 3d render
    EnableUi = true, -- Auto Enable ui
}
getgenv().Config = Config
loadstring(game:HttpGet("https://raw.githubusercontent.com/Nsama239/kocojdau/refs/heads/main/kocojdau"))()
