ActiveAdmin.register Article do
  controller do
    def download_markdown_cheatsheet
      send_file("#{Rails.root}/lib/assets/markdown-cheatsheet.pdf",
                :type => "application/pdf",
                :disposition => 'attachment')
    end
  end
end
