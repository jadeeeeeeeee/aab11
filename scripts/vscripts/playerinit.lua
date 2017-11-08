

-- 初始化
function initstats()
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','') 
   math.randomseed(tonumber(timeTxt))

	PlayerStats = {}
	for i = 0,9 do
		PlayerStats[i] = {}   -- 每个玩家数据包
		PlayerStats[i]['length'] = 0
	end

	--初始化刷怪 

	--地点
	local temp_zuoshang = Entities:FindByName(nil, 'zuoshang')  --左上的坐标
	zb_zuoshang = temp_zuoshang:GetAbsOrigin()
	local temp_youxia = Entities:FindByName(nil, 'youxia')--右下的坐标
	zb_youxia = temp_youxia:GetAbsOrigin()
	--刷5个羊 3个牛 1个火人
	createunit("yang")
	createunit("yang")
	createunit("yang")
	createunit("yang")
	createunit("yang")

	createunit("niu")
	createunit("niu")
	createunit("niu")

	createunit("huoren")
	
end



function createunit(unitname)
	local location = Vector(math.random(zb_youxia.x - zb_zuoshang.x) + zb_zuoshang.x,math.random(zb_youxia.y - zb_zuoshang.y)+zb_zuoshang.y,zb_zuoshang.z)
	local unit = CreateUnitByName(unitname, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
	unit:SetContext("name", unitname, 0)
end

function createbaby(playerid)
	local followed_unit = PlayerStats[playerid]['group'][PlayerStats[playerid]['group_pointer']]
  	local chaoxiang = followed_unit:GetForwardVector()
  	local position = followed_unit:GetAbsOrigin()
  	local newposition = position - chaoxiang*100


	local new_unit = CreateUnitByName("littlebug", newposition, true, nil, nil, followed_unit:GetTeam())
	new_unit:SetForwardVector(chaoxiang)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("1"),
	 function ()
		new_unit:MoveToNPC(followed_unit)
		return 0.2
	 end,0) 
	--new_unit:SetControllableByPlayer(playerid, true)
	PlayerStats[playerid]['group_pointer'] = PlayerStats[playerid]['group_pointer']+1
	PlayerStats[playerid]['group'][PlayerStats[playerid]['group_pointer']]=new_unit

end