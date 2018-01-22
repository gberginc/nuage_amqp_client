$root = <<SCRIPT
curl https://copr.fedorainfracloud.org/coprs/simaishi/test/repo/epel-7/simaishi-test-epel-7.repo > /etc/yum.repos.d/qpid-proton.repo
yum install -y qpid-proton-c-devel git gcc openssl-devel readline-devel zlib-devel cyrus-sasl cyrus-sasl-plain
SCRIPT

$user = <<SCRIPT
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
. ~/.bash_profile
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 2.4.3

git clone https://github.com/gberginc/nuage_amqp_client.git
cd nuage_amqp_client
rbenv local 2.4.3
gem install bundler
bundle install
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.provision "shell", inline: $root
  config.vm.provision "shell", inline: $user, privileged: false
end
