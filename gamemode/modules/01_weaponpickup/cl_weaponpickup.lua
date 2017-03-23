-- Draw outlines (halos) around weapons and enemies
-- set DrawNPCHalo to false if you want to turn off halos around npcs

local DrawNPCHalo = true

local function DrawHalo()
		local tr = LocalPlayer():GetEyeTraceNoCursor()
		local trace = {}
		local friendlyNPC = false
		trace.start = tr.StartPos
		trace.endpos = trace.start + LocalPlayer():GetAimVector() * 10000
		trace.filter = self
		trace.mask = MASK_SHOT

		if IsValid(tr.Entity) and !tr.Entity:IsPlayer() then
			if tr.HitPos:Distance(tr.StartPos) < 1000 then
					local col = Color(255, 255, 255)
					if tr.Entity:IsNPC() then
						if DrawNPCHalo then col = Color(255, 0, 0) else return end
					end
					halo.Add({tr.Entity}, col, 5, 5, 2, true, true)
			end
		end
end

hook.Add("PreDrawHalos", "AddHalos", DrawHalo)