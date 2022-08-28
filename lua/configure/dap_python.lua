local plugin = {}

plugin.core = {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        if not packer_plugins['nvim-dap'].loaded then
            vim.cmd [[packadd nvim-dap]]
        end
        local python_path = io.popen('which python')

        python_path = python_path:read("*all")
        python_path = string.gsub(python_path, "^(.-)%s*\n*$", "%1")
        require('dap-python').setup(python_path)
        require('dap').configurations.python = {
          {
            type = 'python';
            request = 'launch';
            name = "Launch file with venv";
            justMyCode = false;
            program = "${file}";
            pythonPath = python_path;
          },
        }
    end,

}

plugin.mapping = function()

end
return plugin
