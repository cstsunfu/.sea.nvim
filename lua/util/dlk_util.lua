-- this is only for the python package dlk https://github.com/cstsunfu/dlk
-- most of you may not care this
--
_G.get_content = function(s_start, s_end)
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end


_G.dlk_goto_configure = function()
    --NOTE: local current_line = vim.fn.getpos('.') equal to vim.api.nvim_win_get_cursor()
    local current_line = vim.api.nvim_win_get_cursor(0)
    vim.g._dlk_current_configure_line = (vim.api.nvim_buf_get_lines(0, current_line[1]-1, current_line[1], false)[1])
    vim.api.nvim_input("<esc>")
    vim.cmd("normal viBo")
    vim.api.nvim_input("<esc>")
    vim.fn.search(':', "bW")
    local module_line = vim.fn.getpos('.')
    vim.g._dlk_current_module_line = vim.api.nvim_buf_get_lines(0, module_line[2]-1, module_line[2], false)[1]
    pcall(vim.api.nvim_win_set_cursor, 0, current_line)
    vim.cmd[[ 
python3 << EOF
import os
import re
dlk_base = vim.vars['_dlk_base_dir']
module_config_dir_map = {
    "task": "dlk/configures/tasks",
    "manager": "dlk/configures/managers",
    "callback": "dlk/configures/core/callbacks",
    "datamodule": "dlk/configures/data/datamodules",
    "imodel": "dlk/configures/core/imodels",
    "model": "dlk/configures/core/models",
    "optimizer": "dlk/configures/core/optimizers",
    "scheduler": "dlk/configures/core/schedulers",
    "initmethod": "dlk/configures/core/initmethods",
    "loss": "dlk/configures/core/losses",
    "encoder": "dlk/configures/core/layers/encoders",
    "decoder": "dlk/configures/core/layers/decoders",
    "embedding": "dlk/configures/core/layers/embeddings",
    "module": "dlk/configures/core/modules",
    "processor": "dlk/configures/data/processors",
    "subprocessor": "dlk/configures/data/subprocessors",
    "postprocessor": "dlk/configures/data/postprocessors",
}
config_name_line = vim.vars["_dlk_current_configure_line"]
module_name_line = vim.vars["_dlk_current_module_line"]

def _get_config_path(config_name_line, module_name_line):

    if "_base" not in config_name_line:
        return "", "You must move your cursor on `_base`"
    _sp_position = config_name_line.find(":")
    if _sp_position == -1:
        return "", f"Not a valid line '{config_name_line}'"
    config_name_line = config_name_line[_sp_position+1:].strip()
    config_quoted = '"'
    if config_name_line.startswith("'"):
        config_quoted = "'"
    elif not config_name_line.startswith('"'):
        return "", "Configure name must be quoted by ' or \""
    module_quoted = '"'
    if module_name_line.startswith("'"):
        module_quoted = "'"
    elif not module_name_line.startswith('"'):
        return "", "Module name must be quoted by ' or \""

    try:
        config_name = re.search(rf"{config_quoted}([\w#@]*){config_quoted}", config_name_line).group(1)
    except:
        return "", f"There is not a valid config name in {config_name_line}. Try go to source."
    try:
        module_name = re.search(rf"{module_quoted}([\w#@]*){module_quoted}", module_name_line).group(1)
    except:
        return "", f"There is not a valid module name in {module_name_line}. Try go to source."

    config_name = config_name
    module_name = module_name.split("@")[0]
    try:
        module_dir = module_config_dir_map[module_name]
    except:
        return "", f"{module_name} is not a valid module name. Try go to source."
    return os.path.join(dlk_base, module_dir, config_name.strip()+'.hjson'), f"Jump to config `{os.path.join(dlk_base, module_dir, config_name.strip()+'.hjson')}`"


config_path, message = _get_config_path(config_name_line.strip(), module_name_line.strip())

vim.vars["_dlk_get_configure_path_status"] = "Success"

if config_path:
    if not os.path.exists(config_path):
        message = f"{config_path} is not exists"
        vim.vars["_dlk_get_configure_path_status"] = "Failed"
else:
    vim.vars["_dlk_get_configure_path_status"] = "Failed"
vim.vars["_dlk_get_configure_path"]  = config_path.replace("#", "\#")
vim.vars["_dlk_get_configure_message"]  = message
EOF
    ]]
    if vim.g._dlk_get_configure_path_status == "Failed" then
        vim.notify(vim.g._dlk_get_configure_message, vim.lsp.log_levels.ERROR, {
            title = vim.g._dlk_get_configure_path_status,
            icon = " DLK:",
            timeout = 2000,
        })
        local timer = vim.loop.new_timer()
        timer:start(300, 0, vim.schedule_wrap(function()
            vim.cmd("lua _G.dlk_goto_source()")   --set VertSplit color to black
        end))
    else
        vim.notify(vim.g._dlk_get_configure_message, vim.lsp.log_levels.INFO, {
            title = vim.g._dlk_get_configure_path_status,
            icon = " DLK:",
            timeout = 3000,
        })
        vim.cmd("e "..vim.g._dlk_get_configure_path)
    end
end


_G.dlk_goto_source = function()
    local current_line = vim.api.nvim_win_get_cursor(0)
    vim.g._dlk_current_configure_line = (vim.api.nvim_buf_get_lines(0, current_line[1]-1, current_line[1], false)[1])
    vim.api.nvim_input("<esc>")
    vim.api.nvim_input("<esc>")
    vim.cmd("normal viBo")
    vim.api.nvim_input("<esc>")
    local module_name_line_pos = vim.fn.search(':', "bW")
    vim.g._dlk_get_current_module_name_in_file = true
    if module_name_line_pos == 0 then
        vim.g._dlk_get_current_module_name_in_file = false
        vim.g._dlk_current_module_line = vim.fn.expand("%:p")
    else
        local module_line = vim.fn.getpos('.')
        vim.g._dlk_current_module_line = vim.api.nvim_buf_get_lines(0, module_line[2]-1, module_line[2], false)[1]
    end
    pcall(vim.api.nvim_win_set_cursor, 0, current_line)
    vim.cmd[[ 
python3 << EOF
import os
import re
dlk_base = vim.vars['_dlk_base_dir']
module_source_dir_map = {
    "task": "dlk/tasks",
    "manager": "dlk/managers",
    "callback": "dlk/core/callbacks",
    "imodel": "dlk/core/imodels",
    "model": "dlk/core/models",
    "module": "dlk/core/modules",
    "optimizer": "dlk/core/optimizers",
    "scheduler": "dlk/core/schedulers",
    "initmethod": "dlk/core/initmethods",
    "loss": "dlk/core/losses",
    "encoder": "dlk/core/layers/encoders",
    "decoder": "dlk/core/layers/decoders",
    "embedding": "dlk/core/layers/embeddings",
    "datamodule": "dlk/data/datamodules",
    "processor": "dlk/data/processors",
    "subprocessor": "dlk/data/subprocessors",
    "postprocessor": "dlk/data/postprocessors",
}

complex_name_map = {
    "losses": "loss"
}
config_name_line = vim.vars["_dlk_current_configure_line"]
module_name_line = vim.vars["_dlk_current_module_line"]
module_name_infile = vim.vars["_dlk_get_current_module_name_in_file"]

def _get_source_path(config_name_line, module_name_line):

    if "_name" not in config_name_line and "_base" not in config_name_line:
        return "", "You must move your cursor on `_name` or `_base`"
    _sp_position = config_name_line.find(":")
    if _sp_position == -1:
        return "", f"Not a valid line '{config_name_line}'"
    config_name_line = config_name_line[_sp_position+1:].strip()
    config_quoted = '"'
    if config_name_line.startswith("'"):
        config_quoted = "'"
    elif not config_name_line.startswith('"'):
        return "", "Configure name must be quoted by ' or \""
    module_name = ""
    if module_name_infile:
        module_quoted = '"'
        if module_name_line.startswith("'"):
            module_quoted = "'"
        elif not module_name_line.startswith('"'):
            return "", "Module name must be quoted by ' or \""
        try:
            module_name = re.search(rf"{module_quoted}([\w#@]*){module_quoted}", module_name_line).group(1)
        except:
            return "", f"There is not a valid module name in {module_name_line}"
    else:
        module_name = os.path.dirname(module_name_line)
        module_name = os.path.split(module_name)[-1]
        module_name = complex_name_map.get(module_name, module_name[:-1]) # most case only remove the 's' in the end name
    try:
        config_name = re.search(rf"{config_quoted}([\w#@]*){config_quoted}", config_name_line).group(1)
    except:
        return "", f"There is not a valid config name in {config_name_line}."

    config_name = config_name.split("@")[0]
    module_name = module_name.split("@")[0]
    try:
        module_dir = module_source_dir_map[module_name]
    except:
        return "", f"{module_name} is not a valid module name"
    return os.path.join(dlk_base, module_dir, config_name.strip()+'.py'), f"Jump to source `{os.path.join(dlk_base, module_dir, config_name.strip()+'.py')}`"


source_path, message = _get_source_path(config_name_line.strip(), module_name_line.strip())

vim.vars["_dlk_get_source_path_status"] = "Success"

if source_path:
    if not os.path.exists(source_path):
        message = f"{source_path} is not exists"
        vim.vars["_dlk_get_source_path_status"] = "Failed"
else:
    vim.vars["_dlk_get_source_path_status"] = "Failed"
vim.vars["_dlk_get_source_path"]  = source_path.replace("#", "\#")
vim.vars["_dlk_get_source_message"]  = message
EOF
    ]]
    if vim.g._dlk_get_source_path_status == "Failed" then
        vim.notify(vim.g._dlk_get_source_message, vim.lsp.log_levels.ERROR, {
            title = vim.g._dlk_get_source_path_status,
            icon = "DLK  :",
            timeout = 2000,
        })
    else
        vim.notify(vim.g._dlk_get_source_message, vim.lsp.log_levels.INFO, {
            title = vim.g._dlk_get_source_path_status,
            icon = "DLK  :",
            timeout = 2000,
        })
        vim.cmd("e "..vim.g._dlk_get_source_path)
    end
end

vim.cmd[[ 
    autocmd FileType hjson nmap guc :lua _G.dlk_goto_configure()<cr>
]]
vim.cmd[[ 
    autocmd FileType hjson nmap gud :lua _G.dlk_goto_source()<cr>
]]
