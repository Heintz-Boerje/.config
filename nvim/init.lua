-- NEOVIM OPTIONS
-- These are setttings internal to neovim
-- To set an options just add it in the option table and restart neovim.
local options = {
--	insertmode=true,
	showtabline=0, -- always show the tabline
	clipboard="unnamedplus", -- I should look more into what this does
	autochdir=true, -- automatically cd into the directory of the file being edited
	wrap=true, -- wrap long lines
	breakindent=true, -- preserve indentation in wrapped text
	number=true, -- that set line numbers
	numberwidth=4, -- number column width
	termguicolors=true, -- termguicolors
	cursorline=true, -- highlight the cursorline
	cursorlineopt="both", -- I have to figure out what this does
	icon=true, -- I'm not really sure of this
	mouse="a", -- enable mouse
	smarttab=true, --smarttab
	autoindent=true, -- autoindentation
	smartindent=true, -- smartindent
	cindent=true, -- special indent for C
	lisp=true, --lisp mode
	guifont= "HeintzCodeNerdFont Nerd Font:h11" -- font to be used with gui
	}

for k,v in pairs(options) do
	vim.opt[k] = v
end

-- This is the KEYMAP SECTION
-- your mappings don't have to be here but putting them here to keeps the config tidy
vim.g.mapleader = " "
local wk = require("which-key")
wk.register({p={"<cmd>put<cr>", "paste"}},{prefix = "<leader>"})
wk.register({f={"<cmd>NvimTreeToggle<cr>", "File explorer"}}, {prefix = "<leader>"})
wk.register({["<C-v>"]={"<cmd>put<cr>", "paste"}}, {mode = "i"})
wk.register({t={ name="Terminal", f={"<cmd>ToggleTerm direction=float<cr>" , "floating terminal"},
h={"<cmd>ToggleTerm direction=horizontal<cr>", "horizontal terminal"},
s={"<cmd>ToggleTermSendCurrentLine<cr>", "send current line to terminal"},
v={"<cmd>ToggleTermSendVisualSelection<cr>", "send selection to terminal"},}}, {prefix="<leader>"})
wk.register({["/"]={"", "Comment line"}})
wk.register({c={"", "Colorpicker insert"}})
-- end of keymap section]]

-- plugin configuration
require ('packer').startup(function(use)
	-- bootstrap packer
	use 'wbthomason/packer.nvim'
	-- keymaps cheatsheet and modifier
	use {'folke/which-key.nvim',
	config = function()
		require("which-key").setup {
		key_labels = {
		["<space>"] = "SPC",
		["<cr>"] = "RET",
		["<tab>"] = "TAB",
		},
		window = {
			border="single",
		},
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}
	}
	end}

	-- file explorer	
	use {
  		'kyazdani42/nvim-tree.lua',
	}

	-- terminal
	use {"akinsho/toggleterm.nvim"}

	-- completion
	use {"hrsh7th/nvim-cmp"}
	use {"hrsh7th/cmp-buffer"}

	-- colorizer
	use {"NvChad/nvim-colorizer.lua"}

	-- better syntax highlighting
	use {'nvim-treesitter/nvim-treesitter'}

	-- tabline
	use {"akinsho/bufferline.nvim"}

	-- statusline
	use {"nvim-lualine/lualine.nvim"}

	-- colorscheme
	--use {"navarasu/onedark.nvim"}
	use {"rose-pine/nvim"}

	-- icon
	use 'yamatsum/nvim-nonicons'
    	use 'kyazdani42/nvim-web-devicons'
	
	-- some sugar
	use 'jghauser/mkdir.nvim'

end)

-- PLUGIN CONFIGURATION
-- All plugins are configured in this section except for which-key which is in the keymap section.
-- Nvim Tree
require("nvim-tree").setup({
	filters = {
		dotfiles = true,
	}
})

-- Toggle Term
require("toggleterm").setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "float" then
			return 30
		end
	end,
	winbar = {
		enabled = false,
		name_formatter = function(term)
			return term.name
		end},
	float_opts = {
		border = 'shadow'}})

-- Completion
local cmp = require("cmp")

cmp.setup({
	enabled = function()
	-- disable completion in comments
	local context = require'cmp.config.context'
		if vim.api.nvim_get_mode().mode == 'c' then
        		return true
      		else
        		return not context.in_treesitter_capture("comment") 
          	and not context.in_syntax_group("Comment")
      		end
    	end,
	mapping = {
    		["<Tab>"] = cmp.mapping(function(fallback)
      	-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
      			if cmp.visible() then
        			local entry = cmp.get_selected_entry()
				if not entry then
	  				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				else
	  				cmp.confirm()
				end
      			else
        			fallback()
			end
    		end, {"i","s","c",}),
  	},
	sources = {
		{ name = 'buffer'},
		{name = 'path'},
	},
})

-- Colorizer
require("colorizer").setup({
	DEFAULT_OPTIONS = {
		RRGGBBAA = true;
		mode = 'virtualtext';
	}
})

-- Colorscheme
local time = os.date("*t")

-- When its 7am or is equal or more than 9pm = onedark
if time.hour < 7 or time.hour >= 21 then
	vim.o.background="dark"
else
	vim.o.background="light"
end
vim.cmd [[ colorscheme rose-pine ]] 

-- Treesitter
require('nvim-treesitter.configs').setup({
	indent = {
		enable = true
	},
	auto_install = true,
	highlight = {
		enable = true,
	}
})

-- Bufferline
require('bufferline').setup{}

-- Statusline
require('lualine').setup {}

-- Icons
local icons = require "nvim-nonicons"

icons.get("file")

-- Plugin config end]]

-- This autocommand update your plugins everytime this file is saved.
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]]
