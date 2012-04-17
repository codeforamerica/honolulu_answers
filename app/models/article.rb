class Article < ActiveRecord::Base

  def self.search(search)
    if search
      where('title LIKE ? OR content LIKE ?', "%#{search}%", "%#{search}%")
    else
      ""
    end
  end

end
