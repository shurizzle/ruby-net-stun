$:.unshift File.realpath(File.join('..', '..', 'lib'), __FILE__)
require 'net/stun'
require 'socket'

sock = UDPSocket.new(:INET)
puts 'Connecting...'
#sock.connect('stun.ekiga.net', 3478)
sock.connect('stun.sipgate.net', 10000)
puts 'Creating pack...'
packet = Net::STUN::Types::BindingRequest.new.pack
puts "sending #{packet.bytesize}B... (#{packet.inspect})"
sock.write(packet)
IO.select([sock])
lol = sock.recvfrom(1024)[0]
puts "Reading Header..."
header = Net::STUN::Header.unpack(lol[0, 20])
p header
lol = lol[20..-1]
#lol = sock.recvfrom(header.length)[0]
puts "Parsing Body..."
body = Net::STUN::Body.unpack(lol)
p body
