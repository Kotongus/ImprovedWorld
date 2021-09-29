local dM=...dM.name='Grab Fix'dM.author='olv'
dM.description='Adds back grabbing.'
local function U(mvi,g4KV)
return

g4KV==6 and
(not mvi:getInventorySlot(1).primaryItem or
mvi:getInventorySlot(0).primaryItem and
(
mvi:getInventorySlot(0).primaryItem.type.numHands>1 or
mvi:getInventorySlot(0).primaryItem.type.index==36))or
g4KV==9 and not mvi:getInventorySlot(0).primaryItem end;local _u={[6]="leftHandGrab",[9]="rightHandGrab"}
local function aLgiy(dT7iYDf4,L,WRH9,cJoBcud)
local e=dT7iYDf4:getRigidBody(L)
return




dT7iYDf4.isAlive and dT7iYDf4.health>49 and U(dT7iYDf4,L)and dT7iYDf4.stamina>=10 and
e.data.ADKfSK and not dT7iYDf4.vehicle and WRH9 and
cJoBcud and
e.pos:dist(WRH9:getRigidBody(cJoBcud).pos)<0.4 and not WRH9.vehicle end
dM:addHook("Logic",function()
for B6zKxgVs,O3_X in ipairs(humans.getAll())do
for DVs8kf2w=0,15 do
local vms5=O3_X:getRigidBody(DVs8kf2w)vms5.data.human=O3_X;vms5.data.index=DVs8kf2w end
O3_X.data.ZAjsDM=O3_X.data.ZAjsDM or 0
if O3_X.data.ZAjsDM>0 then O3_X.data.ZAjsDM=
O3_X.data.ZAjsDM-1 elseif
bit32.band(O3_X.inputFlags,2048)==2048 then O3_X.data.ZAjsDM=8;local M7=0
for v3,ihKb in pairs(_u)do
local JGSK=O3_X.data[ihKb]if

O3_X:getRigidBody(v3).data.AWfmkaw and JGSK and JGSK.health>49 and JGSK.isAlive then M7=M7+1 end end;O3_X.stamina=math.max(O3_X.stamina-M7,0)end
for rA5U,Uc06 in pairs(_u)do local lcBL=O3_X:getRigidBody(rA5U)
local DHPxI=lcBL.data.AWfmkaw
local dx,RRuSHnxf=O3_X.data[Uc06],O3_X.data[Uc06 ..'Index']
if not aLgiy(O3_X,rA5U,dx,RRuSHnxf)and DHPxI then O3_X.data[Uc06]=
nil;O3_X.data[Uc06 ..'Index']=nil
DHPxI.despawnTime=0;lcBL.data.AWfmkaw=nil end end end end)
dM:addHook("CollideBodies",function(mcYOuT,Rr)
if
not mcYOuT or not Rr or not mcYOuT.isActive or not Rr.isActive then return end;local scRP0,AI0R2TQ6=mcYOuT.data.human,mcYOuT.data.index
local yA,XmVolesU=Rr.data.human,Rr.data.index
local eZ0l3ch={{mcYOuT,Rr,scRP0,AI0R2TQ6,yA,XmVolesU},{Rr,mcYOuT,yA,XmVolesU,scRP0,AI0R2TQ6}}
for W_63_9,h9dyA_4T in ipairs(eZ0l3ch)do local oh,DZXGTh,Su9Koz,Uk7e,KwQCk_G,ptZa=table.unpack(h9dyA_4T)
if
not
(
not oh or not
DZXGTh or not Su9Koz or not Uk7e or
not KwQCk_G or not ptZa or not
_u[Uk7e]or oh.data.AWfmkaw or not aLgiy(Su9Koz,Uk7e,KwQCk_G,ptZa))then local PEqsd=_u[Uk7e]
if
not hook.run("HumanGrabbing",Su9Koz,Uk7e,KwQCk_G,ptZa)then Su9Koz.data[PEqsd]=KwQCk_G
Su9Koz.data[PEqsd..'Index']=ptZa
oh.data.AWfmkaw=oh:bondTo(DZXGTh,Vector(),Vector())
hook.run("PostHumanGrabbing",Su9Koz,Uk7e,KwQCk_G,ptZa)end end end end)
dM:addHook("HumanLimbInverseKinematics",function(iSj,iXxD6s,oiY,FsYIVlkf)
if
iXxD6s==2 and iSj.isAlive and iSj.health>49 then
local HLXS0Q_=bit32.band(iSj.inputFlags,2048)==2048;local Kw=oiY+2;local nvaIsNv7=iSj:getRigidBody(Kw)
local vDnoL55=Vector(oiY==7 and-0.1 or 0.1,0,
bit32.band(iSj.inputFlags,2)==2 and-0.35 or-0.57)if iSj.viewPitch>0 then
vDnoL55.z=vDnoL55.z-iSj.viewPitch*0.0854 end;local xlAK=HLXS0Q_ and U(iSj,Kw)
if xlAK and not
iSj.data.noGrabIK then FsYIVlkf:set(vDnoL55)end;nvaIsNv7.data.ADKfSK=xlAK end end)
dM.commands["/grabfix"]={info="Get grab information.",usage="/grabfix",call=function(zr1y)
zr1y:sendMessage("olv's Grab Fix | 09/28/21")end}