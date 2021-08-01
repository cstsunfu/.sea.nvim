vim.g.HOME_PATH = ""
if vim.fn.has('mac') == 1 then
    vim.g.HOME_PATH = "/Users/"..vim.fn.expand('$USER')
elseif vim.fn.has('unix') == 1 then
    vim.g.HOME_PATH = "/home/"..vim.fn.expand("$USER")
else
    print("configure is only for mac or linux !")
end
vim.g.CONFIGURE = vim.g.HOME_PATH.."/.test.vim"
vim.o.runtimepath = vim.o.runtimepath..","..vim.g.CONFIGURE

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end
packer_ok, packer = pcall(require, "packer")

if not packer_ok then
    print('can not load packer.')
    return
end

packer.init {
}

require("core")

