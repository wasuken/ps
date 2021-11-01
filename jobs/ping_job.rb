require "net/ping"
require "json"
require "csv"
require "date"

require "./job_template.rb"

class PingJob < Job
  def logging_ping(node)
    node_dir = @config["node_dir"]
    check = Net::Ping::External.new(node)
    d = DateTime.now
    ndf = d.strftime
    path = "#{node_dir}/#{node}.csv"
    unless File.exists?(path)
      header = @config["header"]
      CSV.open(path, "wb") do |csv|
        csv << header
      end
    end

    CSV.open(path, "a") do |csv|
      csv << [node, check.ping?, check.duration, ndf]
    end
  end

  def call()
    @config["nodes"].each do |node|
      name = node["name"]
      logging_ping(name)
    end
    self.reload
  end
end

conf = JSON.parse(File.read("./config.json"))
jb = PingJob.new(conf, "PingJob")
jb.reload(conf["ping_interval"].to_i)
$table << jb
