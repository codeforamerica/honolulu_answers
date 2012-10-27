module ArticlesHelper
  
  def article_list_tag(article_id, description)
    content_tag(:li, link_to(description, article_path(article_id)))
  end
  
  def missing_article_list_tag(article_id, description)
    content_tag(:li, description, :class => "missing-article")
  end

  def facebook_and_twitter_share
    social_media_share = %Q{
                            <div>
                              <div>
                                <a href="http://twitter.com/share" data-count="horizontal" data-via="funonrails">Tweet</a>
                                <script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
                              </div>
                            <script src="http://connect.facebook.net/en_US/all.js#xfbml=1"></script><fb:like href="" layout="button_count" show_faces="false" width="450" font=""></fb:like>
                            </div>
                           }
    social_media_share.html_safe
  end
  
end
