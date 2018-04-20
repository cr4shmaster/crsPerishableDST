-- More information here: https://sites.google.com/view/cr4shmaster/perishable-ds-dst

name = "Perishable v2.1.2.2"
description = "This mod is required by other mods that are using 'perishable.lua'."
author = "cr4shmaster"
version = "2.1.2.2"
forumthread = ""
api_version = 10
all_clients_require_mod = true
client_only_mod = false
dst_compatible = true
icon_atlas = "modicon.xml"
icon = "modicon.tex"
server_filter_tags = {"perishable"}
-- priority = 10.00

configuration_options = {
    {name = "cfgTestCheck", label = "Installed", options = {{description = "Yes", data = true}}, default = true,},
}
