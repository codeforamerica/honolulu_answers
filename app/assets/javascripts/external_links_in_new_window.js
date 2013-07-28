$(function() {
  var all_links = $("a[href*='http']");
  new_window(all_links);
  var internal_links = $("a[href*='answers.honolulu.gov']");
  same_window(internal_links);
});

function new_window(links) {
  links.attr("target","_blank");
}

function same_window(links) {
  links.attr("target","");
}
