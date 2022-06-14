// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

const editButtons = document.getElementsByClassName("starred-repo-edit-btn");
for(const btn of editButtons) {
  btn.onclick = function(e) {
    const repoNameHolder = document.getElementById("modal-starred-repo-name");
    const hiddenRepoIdInputField = document.getElementById("starred-repo-id");
    const tagsInputField = document.getElementById("repo-tags-input");
    const alertDiv = document.getElementById("tags-modal-alert");
    let repoName = e.target.dataset.starredRepoName;
    let repoId = e.target.dataset.starredRepoId;
    let repoTags = e.target.dataset.starredRepoTags;
    // hide the alert div
    alertDiv.style.display = "none";
    // set repo name in the heading
    repoNameHolder.innerHTML = repoName;

    //set repo id in hidden input field
    hiddenRepoIdInputField.value = repoId;

    //populate tag inputs
    tagsInputField.value = repoTags;
  };
};

const saveTagBtn = document.getElementById("save-tags");
saveTagBtn.onclick = async function(e) {
  e.preventDefault();
  const hiddenRepoIdInputField = document.getElementById("starred-repo-id");
  const tagsInputField = document.getElementById("repo-tags-input");
  const alertDiv = document.getElementById("tags-modal-alert");
  let apiReq = await fetch('starred_repos/' + hiddenRepoIdInputField.value, {
    method: 'PUT',
    headers: {
      'x-csrf-token': document.querySelector('meta[name="csrf-token"]').content,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({tags: tagsInputField.value})
  });
  let json = await apiReq.json();

  alertDiv.className = "alert";
  if(apiReq.ok) {
    alertDiv.className += " alert-success";
    alertDiv.style.display = "block";
    alertDiv.innerText = json.message;
    const repoName = document.getElementById("modal-starred-repo-name").innerHTML;
    const repoTagHolder =  document.getElementById(repoName + "-tags");
    repoTagHolder.innerHTML = json.tags;


  } else{
    alertDiv.className += " alert-danger";
    alertDiv.style.display = "block";
    alertDiv.innerText = json.message;
  }
}