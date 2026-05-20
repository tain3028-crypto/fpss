-- ========================================================
-- 1. HỆ THỐNG KIỂM TRA KEY BẢO MẬT
-- ========================================================
local userConfig = getgenv().Config

-- Danh sách các Key hợp lệ (Bạn có thể thêm hoặc xóa key tại đây)
local ValidKeys = {
    ["HSi99n-HSub88-ksjU4"] = true,
    ["KEY-VIP-9999"] = true,
    ["HIEN-TAI-CHUA-CO-KEY-123"] = true,
}

-- Kiểm tra xem người dùng đã thiết lập Config và điền Key chưa
if not userConfig or not userConfig.Key then
    game:GetService("Players").LocalPlayer:Kick("Thất bại: Không tìm thấy Key cấu hình!")
    return
end

-- Kiểm tra xem Key của người dùng có nằm trong danh sách không
if not ValidKeys[userConfig.Key] then
    game:GetService("Players").LocalPlayer:Kick("Key không chính xác hoặc đã hết hạn!")
    return
end

print("Xác thực thành công! Đang khởi chạy các tính năng...")

-- ========================================================
-- 2. CODE TÍNH NĂNG CHÍNH CỦA BẠN (Đã đọc cài đặt từ người dùng)
-- ========================================================

-- Thiết lập FPS Cap
if userConfig.Fpscap and setfpscap then
    setfpscap(userConfig.Fpscap)
end

-- Tính năng Hidemap
if userConfig.Hidemap then
    print("Đang kích hoạt: Hidemap...")
    -- [Dán đoạn code xử lý 100% transparency / ẩn map của bạn ở đây]
end

-- Tính năng Lowset (Chỉ chạy nếu không bật Hidemap)
if userConfig.Lowset and not userConfig.Hidemap then
    print("Đang kích hoạt: Low Settings...")
    -- [Dán đoạn code xử lý Low Texture cũ của bạn vào đây]
end

-- Tính năng Norender (Tắt hiển thị 3D)
if userConfig.Norender then
    print("Đang kích hoạt: Norender...")
    if game:GetService("RunService") then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    end
end

-- Tính năng UI chính
if userConfig.EnableUi then
    print("Đang kích hoạt: Giao diện UI...")
    -- [Dán đoạn code chạy UI / Tính năng chính của bạn ở đây]
end
