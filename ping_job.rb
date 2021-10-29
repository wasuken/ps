require "net/ping"
require "json"
require "csv"
require "date"

CONFIG = JSON.parse(File.read("./config.json"))
NODE_DIR = CONFIG["node_dir"]

def logging_ping(node)
  check = Net::Ping::External.new(node)
  d = DateTime.now
  ndf = d.strftime
  path = "./#{NODE_DIR}/#{node}.csv"
  unless File.exists?(path)
    header = CONFIG['header']
    CSV.open(path, "wb") do |csv|
      csv << header
    end
  end

  CSV.open(path, "a") do |csv|
    csv << [node, check.ping?, check.duration, ndf]
  end
end

loop {
  CONFIG["nodes"].each do |node|
    name = node["name"]
    logging_ping(name)
  end
  sleep 2
}
