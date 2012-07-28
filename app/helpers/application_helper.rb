module ApplicationHelper
	def categories_list
		Category.order('name')
	end
	def category_by_name(name)
		Category.where(:name => name).first
	end
end
