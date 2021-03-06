# == Fact: trustedcas
# From fetchcrl module.
# Fact supplies the issuer of grid grid certificate if it exists.
require 'openssl'

Facter.add('trustedca') do
  setcode do
    arr = Array.new
    Dir.glob('/etc/grid-security/certificates/*.pem') do |pem|
      cert = OpenSSL::X509::Certificate.new(File.read(pem))
      subject = cert.subject.to_a
      # Array of arrays [CN,France,19] , last thing is type, hopefully we
      # can ignore that? I'm sure there must be a method in Certificate
      # for printing in rfc2449 format but I can't find it.
      rfc = subject.map{|x,y,z| "#{x}=#{y}" }.reverse.join(',')
      arr.push(rfc)
    end
    arr
  end
end


