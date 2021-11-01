require "csv"
require "json"
require "net/http"
require "uri"

require "./job_template.rb"

class SyncJob < Job
  def post_csv(dir_path)
    Dir.glob("#{dir_path}/**/*.csv").each do |csv_path|
      path = csv_path
      path.gsub("^#{dir_path}", "").gsub(/\.csv$/, "")
      csv_data = CSV.read(csv_path)[-@config["default_count"]..-1]
      @config["parents"].each do |u|
        uri = URI(u)
        req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
        req.body = { header: @config["header"], data: csv_data, path: path }.to_json
        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
      end
    end
  end

  # 直下のnode CSV情報送信
  def post_current_nodes_to_parent()
    post_csv(@config["node_dir"])
  end

  # children CSV情報送信
  def post_children_to_parent()
    post_csv(@config["children_dir"])
  end

  def call
    post_current_nodes_to_parent
    post_children_to_parent
    self.reload
  end
end

conf = JSON.parse(File.read("./config.json"))
jb = SyncJob.new(conf, "SyncJob")
jb.reload(conf["parent_sync_interval"].to_i)
$table << jb
