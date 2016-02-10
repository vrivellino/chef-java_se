require 'open-uri'
require 'openssl'
require 'digest'

# Java SE
module JavaSE
  # Monkey patched open library to allow oracle downloads
  module Downloader
    class <<self
      def load_open_uri_redirections
        # Libraries are loaded before recipes are compiled, so you can't install gems for direct use by libraries.
        require 'open_uri_redirections'
      end

      # rubocop:disable Metrics/MethodLength
      def fetch(url, file, checksum, limit = 5)
        raise ArgumentError, "too many download failures from #{url}" if limit == 0
        load_open_uri_redirections
        uri = URI(url)
        begin
          open(uri,
               'Cookie' => 'oraclelicense=accept-securebackup-cookie',
               allow_redirections: :all,
               ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) do |fin|
            open(file, 'wb') do |fout|
              while (buf = fin.read(8192))
                fout.write buf
              end
            end
          end

          # retry download if file checksum is not valid
          fetch(url, file, checksum, limit - 1) unless valid?(file, checksum)
        rescue
          fetch(url, file, checksum, limit - 1)
        end
      end
      # rubocop:enable Metrics/MethodLength

      def valid?(file, checksum)
        sha256 = Digest::SHA256.file file
        sha256.hexdigest == checksum
      end

      def validate(file, checksum)
        raise "#{File.basename(file)} does not match checksum #{checksum}" unless valid?(file, checksum)
      end
    end
  end
end
