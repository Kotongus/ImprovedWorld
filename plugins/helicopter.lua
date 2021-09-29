local rhVu=...rhVu.name="Helicopter Fix"rhVu.author="olv"
rhVu.description="Fixes the helicopter model."
local function ngzOjWHO(dM)
assert(dM,dM.type.index==12,"No valid vehicle provided")
local U=vehicles.create(vehicleTypes[14],dM.pos:clone(),dM.rot:clone(),dM.color)U.isLocked=true;U.controllableState=0;U.rigidBody.mass=1000
U.type=vehicleTypes[0]U:updateType()for _u=0,3 do
U:updateDestruction(1,_u,Vector(),Vector())end;U.data.aSFasF=dM
dM.data.WGKgFS=U;dM.rigidBody.data.vehicle=dM
U.rigidBody.data.vehicle=U;return U end
rhVu:addHook("Logic",function()
for aLgiy,mvi in ipairs(humans.getAll())do local g4KV=mvi.vehicle
if g4KV and
g4KV.type.index==12 and g4KV.data.WGKgFS and
g4KV.health>0 then g4KV.data.ADSscS=
g4KV.data.ADSscS or 0
if
g4KV.data.ADSscS<1 and mvi.vehicleSeat==0 then
g4KV.data.ADSscS=240;events.createSound(42,g4KV.pos,0.5,1)end end end
for dT7iYDf4,L in ipairs(vehicles.getAll())do
if L.isActive then
if L.type.index==12 then if
not L.data.WGKgFS then ngzOjWHO(L)end;L.data.ADSscS=
L.data.ADSscS or 0;if
L.data.ADSscS>0 then
L.data.ADSscS=L.data.ADSscS-1 end
local WRH9=L.data.WGKgFS
if WRH9 and WRH9.isActive then
WRH9.pos,WRH9.rigidBody.pos=L.pos:clone()+ (-
L.rot:getRight()*0.3),
L.rigidBody.pos:clone()+
(-L.rigidBody.rot:getRight()*0.3)
WRH9.vel,WRH9.rigidBody.vel=L.vel:clone(),L.rigidBody.vel:clone()
WRH9.rot,WRH9.rigidBody.rot=L.rot:clone(),L.rigidBody.rot:clone()
WRH9.rigidBody.rotVel=L.rigidBody.rotVel:clone()L.color=WRH9.color;L.health=WRH9.health else L:remove()end elseif L.data.WARAWS and not L.data.aSFasF then
L:remove()end end end end)
rhVu:addHook("CollideBodies",function(cJoBcud,e,B6zKxgVs,O3_X,DVs8kf2w,vms5,M7,v3,ihKb)if not cJoBcud or not e then return end
local JGSK,rA5U=cJoBcud.data.vehicle,e.data.vehicle
local Uc06={{cJoBcud,JGSK,B6zKxgVs},{e,rA5U,O3_X}}
for lcBL,DHPxI in ipairs(Uc06)do local dx,RRuSHnxf,mcYOuT=table.unpack(DHPxI)if
not dx or not RRuSHnxf or not RRuSHnxf.data.aSFasF then
return end
RRuSHnxf.data.aSFasF.rigidBody:collideLevel(
mcYOuT or Vector(),DVs8kf2w or Vector(),vms5 or 0.005,M7 or 0,v3 or 0,ihKb or 1)return hook.override end end)
rhVu.commands["/helifix"]={info="Get heli fix information.",usage="/helifix",call=function(Rr)
Rr:sendMessage("olv's Heli Fix | 09/28/21")end}