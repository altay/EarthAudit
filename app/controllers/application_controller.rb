# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  # In your controller
  private

  # options:
  # required:
  #   :filename => the name of the file that will go into the zip file
  # optional:
  #   :zipfilename => the name of the zip file itself.  (default = temp file)
  #   :do_not_delete => bool, do you want to delete this file after creating it?  (i.e. temp file)  (default = false)
  def zip(data, options={})
    options[:zipfilename] ||= "/tmp/rubyzip-#{rand 32768}"
    options[:do_not_delete] ||= false
    Zip::ZipOutputStream::open(options[:zipfilename]) do |io|
      io.put_next_entry(options[:filename])
      io.write(data)
    end
    zippy = File.open(options[:zipfilename]).read
    File.delete(options[:zipfilename]) unless options[:do_not_delete]
    return zippy
  end

end
