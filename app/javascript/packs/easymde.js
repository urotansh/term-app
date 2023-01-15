import 'easymde/dist/easymde.min.css';
import EasyMDE from 'easymde';
import 'highlightjs/styles/monokai.css';
import hljs from 'highlightjs';

const initMDE = function() {
  if (document.getElementById("comment_post_flg") != null){
  return;
  }
  if (document.getElementById("editor") != null){
  // textareaをMarkdownエディタにする
  const easymde = new EasyMDE({
    // showIcons: ["code", "table"],
    showIcons: ["code", "undo", "redo"],
    shortcuts: {
        "drawTable": "Cmd-Alt-T", // Markdownテーブルショートカット
    },
    renderingConfig: {
        codeSyntaxHighlighting: true,
        hljs: hljs
    },
    sideBySideFullscreen: false,
    spellChecker: false,   // 日本語はスペルチェックに引っかかるのでスペルチェックをオフ
    // autosave: {            // 自動保存
    //     enabled: true,     // 自動保存有効化
    //     delay: 1000,       // 1秒ごと保存
    //     uniqueId: 'mde-autosave-demo' // ローカルストレージのキーに使用
    // },
    element: document.getElementById("editor"),
  });
  easymde.toggleSideBySide();
  }
  if (document.getElementById("editor-preview") != null){
    // textareaをMarkdownエディタにする
    const easymdePreview = new EasyMDE({
      showIcons: [],
      autoDownloadFontAwesome: false,
      toolbar: [{
        name: "fullscreen",
        action: EasyMDE.toggleFullScreen,
        className: "fa fa-arrows-alt no-disable no-mobile",
        title: "Toggle Fullscreen",
      }],
      status: false,
      syncSideBySidePreviewScroll: false,
      scrollbarStyle: null,
      renderingConfig: {
          codeSyntaxHighlighting: true,
          hljs: hljs
      },
      element: document.getElementById("editor-preview"),
    });
    easymdePreview.togglePreview();
  }
}

window.initMDE = initMDE;

// 新規投稿ページ/投稿詳細ページのテキストエリアをマークダウンエディタへ変更
'turbolinks:load'.split(' ').forEach((eventName)=>{
  document.addEventListener(eventName, (e)=>{
    initMDE();
  });
});
