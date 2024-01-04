if vim.fn.has("mac") == 1 then
    vim.g.HOME_PATH = "/Users/" .. vim.fn.expand("$USER")
elseif vim.fn.has("unix") == 1 then
    vim.g.HOME_PATH = "/home/" .. vim.fn.expand("$USER")
else
    print("configure is only for mac or linux or WSL !")
    vim.g.HOME_PATH = " "
    return
end
vim.g.CONFIG = vim.g.HOME_PATH .. "/.sea.nvim"
vim.o.runtimepath = vim.o.runtimepath .. "," .. vim.g.CONFIG

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("core")
