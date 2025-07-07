-- Java and Spring Boot configuration for LunarVim
-- This file contains all Java development tools and Spring Boot specific settings

local M = {}

function M.setup()
  -- Enable LunarVim's built-in Java support
  -- Make sure JDTLS is not in the skipped servers list
  if lvim.lsp.automatic_configuration.skipped_servers then
    lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
      return server ~= "jdtls"
    end, lvim.lsp.automatic_configuration.skipped_servers)
  end

  -- Java-specific Treesitter configuration
  vim.list_extend(lvim.builtin.treesitter.ensure_installed, {
    "java",
    "yaml",        -- For application.yml
    "properties",  -- For application.properties
    "xml",         -- For pom.xml, web.xml
    "sql",         -- For JPA/Hibernate queries
    "dockerfile",  -- For containerized Spring Boot apps
    "json",        -- For package.json and configs
  })

  -- Java-specific settings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
      -- Set Java-specific options
      vim.opt_local.colorcolumn = "120"  -- Standard Java line length
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
    end,
  })

  -- Enhanced key mappings for Java/Spring Boot development
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "java" },
    callback = function()
      -- Maven/Gradle build mappings
      lvim.builtin.which_key.mappings["m"] = {
        name = "Maven/Build",
        c = { "<cmd>!mvn clean compile<cr>", "Maven Clean Compile" },
        t = { "<cmd>!mvn test<cr>", "Maven Test" },
        p = { "<cmd>!mvn package<cr>", "Maven Package" },
        i = { "<cmd>!mvn clean install<cr>", "Maven Install" },
        r = { "<cmd>!mvn spring-boot:run<cr>", "Spring Boot Run" },
        s = { "<cmd>!mvn spring-boot:start<cr>", "Spring Boot Start" },
        d = { "<cmd>!mvn dependency:tree<cr>", "Dependency Tree" },
        l = { "<cmd>!mvn clean<cr>", "Maven Clean" },
        -- Gradle alternatives
        gc = { "<cmd>!./gradlew build<cr>", "Gradle Build" },
        gt = { "<cmd>!./gradlew test<cr>", "Gradle Test" },
        gr = { "<cmd>!./gradlew bootRun<cr>", "Gradle Boot Run" },
      }
      
      -- Java-specific utilities
      lvim.builtin.which_key.mappings["j"] = {
        name = "Java/Spring",
        r = { "<cmd>!java %<cr>", "Run Java File" },
        c = { "<cmd>!javac %<cr>", "Compile Java File" },
        f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format File" },
        i = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Actions" },
        -- Spring Boot specific
        g = { "<cmd>!spring init --dependencies=web,data-jpa,mysql,validation .<cr>", "Generate Spring Project" },
        a = { "<cmd>!curl -s http://localhost:8080/actuator/health | jq<cr>", "Health Check" },
        e = { "<cmd>!curl -s http://localhost:8080/actuator/env | jq<cr>", "Environment" },
        l = { "<cmd>!tail -f logs/spring.log<cr>", "View Logs" },
      }
    end,
  })

  -- Auto-detect Spring Boot projects
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local spring_indicators = {
        "pom.xml",
        "build.gradle",
        "src/main/java",
        "src/main/resources/application.properties",
        "src/main/resources/application.yml"
      }
      
      for _, indicator in ipairs(spring_indicators) do
        if vim.fn.filereadable(indicator) == 1 or vim.fn.isdirectory(indicator) == 1 then
          -- Set Spring Boot project variables
          vim.g.spring_boot_project = true
          break
        end
      end
    end,
  })
end

-- Simple plugin configuration for Java development
M.plugins = {
  -- Additional Java development tools
  {
    "mfussenegger/nvim-dap",
    ft = "java",
  },
  
  -- Spring Boot specific file support
  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = { "yaml", "yml" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      pcall(function()
        require("telescope").load_extension("yaml_schema")
      end)
    end,
  },
}

return M
