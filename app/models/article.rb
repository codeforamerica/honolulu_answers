# encoding: utf-8
class Article < ActiveRecord::Base
  include RailsNlp
  include TankerArticleDefaults

  require_dependency 'keyword'

  extend FriendlyId

  # Permalinks. :slugged option means it uses the 'slug' column for the url
  #             :history option means when you change the article title, old slugs still work
  friendly_id :title, use: [:slugged, :history]

  belongs_to :contact
  belongs_to :category
  belongs_to :user
  has_many :wordcounts
  has_many :keywords, :through => :wordcounts

  scope :by_access_count, order('access_count DESC')
  scope :drafts, where(:pending_review => false).where(:published => false)
  scope :pending_review, where(:pending_review => true)
  scope :published, where(:published => true)

  has_attached_file :author_pic,
    :storage => :s3,
    :bucket => ENV['S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :s3_protocol => :https,
    :path => "/:style/:id/:filename",
    :styles => { :thumb => "100x100" }

  validates_attachment_size :author_pic, :less_than => 5.megabytes
  validates_attachment_content_type :author_pic, :content_type => ['image/jpeg', 'image/png']

  validates_presence_of :access_count

  attr_accessible :title, :content, :content_md, :content_main,
    :content_main_extra, :content_need_to_know, :render_markdown, :preview,
    :contact_id, :tags, :is_published, :slugs, :category_id, :updated_at,
    :created_at, :author_pic, :author_pic_file_name, :author_pic_content_type,
    :author_pic_file_size, :author_pic_updated_at, :author_name, :author_link,
    :type, :service_url, :user_id, :published, :pending_review

  # A note on the content fields:
  # *  Originally the content for the articles was stored as HTML in Article#content.
  # *  We then moved to Markdown for content storage, resulting in Article#content_md.
  # *  Most recently, the QuickAnswers were split into three distinct sections: content_main, content_main_extra and content_need_to_know. All these use Markdown.

  # Tanker callbacks to update the search index
  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

  # priority 2 to ensure it is run after text analysis
  handle_asynchronously :update_tank_indexes, :priority => 2
  handle_asynchronously :delete_tank_indexes, :priority => 2

  TEXT_ANALYSE_FIELDS = ['title', 'content_main', 'content_main_extra',
                         'content_need_to_know', 'preview', 'tags',
                         'category.name']

  def text_analyser
    @text_analyser ||= TextAnalyser.new(self, TEXT_ANALYSE_FIELDS)
  end

  after_create do
    text_analyser.delay(:priority => 1).create_analysis
  end

  after_update do
    text_analyser.delay(:priority => 1).update_analysis
  end

  after_destroy do
    text_analyser.delay(:priority => 1).destroy_analysis
  end

  before_validation :set_access_count_if_nil

  def legacy?
    !render_markdown
  end

  def self.search( query )
    begin
      self.search_tank query
    rescue Exception => exception
      ErrorService.report(exception)
      []
    end
  end

  def self.find_by_type( content_type )
    return Article.where(:type => content_type).order('category_id').order('access_count DESC')
  end

  def to_s
    if self.category
      "#{self.title} (#{self.id}) [#{self.category}]"
    else
    end
  end

  def published?
    published
  end

  def pending_review?
    pending_review
  end

  def draft?
    !(pending_review || published)
  end

  def md_to_html( field )
    return '' if instance_eval(field.to_s).blank?
    Kramdown::Document.new( instance_eval(field.to_s), :auto_ids => false).to_html
  end

  def raw_md_to_html( field )
    return '' if field.to_s.blank?
    Kramdown::Document.new( field.to_s, :auto_ids => false).to_html
  end

  def self.remove_stop_words string
    eng_stop_list = Rails.cache.fetch('stop_words') do
      CSV.read( "#{Rails.root.to_s}/lib/assets/eng_stop.csv" )
    end
    string = (string.downcase.split - eng_stop_list.flatten).join " "
  end

  def self.spell_check string
    dict = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/en_US", 'en_US' )

    dict_custom = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/blank", 'blank' )
    Keyword.all(:select => ['name', 'synonyms']).each do |kw|
      dict_custom.add kw.name
    end
    stop_words ||= Rails.cache.fetch('stop_words') do
      CSV.read( "lib/assets/eng_stop.csv" ).flatten
    end
    stop_words.each{ |sw| dict_custom.add sw }

    string_corrected = string.split.map do |word|
      if dict.spell(word) or dict_custom.spell(word) # word is correct
        word
      else
        suggestion = dict_custom.suggest( word ).first
        suggestion.nil? ? word : suggestion
      end
    end

    string_corrected.join ' '
  end

  def self.expand_query( query )
    stems,metaphones,synonyms = [[],[],[]]
    query.split.each do |term|
      # try and hit the database first, only compute stuff if we have to
      kw = Keyword.find_by_name(term)
      if kw
        stems << kw.stem
        metaphones << kw.metaphone.compact
        # synonyms << kw.synonyms.first(3)
      else
        stems << Text::PorterStemming.stem(term)
        metaphones << Text::Metaphone.double_metaphone(term)
        # synonyms << RailsNlp::BigHugeThesaurus.synonyms(term)
      end
    end

    ## Construct the OR query
    query_final =      "title:(#{query.split.join(' OR ')})^10"
    query_final << " OR content:(#{query.split.join(' OR ')})^5"
    query_final << " OR tags:(#{query.split.join(' OR ')})^8"
    query_final << " OR stems:(#{stems.flatten.join(' OR ')})^3"
    query_final << " OR metaphones:(#{metaphones.flatten.compact.join(' OR ')})^2"
    # query_final << " OR #{'synonyms:"'  + synonyms.flatten.first(3).join( '" OR synonyms:"') + '"'}"
    query_final << " OR synonyms:(#{query.split.join(' OR ')})"

    return query_final
  end

  def related
    Rails.cache.fetch("#{self.id}-related") {
      return [] if wordcounts.empty?
      (Article.search(self.wordcounts.all(:order => 'count DESC', :limit => 10).map(&:keyword).map(&:name).join(" OR ")) - [self]).first(4)
    }
  end

  def set_access_count_if_nil
    self.access_count = 0 if self.access_count.nil?
  end

end
