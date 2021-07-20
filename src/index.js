import { Elm } from "./Main.elm";

let app;
document.addEventListener("DOMContentLoaded", function () {
  app = Elm.Main.init({ node: document.getElementById("root") });
});
