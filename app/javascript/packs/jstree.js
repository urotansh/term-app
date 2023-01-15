import $ from 'jquery';
import 'jstree/dist/themes/default/style.min.css';
import 'jstree';

document.addEventListener('turbolinks:load', () => {
  if (document.querySelector('.jstree-container-ul') != null) {
    return;
  }
  $('#jstree').jstree({
    "plugins": ["types", "wholerow"]
  });
});
