// import Rails from "@rails/ujs";

'ajax:complete turbolinks:load'.split(' ').forEach((eventName)=>{
  document.addEventListener(eventName, (e)=>{
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
  });
});
