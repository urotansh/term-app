// import Rails from "@rails/ujs";

// キーボードショートカット(Command + Enter or Ctrl + Enter)でコメントを投稿する
const handleShortcutSubmit = function() {
  const comment_form = document.getElementById('comment_form');
  if (comment_form != null) {
    comment_form.addEventListener('keydown', (e) => {
      if (e.key == 'Enter' && (e.metaKey || e.ctrlKey) && !e.shiftKey) {
        document.getElementById('comment_submit').click();
        // rails-ujsを使用する場合
        // WARNING: 2回目のコメント投稿でSQLite3::BusyException: database is lockedが発生してしまう
        // Rails.fire(comment_form, 'submit');
      }
    });
  }
}

window.handleShortcutSubmit = handleShortcutSubmit;

'ajax:complete turbolinks:load'.split(' ').forEach((eventName)=>{
  document.addEventListener(eventName, (e)=>{
    handleShortcutSubmit();
  });
});
