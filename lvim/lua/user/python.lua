-- Python-specific configuration for LunarVim
-- This file contains all Python development tools and settings

local M = {}

function M.setup()
  -- Modern Python formatters using conform.nvim (safer approach)
  local status_ok, conform = pcall(require, "conform")
  if status_ok then
    conform.setup({
      formatters_by_ft = {
        python = { "black", "isort" },
      },
    })
  else
    -- Fallback to manual formatter setup if conform is not available
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.py",
      callback = function()
        vim.cmd("silent! !black --quiet %")
        vim.cmd("silent! !isort --quiet %")
        vim.cmd("edit!")
      end,
    })
  end

  -- Use Mason to ensure tools are installed
  local mason_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
  if mason_ok then
    mason_tool_installer.setup({
      ensure_installed = {
        "black",      -- Python formatter
        "isort",      -- Import sorting
        "flake8",     -- Linting
        "mypy",       -- Type checking
        "bandit",     -- Security linting
        "debugpy",    -- Python debugger
      },
    })
  end

  -- Enhanced LSP settings for Python
  vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
  local opts = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          autoImportCompletions = true,
        }
      }
    }
  }
  require("lvim.lsp.manager").setup("pyright", opts)

  -- Setup DAP (Debug Adapter Protocol) for Python
  local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
  pcall(function()
    require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
    -- Alternative: require("dap-python").setup("python")
  end)

  -- Configure test runner with multiple framework support
  pcall(function()
    require("dap-python").test_runner = "pytest"
  end)

  -- Python-specific Treesitter configuration
  vim.list_extend(lvim.builtin.treesitter.ensure_installed, {
    "python",
    "toml",        -- For pyproject.toml
    "yaml",        -- For .github workflows and configs
    "json",        -- For package.json and configs
    "dockerfile",  -- For containerized Python apps
  })

  -- Python-specific settings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      -- Set Python-specific options
      vim.opt_local.colorcolumn = "88"  -- Black's line length
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
      
      -- Enable format on save for Python files
      lvim.format_on_save.pattern = { "*.py", "*.lua" }
    end,
  })

  -- Enhanced key mappings for Python development
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "python" },
    callback = function()
      -- Testing mappings
      lvim.builtin.which_key.mappings["t"] = {
        name = "Test",
        t = { "<cmd>lua require('dap-python').test_method()<cr>", "Test Method" },
        c = { "<cmd>lua require('dap-python').test_class()<cr>", "Test Class" },
        f = { "<cmd>!python -m pytest %<cr>", "Test File" },
        a = { "<cmd>!python -m pytest<cr>", "Test All" },
        v = { "<cmd>!python -m pytest -v<cr>", "Test Verbose" },
        x = { "<cmd>!python -m pytest -x<cr>", "Test Stop on Fail" },
      }
      
      -- Debug mappings
      lvim.builtin.which_key.mappings["d"] = {
        name = "Debug",
        b = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle Breakpoint" },
        c = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
        i = { "<cmd>lua require('dap').step_into()<cr>", "Step Into" },
        o = { "<cmd>lua require('dap').step_over()<cr>", "Step Over" },
        r = { "<cmd>lua require('dap').repl.open()<cr>", "Open REPL" },
        t = { "<cmd>lua require('dap-python').test_method()<cr>", "Debug Test Method" },
        f = { "<cmd>lua require('dap-python').test_class()<cr>", "Debug Test Class" },
      }
      
      -- Visual mode debug mapping
      lvim.builtin.which_key.vmappings["d"] = {
        name = "Debug",
        s = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug Selection" },
      }
      
      -- Python-specific utilities
      lvim.builtin.which_key.mappings["p"] = {
        name = "Python",
        i = { "<cmd>!python -m pip install -r requirements.txt<cr>", "Install Requirements" },
        f = { "<cmd>!python -m black %<cr>", "Format with Black" },
        s = { "<cmd>!python -m isort %<cr>", "Sort Imports" },
        l = { "<cmd>!python -m flake8 %<cr>", "Lint File" },
        t = { "<cmd>!python -m mypy %<cr>", "Type Check" },
        r = { "<cmd>!python %<cr>", "Run File" },
        v = { "<cmd>!python --version<cr>", "Python Version" },
        e = { "<cmd>!python -m venv .venv<cr>", "Create Virtual Env" },
      }
    end,
  })

  -- Configure Python virtual environment detection
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local venv_paths = {
        ".venv/bin/python",
        "venv/bin/python", 
        ".env/bin/python",
        "env/bin/python"
      }
      
      for _, path in ipairs(venv_paths) do
        if vim.fn.filereadable(path) == 1 then
          vim.g.python3_host_prog = vim.fn.getcwd() .. "/" .. path
          break
        end
      end
    end,
  })
end

-- Plugin configuration for modern Python development
M.plugins = {
  -- Modern formatting with conform.nvim
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "black", "isort" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- Mason tool installer for Python tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "black",
          "isort", 
          "flake8",
          "mypy",
          "bandit",
          "debugpy",
          "pyright",
        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },

  -- Core debugging support
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
  },
  
  -- Enhanced testing support
  {
    "nvim-neotest/neotest",
    ft = "python",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",  -- Required dependency for neotest
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",  -- Python adapter
    },
    config = function()
      -- Safely setup neotest to avoid deprecation warnings
      local status_ok, neotest = pcall(require, "neotest")
      if not status_ok then
        return
      end
      
      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
            python = "python",
          }),
        },
        -- Configure discovery and running options
        discovery = {
          enabled = true,
          concurrent = 1,
        },
        running = {
          concurrent = true,
        },
        summary = {
          enabled = true,
          expand_errors = true,
        },
      })
    end,
  },
  
  -- Python REPL integration
  {
    "Vigemus/iron.nvim",
    ft = "python",
    config = function()
      local iron = require("iron.core")
      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = {"python"},
              format = require("iron.fts.common").bracketed_paste,
            },
          },
          repl_open_cmd = require("iron.view").right(40),
        },
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_mark = "<space>sm",
          toggle_repl = "<space>rs",
          interrupt = "<space>s<space>",
        },
      })
    end,
  },
  
  -- Enhanced Python text objects and motions
  {
    "jeetsukumaran/vim-pythonsense",
    ft = "python",
  },
  
  -- Jupyter notebook support
  {
    "goerz/jupytext.vim",
    ft = { "python", "markdown" },
  },
  
  -- Virtual environment management
  {
    "AckslD/swenv.nvim",
    ft = "python",
    config = function()
      require("swenv").setup({
        get_venvs = function(venvs_path)
          return require("swenv.api").get_venvs(venvs_path)
        end,
        venvs_path = vim.fn.expand("~/virtualenvs"),
        post_set_venv = function()
          vim.cmd("LspRestart")
        end,
      })
    end,
  },
  
  -- Python docstring generator
  {
    "danymat/neogen",
    ft = "python",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({
        languages = {
          python = {
            template = {
              annotation_convention = "google_docstrings",
            },
          },
        },
      })
    end,
  },
}

-- Custom requirements.txt file detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "requirements*.txt", "requirements*.in", "Pipfile", "pyproject.toml", "setup.py", "setup.cfg" },
  callback = function()
    local filename = vim.fn.expand("%:t")
    if string.match(filename, "requirements.*%.txt") or string.match(filename, "requirements.*%.in") then
      vim.bo.filetype = "requirements"
      vim.bo.commentstring = "# %s"
    elseif filename == "Pipfile" then
      vim.bo.filetype = "toml"
    elseif filename == "pyproject.toml" or filename == "setup.cfg" then
      vim.bo.filetype = "toml"
    elseif filename == "setup.py" then
      vim.bo.filetype = "python"
    end
  end,
})

return M
