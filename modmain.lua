function crsCustomPerishable(inst)
 inst.CustomUpdate = function(this, dt)
  if this.components.perishable then
   local modifier = 1
   local owner = this.components.inventoryitem and this.components.inventoryitem.owner or nil
   if owner then
    if owner:HasTag("crsCustomPerishMult") then
     if this:HasTag("frozen") and not owner:HasTag("nocool") and not owner:HasTag("lowcool") then
      modifier = TUNING.PERISH_COLD_FROZEN_MULT
     else
      modifier = owner.crsCustomPerishMult
     end
    elseif owner:HasTag("fridge") then
     if this:HasTag("frozen") and not owner:HasTag("nocool") and not owner:HasTag("lowcool") then
      modifier = TUNING.PERISH_COLD_FROZEN_MULT
     else
      modifier = TUNING.PERISH_FRIDGE_MULT 
     end
    elseif owner:HasTag("spoiler") then
     modifier = TUNING.PERISH_GROUND_MULT 
    end
   else
    modifier = TUNING.PERISH_GROUND_MULT 
   end

   if this:GetIsWet() then
    modifier = modifier * TUNING.PERISH_WET_MULT
   end


   if GLOBAL.TheWorld.state.temperature < 0 then
    if this:HasTag("frozen") and not this.components.perishable.frozenfiremult then
     modifier = TUNING.PERISH_COLD_FROZEN_MULT
    else
     modifier = modifier * TUNING.PERISH_WINTER_MULT
    end
   end

   if this.components.perishable.frozenfiremult then
    modifier = modifier * TUNING.PERISH_FROZEN_FIRE_MULT
   end

   if GLOBAL.TheWorld.state.temperature > TUNING.OVERHEAT_TEMP then
    modifier = modifier * TUNING.PERISH_SUMMER_MULT
   end

   modifier = modifier * TUNING.PERISH_GLOBAL_MULT

   local old_val = this.components.perishable.perishremainingtime
   local delta = dt or (10 + math.random()*FRAMES*8)
   if this.components.perishable.perishremainingtime then 
    this.components.perishable.perishremainingtime = this.components.perishable.perishremainingtime - delta*modifier
    if math.floor(old_val*100) ~= math.floor(this.components.perishable.perishremainingtime*100) then
     this:PushEvent("perishchange", {percent = this.components.perishable:GetPercent()})
    end
   end

   if this.components.edible and this.components.edible.temperaturedelta and this.components.edible.temperaturedelta > 0 then
    if owner and owner:HasTag("crsCustomTempDuration") then
     if not owner:HasTag("nocool") then
      this.components.edible.temperatureduration = this.components.edible.temperatureduration + owner.crsCustomTempDuration
     end
    elseif owner and owner:HasTag("fridge") then
     if not owner:HasTag("nocool") then
      this.components.edible.temperatureduration = this.components.edible.temperatureduration - 1
     end
    elseif GLOBAL.TheWorld.state.temperature < TUNING.OVERHEAT_TEMP - 5 then
     this.components.edible.temperatureduration = this.components.edible.temperatureduration - .25
    end
    if this.components.edible.temperatureduration < 0 then this.components.edible.temperatureduration = 0 end
   end

   if this.components.perishable.perishremainingtime and this.components.perishable.perishremainingtime <= 0 then
   this.components.perishable:Perish()
   end
  end
 end
 
 inst.LongUpdate = function(self, dt)
  if self.updatetask ~= nil then
   inst.CustomUpdate(self.inst, dt or 0)
  end
 end

 inst.StartPerishing = function(self)
  if self.updatetask ~= nil then
   self.updatetask:Cancel()
   self.updatetask = nil
  end

  local dt = 10 + math.random()*GLOBAL.FRAMES*8
  self.updatetask = self.inst:DoPeriodicTask(dt, CustomUpdate, math.random()*2, dt)
 end
 
end

AddComponentPostInit("perishable", crsCustomPerishable)
