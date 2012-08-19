//= require active_admin/base
$(document).ready(function() {
  tinyMCE.init({
          theme : "advanced",
          mode : "specific_textareas",
          editor_selector : "editor"
  });
});