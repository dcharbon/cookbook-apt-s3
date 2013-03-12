include_recipe "apt"
include_recipe "build-essential"

package "libapt-pkg-dev" do
  action :install
end

package "libcurl4-openssl-dev" do
  action :install
end

package "git" do
  action :install
end

unless File.exists?("/usr/lib/apt/methods/s3")
  execute "checkout apt-s3 from git repository" do
    command "git clone #{node[:apt_s3][:git]}"
    creates "apt-s3"
    cwd "/tmp"
    action :run
  end

  execute "build apt-s3 from source" do
    command "make all"
    creates "/tmp/apt-s3/src/s3"
    cwd "/tmp/apt-s3"
    action :run
  end

  execute "install s3 command into apt methods" do
    command "sudo cp src/s3 /usr/lib/apt/methods/s3"
    creates "/usr/lib/apt/methods/s3"
    cwd "/tmp/apt-s3"
    action :run
  end

  execute "remove apt-s3 source" do
    command "rm -rf apt-s3"
    cwd "/tmp"
    action :run
  end
end
