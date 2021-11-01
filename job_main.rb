require "csv"
require "json"
require "date"

CONFIG = JSON.parse(File.read("./config.json"))
NODE_DIR = CONFIG["node_dir"]
DEFAULT_COUNT = CONFIG["default_count"] || 100
HEADER = CONFIG["header"]
NODES = CONFIG["nodes"]
PARENTS = CONFIG["parents"]
HOST_NAME = CONFIG["hostname"]
CHILDREN_DIR = CONFIG["children_dir"]
PARENT_SYNC_INTERVAL = CONFIG["parent_sync_interval"]

$table = []

Dir.glob("./jobs/*.rb").each do |fp|
  require(fp)
  puts fp
end

loop {
  nw = DateTime.now
  $table.each do |v|
    dt = v.ignite_time
    v.call if dt > nw
    puts "call #{v.name}"
  end
  sleep(1)
}
