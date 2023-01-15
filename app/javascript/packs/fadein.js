import $ from 'jquery';

// 投稿内容をフェードインで表示
'ajax:complete turbolinks:load'.split(' ').forEach((eventName)=>{
  document.addEventListener(eventName, (e)=>{
    if (document.getElementById("comment_post_flg") != null){
      return;
    }
    $("#note").hide().fadeIn();
  });
});

// jsTreeをフェードインで表示
'turbolinks:load'.split(' ').forEach((eventName)=>{
  document.addEventListener(eventName, (e)=>{
    $("#jstree").hide().fadeIn();
  });
});
