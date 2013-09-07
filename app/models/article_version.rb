class ArticleVersion < Version
  self.table_name = :article_versions
  attr_accessible :status
end
