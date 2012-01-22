class Upload < ActiveRecord::Base
  include PaperclipSupport

  belongs_to :user
  belongs_to :category, :class_name => "UploadCategory"

  storage = case
  when Settings.s3_access_id && Settings.s3_secret_key && Settings.s3_bucket_name
    { :storage => :s3, :path => "files/:filename", :bucket => Settings.s3_bucket_name,
      :s3_host_alias => Settings.s3_host_alias, :url => Settings.s3_host_alias ? ':s3_alias_url' : ':s3_path_url',
      :s3_credentials => { :access_key_id => Settings.s3_access_id, :secret_access_key => Settings.s3_secret_key },
      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate } }
  else
    { :storage => :filesystem, :url => "/files/:filename" }
  end

  has_attached_file :attachment, storage

  validates_attachment_presence :attachment
  validates_attachment_size :attachment, :less_than => 100.megabytes

  attr_accessible :category_id

  def is_mp3?
    %w(audio/mpeg audio/mpg).include?(attachment_content_type) ? true : false
  end

  private
  def attachment_url_provided?
    !self.attachment_url.blank?
  end

  def download_remote_file
    self.attachment = do_download_remote_file
    self.attachment_remote_url = attachment_url
  end

  def do_download_remote_file
    io = open(URI.parse(attachment_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
end
