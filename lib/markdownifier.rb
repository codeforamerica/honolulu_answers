module Markdownifier
  include HTTParty

  def html_to_markdown( html, options = {} )
    options.merge!( { :query => { :html => html } } )
    response = self.class.post( 'http://fuckyeahmarkdown.com/go/', options )
    return response.body
  end
end
