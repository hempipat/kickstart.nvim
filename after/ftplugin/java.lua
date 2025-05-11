local status, jdtls = pcall(require, 'jdtls')
if not status then
  return
end
local opt = vim.opt
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

-- local jdtls = require "jdtls"
-- Setup Workspace
local home = os.getenv 'HOME'
local workspace_path = home .. '/jdtls-workspace/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

local java_path17 = '~/.sdkman/candidates/java/17.0.15-tem'
local java_path17aarch64 = '/opt/'
local java_path21 = '~/.sdkman/candidates/java/21.0.7-tem'

-- Determine OS
local os_config = 'linux'
if vim.fn.has 'mac' == 1 then
  os_config = 'mac'
end

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- local on_attach = require("util.lsp").on_attach()
-- local on_attach = require("plugins.utils.utils").on_attach

-- Setup Testing and Debugging
local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. 'packages/java-test/extension/server/*.jar'), '\n'))
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. 'packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'), '\n'))

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms2g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
    '-jar',
    vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    home .. '/.local/share/nvim/mason/packages/jdtls/config_' .. os_config,
    '-data',
    workspace_dir,
  },
  root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
  on_exit = function(client)
    print 'jdtls is shutting down'
    client:stop()
  end,
  -- on_attach = on_attach,
  capabilities = capabilities,

  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = 'JavaSE-17',
            path = java_path17,
          },
        },
      },
      maven = {
        downloadSources = true,
      },
      -- Enable method signature help
      signatureHelp = {
        enabled = true,
      },
      -- Use the fernflower decompiler when using the javap command to decompile byte code back to java code
      contentProvider = {
        preferred = 'fernflower',
      },
      -- Setup automatical package import oranization on file save
      saveActions = {
        organizeImports = true,
      },
      -- Customize completion options
      completion = {
        -- When using an unimported static method, how should the LSP rank possible places to import the static method from
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.hamcrest.CoreMatchers.*',
          'org.junit.jupiter.api.Assertions.*',
          'java.util.Objects.requireNonNull',
          'java.util.Objects.requireNonNullElse',
          'org.mockito.Mockito.*',
        },
        -- Try not to suggest imports from these packages in the code action window
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.shaded.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
        },
        -- Set the order in which the language server should organize imports
        importOrder = {
          'java',
          'jakarta',
          'javax',
          'com',
          'org',
        },
      },
      sources = {
        -- How many classes from a specific package should be imported before automatic imports combine them all into a single import
        organizeImports = {
          starThreshold = 9999,
          staticThreshold = 9999,
        },
      },
      -- How should different pieces of code be generated?
      codeGeneration = {
        -- When generating toString use a json format
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        -- When generating hashCode and equals methods use the java 7 objects method
        hashCodeEquals = {
          useJava7Objects = true,
        },
        -- When generating code use code blocks
        useBlocks = true,
      },

      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all', -- literals, all, none
        },
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath 'config' .. '/lang_servers/intellij-java-google-style.xml',
          profile = 'GoogleStyle',
        },
      },
    },
    extendedClientCapabilities = extendedClientCapabilities,
  },
  init_options = {
    bundles = bundles,
  },
  on_attach = function()
    -- require('jdtls').setup_dap { hotcodereplace = 'auto' }
    jdtls.setup_dap { hotcodereplace = 'auto' }

    vim.keymap.set('n', '<leader>oi', function()
      jdtls.organize_imports()
    end, {
      desc = 'organize imports',
    })
    vim.keymap.set('n', '<leader>oa', function()
      jdtls.organize_imports()
      vim.lsp.buf.format()
    end, {
      desc = 'organize all',
    })

    vim.keymap.set('v', '<leader>jev', function()
      jdtls.extract_variable(true)
    end, {
      desc = 'java extract selected to variable',
      noremap = true,
    })
    vim.keymap.set('n', '<leader>jev', function()
      jdtls.extract_variable()
    end, {
      desc = 'java extract variable',
      noremap = true,
    })

    vim.keymap.set('v', '<leader>jeV', function()
      jdtls.extract_variable_all(true)
    end, {
      desc = 'java extract all selected to variable',
      noremap = true,
    })
    vim.keymap.set('n', '<leader>jeV', function()
      jdtls.extract_variable_all()
    end, {
      desc = 'java extract all to variable',
      noremap = true,
    })

    vim.keymap.set('n', '<leader>jec', function()
      jdtls.extract_constant()
    end, {
      desc = 'java extract constant',
      noremap = true,
    })
    vim.keymap.set('v', '<leader>jec', function()
      jdtls.extract_constant(true)
    end, {
      desc = 'java extract selected to constant',
      noremap = true,
    })

    vim.keymap.set('n', '<leader>jem', function()
      jdtls.extract_method()
    end, {
      desc = 'java extract method',
      noremap = true,
    })

    vim.keymap.set('v', '<leader>jem', function()
      jdtls.extract_method(true)
    end, {
      desc = 'java extract selected to method',
      noremap = true,
    })

    vim.keymap.set('n', '<leader>ot', function()
      local plugin = require 'jdtls.tests'
      plugin.goto_subjects()
    end, {
      desc = 'java open test',
      noremap = true,
    })

    vim.keymap.set('n', '<leader>ct', function()
      local plugin = require 'jdtls.tests'
      plugin.generate()
    end, {
      desc = 'java create test',
      noremap = true,
    })

    vim.keymap.set('n', '<leader>jdm', function()
      jdtls.test_nearest_method()
    end, { desc = 'java debug nearest test method' })

    vim.keymap.set('n', '<leader>jdc', function()
      jdtls.test_class()
    end, { desc = 'java debug nearest test class' })

    vim.keymap.set('n', '<leader>ju', function()
      jdtls.update_project_config()
    end, { desc = 'java update config' })

    vim.cmd [[ command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>) ]]

    vim.cmd [[ command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>) ]]

    vim.cmd [[ command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config() ]]

    vim.cmd [[ command! -buffer JdtBytecode lua require('jdtls').javap() ]]

    vim.cmd [[ command! -buffer JdtJol lua require('jdtls').jol() ]]

    vim.cmd [[ command! -buffer JdtJshell lua require('jdtls').jshell() ]]

    -- require("plugins.utils.utils").on_attach()
    -- on_attach(client, bufnr)
  end,
}

-- require("jdtls").start_or_attach(config)
jdtls.start_or_attach(config)
