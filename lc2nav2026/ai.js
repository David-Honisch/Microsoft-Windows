console.log ('TEST!!!!!!');
alert ('TEST!!!!!!');
const create_NEWUI = (url, title) => {
  const webview = new WebviewWindow('unique-label', {
    url: url,
    title: title,
    width: 600,
    height: 400,
  });

  webview.once('tauri://created', () => {
    console.log('Window successfully created');
  });
};
try {
    var query = query != null ? query : document.getElementById("cmd-input").value;
    create_NEWUI("https://www.letztechance.org/read-22-51.html?query="+query,"LC2WebLLM");
    
} catch (error) {
    alert("Error: " + error.message);    
}