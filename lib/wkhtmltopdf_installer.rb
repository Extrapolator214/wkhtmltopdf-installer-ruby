require File.expand_path("../wkhtmltopdf_installer/version.rb", __FILE__)

module WkhtmltopdfInstaller
  extend self

  def libexec_dir
    "#{File.dirname(__FILE__)}/../libexec"
  end

  def wkhtmltopdf_path
    "#{libexec_dir}/wkhtmltopdf"
  end
end

ENV['PATH'] = [WkhtmltopdfInstaller.libexec_dir, ENV['PATH']].compact.join(':')

