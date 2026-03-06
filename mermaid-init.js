// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
(function () {
    let theme = "default";
    const html = document.querySelector("html");
    if (html) {
        const classes = html.classList;
        if (classes.contains("ayu") || classes.contains("navy") || classes.contains("coal")) {
            theme = "dark";
        } else if (classes.contains("light") || classes.contains("rust")) {
            theme = "default";
        }
    }

    mermaid.initialize({ startOnLoad: true, theme });

    // Simplest way to make mermaid re-render the diagrams in the new theme is via refreshing the page.
    const buttons = document.querySelectorAll(".theme-toggle button");
    buttons.forEach((btn) => {
        btn.addEventListener("click", () => {
            const currentlyDark =
                html.classList.contains("ayu") ||
                html.classList.contains("navy") ||
                html.classList.contains("coal");
            const newThemeIsDark =
                btn.id === "ayu" || btn.id === "navy" || btn.id === "coal";
            if (currentlyDark !== newThemeIsDark) {
                window.location.reload();
            }
        });
    });
})();
