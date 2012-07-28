module ApplicationHelper
	def categories_list
		Category.order('name')
	end
end
