local setting_get_pos = minetest.setting_get_pos
local spawn_pos = setting_get_pos("static_spawnpoint")
if not spawn_pos then
    minetest.log("no custom spawnpoint, using default one (0, 100, 0)")
    spawn_pos = {x=0, y=100,z=0}
end

mcl_damage.register_modifier(function(obj, damage, reason)
    local all_objects = minetest.get_objects_inside_radius(spawn_pos, 250) 
    for _,obj2 in ipairs(all_objects) do 
        if obj2:is_player() then
            if obj2.get_player_name(obj2) == obj.get_player_name(obj) then
                if damage > 0 then
                    local new_hp = obj:get_hp() + damage
                    obj:set_hp(new_hp)
                    if reason.source then
                        minetest.kick_player(reason.source.get_player_name(reason.source), "Spawn killing is not allowed (250 block radius)")
                        minetest.log(reason.source.get_player_name(reason.source) .. " just got kicked for spawn killing!")
                    end
                end
            end
        end
    end
end, 0)