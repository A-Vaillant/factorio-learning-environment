global.actions.inspect_inventory = function(player_index, is_character_inventory, x, y)
    local position = {x=x, y=y}
    local player = game.players[player_index]
    local surface = player.surface
    local function get_player_inventory_items(player)
        local inventory = player.get_main_inventory()
        if not inventory or not inventory.valid then
            return nil
        end

        local item_counts = inventory.get_contents()
        return item_counts
    end

    local function get_inventory()
        local closest_distance = math.huge
        local closest_entity = nil

        local area = {{position.x - 0.5, position.y - 0.5}, {position.x + 0.5, position.y + 0.5}}
        local buildings = surface.find_entities_filtered{area = area, force = "player"}
        -- Find the closest building
        for _, building in ipairs(buildings) do
            if building.rotatable and building.name ~= 'character' then
                local distance = ((position.x - building.position.x) ^ 2 + (position.y - building.position.y) ^ 2) ^ 0.5
                if distance < closest_distance then
                    closest_distance = distance
                    closest_entity = building
                end
            end
        end

        if closest_entity == nil then
            error("No entity at given coordinates.")
        end
        -- If the closest entity is a furnace, return the inventory of the furnace
        if closest_entity.type == "furnace" then
            local source = closest_entity.get_inventory(defines.inventory.furnace_source).get_contents()
            local output = closest_entity.get_inventory(defines.inventory.furnace_result).get_contents()
            -- Merge the two tables
            for k, v in pairs(output) do
                source[k] = (source[k] or 0) + v
            end
            return source
        end

        -- If the closest entity is an assembling machine, return the inventory of the furnace
        if closest_entity.type == "assembling-machine" then
            local source = closest_entity.get_inventory(defines.inventory.assembling_machine_input).get_contents()
            local output = closest_entity.get_inventory(defines.inventory.assembling_machine_output).get_contents()
            -- Merge the two tables
            for k, v in pairs(output) do
                source[k] = (source[k] or 0) + v
            end
            return source
        end

        return closest_entity.get_inventory(defines.inventory.chest).get_contents()
    end


    local player = game.players[player_index]
    if not player then
        error("Player not found")
    end

    if is_character_inventory then
        local inventory_items = get_player_inventory_items(player)

        if inventory_items then
            return dump(inventory_items)
        else
            error("Could not get player inventory")
        end
    else
        local inventory_items = get_inventory()

        if inventory_items then
            return dump(inventory_items)
        else
            error("\"Could not get inventory of entity at "..x..", "..y.."\"")
        end
    end
end