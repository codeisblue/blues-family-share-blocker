--Written by <CODE BLUE>
--If you plan to share please re-direct back to this github, thanks!

BFSB = {}

--Put in your (Get it here : https://steamcommunity.com/dev/apikey). If this is not set then it will not work.
BFSB.STEAM_DEV_API_KEY = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" 
	 
--If this is set to true, it will automaticaly kick any players that user family sharing (Not recommended as some are legit)
BFSB.KICK_SHARED_ACCOUNTS = false 
 
--If true, this will auto kick any players that join who are family shared with an account that has already been banned from the server (Recommended)
BFSB.KICK_SHARED_ACCOUNTS_WITH_BANNED_OWNERS = true

--If true, this will ban the family sharing owner when an account sharing with it is banned (Recommended)
BFSB.BAN_OWNING_ACCOUNT_ON_SHARED_BANNED = true
