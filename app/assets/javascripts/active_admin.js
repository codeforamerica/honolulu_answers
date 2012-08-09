//= require active_admin/base
$(document).ready(function() {
  load_editors();
});

function load_editors(){
  tinyMCE.init({
          theme : "advanced",
          mode : "specific_textareas",
          editor_selector : "editor"
  });
}