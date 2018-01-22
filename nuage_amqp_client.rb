#--
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#++

require 'qpid_proton'
require 'optparse'

class NuageMB < Qpid::Proton::MessagingHandler

  def initialize(topics, opts)
    super()
    @topics = topics
    @opts = opts
    @url = @opts.delete(:url)
    @test_connection = @opts.delete(:test_connection)
  end

  def on_container_start(container)
    conn = container.connect(@url, @opts)
    @topics.each { |topic| conn.open_receiver("topic://#{topic}") }
    puts "started"
  end

  def on_connection_open(connection)
    puts "opened"
    connection.container.stop if @test_connection
  end

  def on_connection_closed(connection)
    puts "closed"
  end

  def on_connection_error(connection)
    puts "on_connection_error"
  end

  def on_message(delivery, message)
    puts message.body
  end

  def on_transport_error(transport)
    puts "on_transport_error"
  end
end

url = ENV['NUAGE_AMQP_URL']
username = ENV['NUAGE_AMQP_USERNAME']
password = ENV['NUAGE_AMQP_PASSWORD']

options = {
  :sasl_allowed_mechs        => "PLAIN", 
  :sasl_allow_insecure_mechs => true,
  :test_connection           => false,
  :url                       => url,
  :user                      => username,
  :password                  => password}

loop do
  begin
    hw = NuageMB.new(["topic/CNAMessages", "topic/CNAAlarms"], options.clone)
    Qpid::Proton::Container.new(hw).run
  rescue => e
    puts "Caught exception #{e}"
  end

  sleep 2
end
