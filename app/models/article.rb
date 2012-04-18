class Article < ActiveRecord::Base

  def self.search(search)
    if search
      where('title ILIKE ? OR content ILIKE ?', "%#{search}%", "%#{search}%")
    else
      ""
    end
  end

end
