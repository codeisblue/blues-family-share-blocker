--Written by <CODE BLUE>
--If you plan to share please re-direct back to this github, thanks!

include("bfsb_config.lua") 
 
local function CheckFamilySharedAccount(user , data)
	local owner = data["response"]["lender_steamid"] 
	if owner == "0" then 
		user.isfamilysharing = false  
		return 
	end 
	user.isfamilysharing = true 
	if BFSB.KICK_SHARED_ACCOUNTS then
		local reason =[[[FAMILY SHARE] Kicked from server for using a family shared account. This server does not allow this. If you with to play please purchase Garry's Mod on your account.]] 
		ULib.kick( user, reason ) 
	end 
	local ownersid = util.SteamIDFrom64(owner)
	user.familysharingowner = ownersid
	--Is the owner banned?
	local bans = ULib.bans
	if bans[ownersid] ~= nil then
		--Owner is banned so kick this user
		local reason =[[[FAMILY SHARE] Kicked from server for using an account which is family shared with a banned account (]]..ownersid
		..[[). You will be unbanned when the owning account is unbanned. If you think this is a mistake please appeal on the forums.]] 
		if BFSB.KICK_SHARED_ACCOUNTS_WITH_BANNED_OWNERS then
			ULib.kick( user, reason ) 
		end
	end
end

--Here we override the default ULX ban function so we can auto ban the owning account
--if it was the sharer that was banned
function ULib.kickban( ply, time, reason, admin )
	if not time or type( time ) ~= "number" then
		time = 0
	end 
	if ply.isfamilysharing then 
		print("Sharing account (Should ban owner)")  
		--Ban the owner becuase there sharing
		local _reason = [[[FAMILY SHARE] Banned from server becuase a user family sharing with your account was banned (]]..ply:SteamID()..[[). If you think this is a mistake please appeal on the forums.]]
		RunConsoleCommand("ulx", "banid" , ply.familysharingowner , time , _reason)
	end

	ULib.addBan( ply:SteamID(), time, reason, ply:Name(), admin )

	-- Load our currently banned users so we don't overwrite them
	if ULib.fileExists( "cfg/banned_user.cfg" ) then
		ULib.execFile( "cfg/banned_user.cfg" )
	end
end

hook.Add("PlayerAuthed" , "_check_family_shared" , function(ply , sid , uid)
	MsgC(Color(70,100,255) , "[FAMILY SHARING] " , Color(100,255,100) , "Checking account '",
		Color(255,255,0) , ply:Nick().." : "..sid , Color(100,255,100) , "'.\n") 
	local sid64 = util.SteamIDTo64(sid)
	--Check who the owner is
	local owner = -1
	local uri = "https://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v1?key="..BFSB.STEAM_DEV_API_KEY.."&steamid="..sid64.."&appid_playing=4000"
	http.Fetch( uri,
	function( body, len, headers, code ) 
		local data = util.JSONToTable(body)
		if data ~= nil and data["response"] ~= nil and data["response"]["lender_steamid"] ~= nil then
			CheckFamilySharedAccount(ply , data)
		else 
			MsgC(Color(70,100,255) , "[FAMILY SHARING] " , Color(255,80,80) , "Failed to check account '",
				Color(255,255,0) , ply:Nick().." : "..sid , Color(255,80,80) , "'. This was becuase something went wrong (Likely steam servers down or you put in the wrong API KEY)\n")
		end
	end,
	function( error )
		MsgC(Color(70,100,255) , "[FAMILY SHARING] " , Color(255,80,80) , "Failed to check account '",
			Color(255,255,0) , ply:Nick().." : "..sid , Color(255,80,80) , "'. This was becuase something went wrong (Likely steam servers down)\n")
	end
 )
end)

MsgC(Color(70,100,255) , "[FAMILY SHARING] " , Color(255,80,80) , "Loaded Blue's Family Sharing Blocker!\n")