//= require active_admin/base

$(document).ready(function() {
  if(typeof tinyMCE !== 'undefined'){
    tinyMCE.init({
          mode: 'specific_textareas',
          editor_selector : 'editor',
          theme: 'advanced'
    });
  }
});
