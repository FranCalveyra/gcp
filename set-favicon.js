(function setCustomFavicon() {
  var root = typeof path_to_root === "string" ? path_to_root : "";
  var href = root + "images/GCP%20Logo.png";
  var head = document.head;

  if (!head) return;

  var icon = document.querySelector('link[rel="icon"]');
  if (!icon) {
    icon = document.createElement("link");
    icon.setAttribute("rel", "icon");
    head.appendChild(icon);
  }
  icon.setAttribute("type", "image/png");
  icon.setAttribute("href", href);

  var shortcut = document.querySelector('link[rel="shortcut icon"]');
  if (!shortcut) {
    shortcut = document.createElement("link");
    shortcut.setAttribute("rel", "shortcut icon");
    head.appendChild(shortcut);
  }
  shortcut.setAttribute("type", "image/png");
  shortcut.setAttribute("href", href);
})();
