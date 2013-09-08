class ArticleVersion < Version
  self.table_name = :article_versions
  attr_accessible :status

  def self.reify_latest_version_where(options)
    where(options).order('created_at DESC').first.reify
  end
end
