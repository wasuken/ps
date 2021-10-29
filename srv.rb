require "sinatra"
require "sinatra/reloader"
require "json"
require "csv"

CONFIG = JSON.parse(File.read("./config.json"))
NODE_DIR = CONFIG["node_dir"]

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

get "/api/v1/node/pings" do
  er_j = {
    status: 900,
    msg: "Invalid Parameter.",
  }
  node = params[:node]
  return er_j.to_json unless node

  header = CONFIG["header"]
  path = "./nodes/#{node}.csv"
  return er_j.to_json unless File.exists?(path)

  data = CSV.read(path)
  lines = data[-100...-1]
  {
    header: header,
    data: lines,
    count: 100,
    status: 200,
    msg: "",
  }.to_json
end
