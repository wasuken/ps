require "csv"
require "json"
require "net/http"
require "uri"

# 設定ファイル
CONFIG = JSON.parse(File.read("./config.json"))
NODE_DIR = CONFIG["node_dir"]
DEFAULT_COUNT = CONFIG["default_count"] || 100
HEADER = CONFIG["header"]
NODES = CONFIG["nodes"]
PARENTS = CONFIG["parents"]
HOST_NAME = CONFIG["hostname"]
CHILDREN_DIR = CONFIG["children_dir"]
INTERVAL = CONFIG["interval"]

def post_csv(dir_path)
  Dir.glob("#{dir_path}/**/*.csv").each do |csv_path|
    path = csv_path
    path.gsub("^#{dir_path}", "").gsub(/\.csv$/, "")
    csv_data = CSV.read(csv_path)[-DEFAULT_COUNT..-1]
    PARENTS.each do |u|
      uri = URI(u)
      req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
      req.body = { header: HEADER, data: csv_data, path: path }.to_json
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
    end
  end
end

# 直下のnode CSV情報送信
def post_current_nodes_to_parent()
  post_csv(NODE_DIR)
end

# children CSV情報送信
def post_children_to_parent()
  post_csv(CHILDREN_DIR)
end

# メインループ
loop {
  post_children_to_parent
  post_children_to_parent
  sleep(INTERVAL)
}
