require 'open-uri'
require 'open_uri_redirections'
require 'openssl'
require 'digest'

module JavaSE
  class <<self
    def download(url, file, limit = 5)
      raise ArgumentError, 'too many download failures' if limit == 0
      uri = URI(url)
      begin
        open(uri,
          'Cookie' => 'oraclelicense=accept-securebackup-cookie',
          allow_redirections: :all,
          ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) do |fin|
          open(file, 'w') do |fout|
            while (buf = fin.read(8192))
              fout.write buf
            end
          end
        end
      rescue
        download(url, file, limit - 1)
      end
    end

    def valid?(file, checksum)
      sha256 = Digest::SHA256.file file
      sha256.hexdigest == checksum
    end

    def validate(file, checksum)
      raise "#{file} does not match checksum #{checksum}" unless valid?(file, checksum)
    end
  end
end
