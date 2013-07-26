$(function() {
  new_window(external_links());
});

function new_window(links) {
  links.attr("target","_blank");
}

function external_links() {
  return $("a[href*='http'],a[href*='www']");
}
