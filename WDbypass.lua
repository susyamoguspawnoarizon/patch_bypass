script_name('Bypass World Drift') -- �������� �������
script_author('Samperch1k') -- ����� �������
script_description('Bypasser') -- �������� �������

require "lib.moonloader" -- ����������� ����������
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 2
local script_vers_text = "1.01"

local update_url = "https://raw.githubusercontent.com/susyamoguspawnoarizon/patch_bypass/main/update.ini" -- ��� ���� ���� ������
local update_path = getWorkingDirectory() .. "/update.ini" -- � ��� ���� ������

local script_url = "https://github.com/susyamoguspawnoarizon/patch_bypass/raw/main/WD%20bypass_protected.luac" -- ��� ���� ������
local script_path = thisScript().path

local state = false
local sampev = require 'samp.events'
local users =
{
    [1] = 'jojojoj'
}

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
    sampRegisterChatCommand("update", cmd_update)

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                message("���� ����������! ������: " .. updateIni.info.vers_text)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    
	while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    message("������ ������� ��������!")
                    thisScript():reload()
                end
            end)
            break
        end

	end
    if check_server() then
        check()
    else
        message('��� �������� �������...')
        wait(250)
        message('����� ����������� ������ �� �������� World Drift!')
        sampSetGamestate(GAMESTATE_DISCONNECTED)
    end
end

function check_server()
    local servers = { -- ��������� ���� ��������, ������� ��� ����� | ���� ������
        '51.91.91.88',
        '51.91.91.91'
    }
    local ip = select(1, sampGetCurrentServerAddress()) -- �������� ���� ������� �� ������� �� ������
    for k, v in pairs(servers) do -- ���������
        if v == ip then
            return true -- ���� �� ��������� �� ��� �������
        end
    end
    return false -- ���� �� �� ������
end

function check()
    for i = 1, #users do
        if users[i] == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(1))) then
            state = true
            break
        else
            state = false
        end
    end
    if state then
        sampDisconnectWithReason(0)
        sampSetGamestate(GAMESTATE_WAIT_CONNECT)
        message('������ ������ ��������, ��������������� ����������!')
        message('�����: ����� ������ VK: @chiefcief')
        message('��� VK: @chiefcief')

    else
        enableDialog(false)
        message('������ �� ������ ��������, ������ ������ ����� � ���� VK')
        message('�����: ����� ������ VK: @chiefcief')
        sampSetGamestate(GAMESTATE_DISCONNECTED)
    end
end

function sampev.onInitGame(playerId, hostName, settings, vehicleModels, unknown)
    for i = 1, #users do
        if users[i] == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(1))) then
            state = true
            break
        else
            state = false
        end
    end
    if state then
        sampSetGamestate(GAMESTATE_WAIT_CONNECT)
        message('������ ������ ��������, ��������������� ����������!')
        message('�����: ����� ������ VK: @chiefcief')
        message('��� VK: @chiefcief')

    else
        enableDialog(false)
        sampSetGamestate(GAMESTATE_DISCONNECTED)
        sampDisconnectWithReason(0)
        message('������ �� ������ ��������, ������ ������ ����� � ���� VK')
        message('�����: ����� ������ VK: @chiefcief')
    end
end

function sampev.onSendClientJoin(version, mod, nickname, challengeResponse, joinAuthKey, clientVer, challengeResponse2)
    version = "4057"
    clientVer = "0.3.7"
    joinAuthKey = "E02262CF28BC542486C558D4BE9EFB716592AFAF8B"
    return {version, mod, nickname, challengeResponse, joinAuthKey, clientVer, challengeResponse2}
end

function enableDialog(bool)
    writeMemory(sampGetDialogInfoPtr() + 40, 2, bool and 1 or 0, true)
    sampToggleCursor(bool)
end

function message(text)
	return sampAddChatMessage('{DC143C}[�����]: {FFFFFF} '..text, 0xFF0000)
end

function cmd_update(arg)
    sampShowDialog(1000, "������ ����������", "{FFFFFF}��� ���� ��� �����\n{FFF000}����", "�������", "", 0)
end