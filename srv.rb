require "sinatra"
require "sinatra/reloader"
require "json"
require "csv"

CONFIG = JSON.parse(File.read("./config.json"))
NODE_DIR = CONFIG["node_dir"]
DEFAULT_COUNT = CONFIG["default_count"] || 100
HEADER = CONFIG["header"]
NODES = CONFIG["nodes"]
PARENTS = CONFIG["parents"]
HOST_NAME = CONFIG["hostname"]
CHILDREN_DIR = CONFIG["children_dir"]
INTERVAL = CONFIG["interval"]
AUTH_TOKEN = CONFIG["auth_token"]

ERROR_MAP = {
  "900": {
    status: 900,
    msg: "Invalid parameter.",
  },
  "901": {
    status: 901,
    msg: "Auth error.",
  },
}

configure do
  set :bind, "0.0.0.0"
  set :port, 3000
  set :environment, :development
  register Sinatra::Reloader
  also_reload "./*.rb"
end

get "/api/v1/nodes" do
  content_type :json
  data = CONFIG["nodes"].map { |x| x["name"] }
  {
    data: data,
    status: 200,
    msg: "",
  }.to_json
end

get "/api/v1/children" do
  content_type :json
  children = []
  Dir.glob("#{CHILDREN_DIR}/**/*.csv").each do |fp|
    children << fp.gsub("^#{CHILDREN_DIR}/", "").gsub(/\.csv$/, "")
  end
  {
    data: children,
    status: 200,
    msg: "",
  }.to_json
end

get "/api/v1/child/pings" do
  content_type :json
  er_j = ERROR_MAP["900"]
  rst = {
    status: 200,
    msg: "",
  }

  path = params["path"]

  return er_j.to_json unless token === AUTH_TOKEN

  csv_path = "#{CHILDREN_DIR}/#{path}.csv"
  unless File.exists?(path)
    dir_path = path.split("/")[0...-1].join("/")
    Dir.mkdir(dir_path)
  end
  rows = CSV.read(path)
  lines = rows[-DEFAULT_COUNT..-1]
  data = lines.map do |line|
    rst = {}
    line.each_with_index do |k, i|
      rst[conv_map[i]] = k
    end
    rst
  end
  {
    header: HEADER,
    data: data,
    count: 100,
    status: 200,
    msg: "",
  }.to_json
end

# childからparentへデータを登録する際の窓口
post "/api/v1/child/pings" do
  content_type :json
  er_j = ERROR_MAP["901"]
  rst = {
    status: 200,
    msg: "",
  }
  params = JSON.parse(request.body.read)

  # TODO: 認証をいれたい
  token = params["auth_token"]
  path = params["path"]
  header = params["header"]
  csv_data = params["data"]

  return er_j.to_json unless token === AUTH_TOKEN

  csv_path = "#{CHILDREN_DIR}/#{path}.csv"
  unless File.exists?(path)
    dir_path = path.split("/")[0...-1].join("/")
    Dir.mkdir(dir_path)
  end
  CSV.open(csv_path, "wb") do |csv|
    csv << header
    csv_data.each do |l|
      csv << l
    end
  end
  rst.to_json
end

get "/api/v1/node/pings" do
  er_j = ERROR_MAP["900"]
  node = params[:node]
  return er_j.to_json unless node

  header = CONFIG["header"]
  path = "./nodes/#{node}.csv"
  return er_j.to_json unless File.exists?(path)

  conv_map = {}
  header.each_with_index do |h, i|
    conv_map[i] = h
  end

  rows = CSV.read(path)
  lines = rows[-DEFAULT_COUNT..-1]
  data = lines.map do |line|
    rst = {}
    line.each_with_index do |k, i|
      rst[conv_map[i]] = k
    end
    rst
  end
  {
    header: header,
    data: data,
    count: 100,
    status: 200,
    msg: "",
  }.to_json
end
