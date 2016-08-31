require 'open-uri'
require 'openssl'
require 'digest'

#####
# Patch to allow open-uri to follow safe (http to https)
# and unsafe redirections (https to http).
#
# Original gist URL:
# https://gist.github.com/1271420
#
# Relevant issue:
# http://redmine.ruby-lang.org/issues/3719
#
# Source here:
# https://github.com/ruby/ruby/blob/trunk/lib/open-uri.rb
#
# Thread-safe implementation adapted from:
# https://github.com/obfusk/open_uri_w_redirect_to_https
#
module OpenURI
  class <<self
    alias open_uri_original open_uri
    alias redirectable_cautious? redirectable?

    def redirectable?(uri1, uri2)
      case Thread.current[:__open_uri_redirections__]
      when :safe
        redirectable_safe? uri1, uri2
      when :all
        redirectable_all? uri1, uri2
      else
        redirectable_cautious? uri1, uri2
      end
    end

    def redirectable_safe?(uri1, uri2)
      redirectable_cautious?(uri1, uri2) || http_to_https?(uri1, uri2)
    end

    def redirectable_all?(uri1, uri2)
      redirectable_safe?(uri1, uri2) || https_to_http?(uri1, uri2)
    end
  end

  #####
  # Patches the original open_uri method, so that it accepts the
  # :allow_redirections argument with these options:
  #
  #   * :safe will allow HTTP => HTTPS redirections.
  #   * :all  will allow HTTP => HTTPS and HTTPS => HTTP redirections.
  #
  # OpenURI::open can receive different kinds of arguments, like a string for
  # the mode or an integer for the permissions, and then a hash with options
  # like UserAgent, etc.
  #
  # To find the :allow_redirections option, we look for this options hash.
  #
  def self.open_uri(name, *rest, &block)
    Thread.current[:__open_uri_redirections__] = allow_redirections(rest)
    block2 = lambda do |io|
      Thread.current[:__open_uri_redirections__] = nil
      block[io]
    end
    begin
      open_uri_original name, *rest, &(block ? block2 : nil)
    ensure
      Thread.current[:__open_uri_redirections__] = nil
    end
  end

  def self.allow_redirections(args)
    options = first_hash_argument(args)
    options.delete :allow_redirections if options
  end

  def self.first_hash_argument(arguments)
    arguments.select { |arg| arg.is_a? Hash }.first
  end

  def self.http_to_https?(uri1, uri2)
    schemes_from([uri1, uri2]) == %w(http https)
  end

  def self.https_to_http?(uri1, uri2)
    schemes_from([uri1, uri2]) == %w(https http)
  end

  def self.schemes_from(uris)
    uris.map { |u| u.scheme.downcase }
  end
end

# Java SE
module JavaSE
  # Monkey patched open library to allow oracle downloads
  module Downloader
    class <<self
      # rubocop:disable Metrics/MethodLength
      def fetch(url, file, checksum, limit = 5)
        raise ArgumentError, "too many download failures from #{url}" if limit.zero?
        begin
          open(URI(url),
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
