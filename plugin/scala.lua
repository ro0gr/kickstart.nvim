vim.pack.add {
  'https://github.com/scalameta/nvim-metals',
  'https://github.com/nvim-lua/plenary.nvim',
}

-- Isolated Java Resolver for Metals & asdf
local function setup_java_environment()
  local java_version = "openjdk-17.0.2"
  local handle = io.popen("asdf where java " .. java_version .. " 2>/dev/null")
  local java_home = (handle:read("*a") or ""):gsub("\n", "")
  handle:close()

  if java_home ~= "" then
    -- Prepend Java bin to PATH to bypass broken asdf shims for this session
    local java_bin = java_home .. "/bin"
    vim.env.JAVA_HOME = java_home
    vim.env.PATH = java_bin .. ":" .. vim.env.PATH
    return java_home
  end
  return nil
end

local java_home = setup_java_environment()

local metals_config = require('metals').bare_config()

-- Project specific settings from .jvmopts and bitbucket-pipelines.yml
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  showInferredType = true,
  enableSemanticHighlighting = true,
  -- Pass JVM memory settings from .jvmopts
  serverProperties = { "-Xmx4G", "-Xss16M", "-XX:MaxMetaspaceSize=512M" },
}

if java_home then
  metals_config.settings.javaHome = java_home
end

metals_config.init_options.statusBarProvider = "on"

-- Setup simple statusline integration for Metals
local metals_status = ""
local function update_statusline()
  local status = require("metals").status()
  if status and status ~= "" then
    metals_status = " [" .. status .. "]"
  else
    metals_status = ""
  end
  vim.cmd("redrawstatus")
end

metals_config.on_status = update_statusline

metals_config.on_attach = function(client, bufnr)
  -- Enable inlay hints if supported by Neovim version
  if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

-- Create the autocommand for Scala/Java files to start Metals
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

-- Global function for statusline
_G.get_metals_status = function()
  return metals_status
end

-- Inject into default statusline
if not vim.opt.statusline:get():find("get_metals_status") then
  vim.opt.statusline:append("%{v:lua.get_metals_status()}")
end
