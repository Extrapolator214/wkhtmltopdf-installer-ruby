require 'mkmf'
require 'tmpdir'
require 'ostruct'
require_relative '../lib/wkhtmltopdf_installer'

def probe
  @probe ||= case RUBY_PLATFORM
               when /x86_64-darwin.*/
                 OpenStruct.new(script: 'macos', platform: 'osx-cocoa-x86-64', ext: 'pkg')
               when /x86_64-linux/
                 OpenStruct.new(script: 'linux', platform: "linux-#{distro}-amd64", ext: 'deb')
               when /i[3456]86-linux/
                 OpenStruct.new(script: 'linux', platform: "linux-#{distro}-i386", ext: 'deb')
               else
                 raise NotImplementedError "Unsupported ruby platform #{RUBY_PLATFORM}"
             end
end

def version
  WkhtmltopdfInstaller::VERSION
end

def makefile_dir
  File.dirname(__FILE__)
end

# List of supported distributions: http://wkhtmltopdf.org/downloads.html
def distro
    distro = `awk '/^VERSION=|^ID=/ {print}' /etc/*release`.split(/\n+/).map{|h| k,v = h.split('='); {k => v}}.reduce(:merge)
    distro['VERSION'] = distro['VERSION'].slice(/\(.+\)/).delete('()').split[0].downcase
    case distro['ID']
      when 'debian'
        %w[wheezy jessie].include?(distro['VERSION']) ? distro['VERSION'] : 'wheezy'
      when 'ubuntu'
        %w[trusty precise].include?(distro['VERSION']) ? distro['VERSION'] : 'trusty'
      else
        'trusty'
    end
end

# Some examples:
# "http://download.gna.org/wkhtmltopdf/0.12/#{version}/wkhtmltox-#{version}_osx-cocoa-x86-64.pkg"
# "http://download.gna.org/wkhtmltopdf/0.12/#{version}/wkhtmltox-#{version}_linux-trusty-amd64.deb"
# "http://download.gna.org/wkhtmltopdf/0.12/#{version}/wkhtmltox-#{version}_linux-trusty-i386.deb"
def package_url
  major_version = version.gsub(/^(\d+\.\d+).*$/, '\1')
  "http://download.gna.org/wkhtmltopdf/#{major_version}/#{version}/wkhtmltox-#{version}_#{probe.platform}.#{probe.ext}"
end

# The main Makefile contains settings only. The actual work is done by os-specific Makefile.xxxxx files
File.write "#{makefile_dir}/Makefile", <<-EOF
URL = #{package_url}
LIBEXEC = #{WkhtmltopdfInstaller.libexec_dir}
TARGET = #{WkhtmltopdfInstaller.wkhtmltopdf_path}
TMPDIR = #{Dir.mktmpdir}
all: unpack
install: copy clean
include Makefile.#{probe.script}
include Makefile.common
EOF

