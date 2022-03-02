obs = obslua

path_input = ""
delimiter = ""
source_output_one = ""
source_output_two = ""
interval = 1000

function update_output()
    local inputFile = io.open(path_input, "r")
    if inputFile == nil then
        print("Input file did not exist: " .. path_input)
        return
    end
    local inputString = inputFile:read()
    inputFile:close()
    if inputString == nil then
        return
    end

    local outputArray1 = {}
    local outputArray2 = {}
    local hasSplit = false
    for match in string.gmatch(inputString, "([^%s]+)") do
        if match == delimiter then
            hasSplit = true
        else
            if hasSplit == false then
                table.insert(outputArray1, match)
            else
                table.insert(outputArray2, match)
            end
        end
    end
    local outputString1 = table.concat(outputArray1, " ")
    local outputString2 = table.concat(outputArray2, " ")

    local outputSource1 = obs.obs_get_source_by_name(source_output_one)
    if outputSource1 ~= nil then
        local outputSource1Settings = obs.obs_source_get_settings(outputSource1)
        obs.obs_data_set_string(outputSource1Settings, "text", outputString1)
        obs.obs_source_update(outputSource1, outputSource1Settings)
        obs.obs_data_release(outputSource1Settings)
        obs.obs_source_release(outputSource1)
    end

    local outputSource2 = obs.obs_get_source_by_name(source_output_two)
    if outputSource2 ~= nil then
        local outputSource2Settings = obs.obs_source_get_settings(outputSource2)
        obs.obs_data_set_string(outputSource2Settings, "text", outputString2)
        obs.obs_source_update(outputSource2, outputSource2Settings)
        obs.obs_data_release(outputSource2Settings)
        obs.obs_source_release(outputSource2)
    end
end

function script_description()
    return "Splits a text file into two text sources, split on a given delimiter."
end


function script_update(settings)
    path_input = obs.obs_data_get_string(settings, "splitter_path_input")
    delimiter = obs.obs_data_get_string(settings, "splitter_delimiter")
    source_output_one = obs.obs_data_get_string(settings, "splitter_source_output_one")
    source_output_two = obs.obs_data_get_string(settings, "splitter_source_output_two")
    interval = obs.obs_data_get_int(settings, "splitter_interval")
    update_output()
    obs.timer_remove(update_output)
    obs.timer_add(update_output, interval)
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_path(props, "splitter_path_input", "Input Path", obs.OBS_PATH_FILE, "Text File (*.txt)", NULL)
    obs.obs_properties_add_text(props, "splitter_delimiter", "Delimiter Word", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "splitter_source_output_one", "Output Source 1", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "splitter_source_output_two", "Output Source 2", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_int(props, "splitter_interval", "Interval (ms)", 100, 5000, 100)
    return props
end

function script_defaults(settings)
    obs.obs_data_set_default_string(settings, "splitter_delimiter", " - ")
    obs.obs_data_set_default_int(settings, "splitter_interval", 1000)
    obs.obs_data_set_default_string(settings, "splitter_source_output_one", "")
    obs.obs_data_set_default_string(settings, "splitter_source_output_two", "")
end
