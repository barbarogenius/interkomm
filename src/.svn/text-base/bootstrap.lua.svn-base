require 'yaml'

BOOT_PATH = "/etc/interkomm/interkomm.yml"
IKM_ENV = "production"

local function load_config(boot_path)
  local config_yml = io.open(boot_path, "r")
  local con = config_yml:read("*a")
  config_yml:close()
  local config = yaml.load(con)
return config
end

CONFIG = load_config(BOOT_PATH)

--package.path = CONFIG[IKM_ENV].package_path


