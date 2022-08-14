--
-- /notify <player> <message>
-- /notify_all <message>
--
-- Sends a message to online player(s) using HUD elements.
-- Restricted to moderators, due to the potential for abuse.
--

local players = {}
local duration = tonumber(minetest.settings:get("hud_notify.duration")) or 10
local hide_sender = minetest.settings:get_bool("hud_notify.hide_sender") or false

local function notify(sender, name, msg)
	local player = minetest.get_player_by_name(name)

	-- If notification is already being shown modify
	-- msg (and header if it exists) and time
	if players[name] then
		players[name].time = os.time() + duration
		player:hud_change(players[name].msg, "text", msg)
		if not hide_sender then
			player:hud_change(players[name].header, "text",
								"Notification from " .. sender .. ": ")
		end
		return
	end

	-- Else, add new elements
	players[name] = {time = os.time() + duration}
	players[name].bg = player:hud_add({
		hud_elem_type = "image",
		position = {x = 0, y = 0},
		offset = {x = 50, y = 300},
		scale = {x = -30, y = -30},
		alignment = {x = 1, y = 0},
		text = "hud_notify_bg.png"
	})
	players[name].msg = player:hud_add({
		hud_elem_type = "text",
		position = {x = 0, y = 0},
		offset = {x = 70, y = 230},
		alignment = {x = 1, y = 0},
		number = 0xFFFFFF,
		text = msg
	})

	if not hide_sender then
		local msg_header = "Notification from " .. sender .. ": "
		players[name].header = player:hud_add({
			hud_elem_type = "text",
			position = {x = 0, y = 0},
			offset = {x = 70, y = 200},
			alignment = {x = 1, y = 0},
			number = 0xFFCC00,
			text = msg_header
		})
	end
end

local function update()
	for name, hud in pairs(players) do
		if hud and os.time() > hud.time then
			local player = minetest.get_player_by_name(name)
			if player then
				player:hud_remove(hud.bg)
				player:hud_remove(hud.msg)
				if not hide_sender then
					player:hud_remove(hud.header)
				end
			end

			players[name] = nil
		end
	end
end

minetest.register_chatcommand("notify", {
	params = "<pname> <message>",
	description = "Shows a message to player using HUD elements.",
	privs = {kick = true, ban = true},
	func = function(name, param)
		local pname, msg = param:trim():match("^(%S+)%s(.+)$")
		if not pname or not msg then
			return false, "Invalid usage, see /help notify."
		end
		if not minetest.get_player_by_name(pname) then
			return false, "The player " .. pname .. " is not online."
		end

		notify(name, pname, msg)
		return true, "Notification sent to " .. pname .. ": \"" .. msg .. "\""
	end
})

minetest.register_chatcommand("notify_all", {
	params = "<message>",
	description = "Shows a message to all online players using HUD elements.",
	privs = {kick = true, ban = true},
	func = function(name, param)
		local msg = param:trim()
		if not msg then
			return false, "Invalid usage, see /help notify_all."
		end

		for _, player in pairs(minetest.get_connected_players()) do
			notify(name, player:get_player_name(), msg)
		end
		return true, "Global notification sent: \"" .. msg .. "\""
	end
})

minetest.register_globalstep(update)
