//= require active_admin/base

$(document).ready(function() {
  tinyMCE.init({
          mode: 'specific_textareas',
          editor_selector : 'editor',
          theme: 'advanced'
  });
});
