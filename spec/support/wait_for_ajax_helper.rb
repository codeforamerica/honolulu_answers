# This code courtesy of art.ly
# http://www.webcitation.org/68jfoNAWt
def wait_for_ajax(timeout = Capybara.default_wait_time)
  page.wait_until(timeout) do
    page.evaluate_script 'jQuery.active == 0'
  end
end
