-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use('wbthomason/packer.nvim')
    use("ellisonleao/gruvbox.nvim" )
    -- use('nvim-tree/nvim-web-devicons')
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})
    use('nvim-treesitter/playground')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('tpope/vim-commentary')
    use('preservim/nerdtree')
    use('itchyny/lightline.vim')
    use('SirVer/ultisnips')
    use('jiangmiao/auto-pairs')
    use('itchyny/vim-gitbranch')
    use('habamax/vim-asciidoctor')
    -- use('inkarkat/vim-SyntaxRange')
    -- use('hiphish/rainbow-delimiters.nvim')
    use('junegunn/fzf', { run = ':fzf#install()'} )
    use('junegunn/fzf.vim')
    use('rhysd/vim-grammarous')
    -- use('dense-analysis/ale')
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }
    -- use {
    --     'nvim-telescope/telescope.nvim', tag = '0.1.2',
    --     -- or                            , branch = '0.1.x',
    --     requires = { {'nvim-lua/plenary.nvim'} }
    -- }
end)
