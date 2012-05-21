class Article < ActiveRecord::Base
  # has_and_belongs_to_many :locations
  belongs_to :contact
  def self.search(search)
    if search
      where('title ILIKE ? OR content ILIKE ?', "%#{search}%", "%#{search}%")
    else
      ""
    end
  end

  def self.search_titles(search)
    
    if search      
      where('title ILIKE ?', "%#{search}%")
    else
      ""
    end
  end

  def allContent()
    [self.title, self.content].join(" ")
  end

end
