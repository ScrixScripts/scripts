local ffi = require("ffi")
ffi.cdef[[
int __stdcall GetVolumeInformationA(
    const char* lpRootPathName,
    char* lpVolumeNameBuffer,
    uint32_t nVolumeNameSize,
    uint32_t* lpVolumeSerialNumber,
    uint32_t* lpMaximumComponentLength,
    uint32_t* lpFileSystemFlags,
    char* lpFileSystemNameBuffer,
    uint32_t nFileSystemNameSize
);
]]
local serial = ffi.new("unsigned long[1]", 0)
ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
serial = serial[0]
url = 'https://raw.githubusercontent.com/ScrixScripts/scripts/main/panel.ini' -- ������ �� ���� � �������


function getTableUsersByUrl(url)
    local n_file, bool, users = os.getenv('TEMP')..os.time(), false, {}
    downloadUrlToFile(url, n_file, function(id, status)
        if status == 6 then bool = true end
    end)
    while not doesFileExist(n_file) do wait(0) end
    if bool then
        local file = io.open(n_file, 'r')
        for w in file:lines() do
            local n, d = w:match('(.*): (.*)')
            users[#users+1] = { name = n, date = d }
        end
        file:close()
        os.remove(n_file)
    end
    return bool, users
end

function isAvailableUser(users, name)
    for i, k in pairs(users) do
        if k.name == name then
            local d, m, y = k.date:match('(%d+)%.(%d+)%.(%d+)')
            local time = {
                day = tonumber(d),
                isdst = true,
                wday = 0,
                yday = 0,
                year = tonumber(y),
                month = tonumber(m),
                hour = 0
            }
            if os.time(time) >= os.time() then return true end
        end
    end
    return false
end

function main()
    while not isSampAvailable() do wait(0) end
	print(serial)
    while sampGetCurrentServerName() == 'SA-MP' do wait(0) end
    local bool, users = getTableUsersByUrl(url)
    assert(bool, '{FFFFFF}��������� {FF0000}����������� {FFFFFF}������ ��� �������� ������')
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    assert(isAvailableUser(users, serial), '{FFFFFF}���� �������� �������� {FF0000}���� {FFFFFF}��� ������ �� ��� {32CD32}���������')
	
    sampAddChatMessage('������ {32CD32}������� {FFFFFF}�������', -1)
    while true do
        wait(0)

    end
end