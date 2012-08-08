//= require active_admin/base
$(document).ready(function() {
  tinyMCE.init({
          theme : "advanced",
          mode : "specific_textareas",
          editor_selector : "editor"
  });
});

function load_editors(){
  $('.editor').tinyMC({
    theme : "advanced",
            mode : "textareas",
            plugins : "fullpage",
            theme_advanced_buttons3_add : "fullpage"
  });
}