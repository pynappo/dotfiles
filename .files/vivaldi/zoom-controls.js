(function () {
  // ============================================================================================================
  // Gives Zoom Interface in the Address Bar
  //    - made by nomadic on the Vivaldi Forums
  // ============================================================================================================
  function zoomControl() {
    // CONFIGURATION: ---------------------------------------------------------------
    //  - in Vivaldi's settings you can set the default page zoom, this
    //    will follow that if RESET_ZOOM_LEVEL is set to 100
    const RESET_ZOOM_LEVEL = 100; // 100 %  -> the zoom that hitting the reset button will default to
    const ZOOM_INCREMENT_AMOUNT = 10; // 10 %  -> the amount the zoom is either raised or lowered
    // MODES----------------
    // Mode 0: only clicking button opens and closes the panel
    // Mode 1: clicking the button opens the panel and the panel auto closes if not hovered over
    //    Option for mode 1:
    //        FADE_OUT_TIME  ->  the number of seconds the panel goes without hover before closing
    // Mode 2: just hovering over the button will open the panel and the panel auto closes if not hovered over
    //    Options for mode 2:
    //        FADE_OUT_TIME  ->  the number of seconds the panel goes without hover before closing
    //        IS_AUTO_OPENED_ON_ADDRESSBAR  ->  instead of only the button being hovered, the whole address bar is used
    const MODE = 1;
    // ---------------------
    // Option for modes 1 and 2:
    const FADE_OUT_TIME = 0.5; // 3 seconds  -> can be set to any positive half second increment (ex. 0, 0.5, 1, 1.5 ...)
    // Option for mode 2:
    const IS_AUTO_OPENED_ON_ADDRESSBAR = false;
    // ------------------------------------------------------------------------------

    // Creates the zoom button and panel initially, and then updates the icon depending on the zoom level
    function updateZoomIcon(zoomInfo) {
      let newZoom = zoomInfo.newZoomFactor;
      let zoomIconPath;
      const isMailBar = document.querySelector(".toolbar-mailbar");

      if (isMailBar) return;

      // create the button if it isn't already there
      let alreadyExists = document.getElementById("zoom-hover-target");
      if (alreadyExists) {
        alreadyExists.remove();
        document.getElementById("el2left").remove();
      }

      // CHANGE: Added in Update #4
      // a guaranteed div to the left of the button
      let elementToTheLeft = document.createElement("div");
      elementToTheLeft.style.transition = "0.5s";
      elementToTheLeft.id = "el2left";

      let zoomBtn = document.createElement("div");
      zoomBtn.id = "zoom-hover-target";
      zoomBtn.innerHTML = `
          <div class="zoom-parent">
            <div class="zoom-panel">
              <div class="page-zoom-controls-c">
                <div class="button-toolbar button-toolbar-c reset-zoom-c" title="Reset Zoom">
                  <button tabindex="-1" class="button-textonly-c" id="zoom-reset-c">
                    <span class="button-title-c">Reset</span>
                  </button>
                </div>
                <div class="button-toolbar button-toolbar-c" title="Zoom Out">
                  <button tabindex="-1" id="zoom-out-c">
                    <span>
                      <svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
                        <path d="M4 8C4 8.55228 4.44772 9 5 9H11C11.5523 9 12 8.55228 12 8C12 7.44772 11.5523 7 11 7H5C4.44772 7 4 7.44772 4 8Z"></path>
                      </svg>
                    </span>
                  </button>
                </div>
                <span id="zoom-percent-c"></span>
                <div class="button-toolbar button-toolbar-c" title="Zoom In">
                  <button tabindex="-1" id="zoom-in-c">
                    <span>
                      <svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
                        <path d="M7 7V5C7 4.44772 7.44772 4 8 4C8.55228 4 9 4.44772 9 5V7H11C11.5523 7 12 7.44772 12 8C12 8.55228 11.5523 9 11 9H9V11C9 11.5523 8.55228 12 8 12C7.44772 12 7 11.5523 7 11V9H5C4.44772 9 4 8.55228 4 8C4 7.44772 4.44772 7 5 7H7Z"></path>
                      </svg>
                    </span>
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div class="button-toolbar ZoomButton-Button">
            <button tabindex="-1" title="Adjust Zoom" id="zoom-panel-btn" type="button" class="ToolbarButton-Button">
              <span>
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewbox="0 0 16 16" id="zoomIcon-c">
                </svg>
              </span>
            </button>
          </div>
        `;

      // inserts the button to the left of the bookmark icon
      const addressBarEnd = document.querySelector(".UrlBar-AddressField .toolbar-insideinput:last-of-type");
      const bookmarkBtn = addressBarEnd.getElementsByClassName("BookmarkButton")[0];
      if (!bookmarkBtn) {
        addressBarEnd.appendChild(zoomBtn);
      } else {
        addressBarEnd.insertBefore(zoomBtn, bookmarkBtn);
      }
      // CHANGE:Added in Update #4
      // divs next to the button aren't static,so created my own div to push
      addressBarEnd.insertBefore(elementToTheLeft, zoomBtn);

      // listener for the magnifying glass button to expand or collapse the control panel
      document.getElementById("zoom-panel-btn").addEventListener("click", function () {
        let nav = document.getElementsByClassName("zoom-panel")[0];
        navToggle(nav, elementToTheLeft);
      });

      // listener for the zoom in button in the zoom control panel
      document.getElementById("zoom-in-c").addEventListener("click", incrementPercent);

      // listener for the zoom out button in the zoom control panel
      document.getElementById("zoom-out-c").addEventListener("click", decrementPercent);

      // listener for the zoom reset button in the zoom control panel
      document.getElementById("zoom-reset-c").addEventListener("click", resetZoom);

      // starts esentially a hover listener that modes 1 and 2 need
      if (MODE === 1 || MODE === 2) {
        zoomPanelHoverTracker();
      }

      // set the icon based on the new zoom level
      if (newZoom < RESET_ZOOM_LEVEL / 100) {
        // zoomed in
        zoomIconPath = `
          <path d="M5.83 9.65a.5.5 0 00-.29.13L1.32 14c-.46.47.23 1.17.7.7l4.22-4.22a.5.5 0 00-.42-.83zm3.6-8.5a5.41 5.41 0 00-5.4 5.4 5.4 5.4 0 105.4-5.4zm0 .99a4.4 4.4 0 11-4.41 4.41 4.4 4.4 0 014.42-4.42zM7.16 6.06c-.66 0-.66.98 0 .98h4.57c.65 0 .65-.98 0-.98z"/>
        `;
      } else if (newZoom > RESET_ZOOM_LEVEL / 100) {
        // zoomed out
        zoomIconPath = `
          <path d="M5.83 9.65a.5.5 0 00-.3.13L1.31 14c-.46.47.23 1.17.7.7l4.22-4.22a.5.5 0 00-.4-.84zm3.6-8.5a5.41 5.41 0 00-5.4 5.4 5.4 5.4 0 0010.81 0 5.4 5.4 0 00-5.4-5.4zm0 .98a4.4 4.4 0 014.42 4.41 4.41 4.41 0 11-4.41-4.4zm-.06 1.63a.5.5 0 00-.43.5v1.79h-1.8c-.65 0-.65.98 0 .98h1.8v1.81c0 .66.99.66.99 0v-1.8h1.79c.65 0 .65-.99 0-1h-1.8V4.27a.5.5 0 00-.55-.5z"/>
        `;
      } else {
        // default zoom icon
        zoomIconPath = `
          <path d="M5.87 9.71c-.11.01-.2.06-.29.14l-4.37 4.37c-.46.45.23 1.14.7.68l4.36-4.37a.48.48 0 00-.41-.82zm3.55-8.36A5.33 5.33 0 004.1 6.67a5.32 5.32 0 105.32-5.32zm0 .97a4.33 4.33 0 11-4.34 4.34 4.33 4.33 0 014.34-4.35z"/>
        `;
      }

      // insert the new icon
      let zoomSVG = document.getElementById("zoomIcon-c");
      zoomSVG.innerHTML = zoomIconPath;

      // make the percent in the controls match the current zoom level
      updatePercent(newZoom);
    }

    // Makes the zoom controls slide out
    function openNav(nav, elToLeft) {
      nav.classList.add("expanded-nav-c");
      nav.parentElement.parentElement.classList.add("zoom-hover-target--active");
      elToLeft.classList.add("expanded-left-c");
    }

    // Hides the zoom controls
    function closeNav(nav, elToLeft) {
      nav.classList.remove("expanded-nav-c");
      nav.parentElement.parentElement.classList.remove("zoom-hover-target--active");
      elToLeft.classList.remove("expanded-left-c");
    }

    // Toggles the zoom controls open or closed depending on the current state
    function navToggle(nav, elToLeft) {
      if (nav.offsetWidth === 0) {
        return openNav(nav, elToLeft);
      } else {
        return closeNav(nav, elToLeft);
      }
    }

    // Puts the zoom level percentage in the zoom controls panel
    function updatePercent(zoomLevel) {
      let zoomPercent = Math.round(zoomLevel * 100);
      let percentageSpan = document.getElementById("zoom-percent-c");
      percentageSpan.innerHTML = zoomPercent + " %";
    }

    // Zooms in the page by the specified increment
    function incrementPercent() {
      chrome.tabs.getZoom(function (zoomLevel) {
        let newZoomLevel = zoomLevel + ZOOM_INCREMENT_AMOUNT / 100;

        // Max zoom that Vivaldi allows is 500 %
        if (newZoomLevel <= 5) {
          chrome.tabs.setZoom(newZoomLevel, updatePercent(newZoomLevel));
        }
      });
    }

    // Zooms out the page by the specified increment
    function decrementPercent() {
      chrome.tabs.getZoom(function (zoomLevel) {
        let newZoomLevel = zoomLevel - ZOOM_INCREMENT_AMOUNT / 100;

        // Min zoom that Vivaldi allows is 20 %
        if (newZoomLevel >= 0.2) {
          chrome.tabs.setZoom(newZoomLevel, updatePercent(newZoomLevel));
        }
      });
    }

    // Sets the zoom back to the default zoom level
    //  - in Vivaldi's settings you can set the default page zoom, this
    //    will follow that if RESET_ZOOM_LEVEL is set to "100"
    function resetZoom() {
      let zoomLevel = RESET_ZOOM_LEVEL / 100;
      chrome.tabs.setZoom(zoomLevel, updatePercent(zoomLevel));
    }

    // For modes 1 and 2:
    // Tracks if you are hovering over the zoom controls
    function zoomPanelHoverTracker() {
      let zoomPanel = document.getElementsByClassName("zoom-panel")[0];
      let elementToTheLeft = zoomPanel.parentElement.parentElement.previousElementSibling;
      let isHovered = false;
      let intervalID = null;
      let count = 0;

      // selects which element must be hovered to trigger action
      let hoverElement;
      if (MODE === 2 && IS_AUTO_OPENED_ON_ADDRESSBAR) {
        let addressBar = document.querySelector(".UrlBar-AddressField");
        hoverElement = addressBar;
      } else {
        let zoomBtnAndPanel = document.getElementById("zoom-hover-target");
        hoverElement = zoomBtnAndPanel;
      }

      // when the element is hovered, reset the interval counter and opens the controls if needed
      hoverElement.onmouseover = function () {
        count = 0;
        isHovered = true;
        if (MODE !== 1) {
          openNav(zoomPanel, elementToTheLeft);
        }
      };

      // when the element loses hover, closes the controls if enough time has passed
      hoverElement.onmouseout = function () {
        // removes any previous counters (needed for if hover is lost and regained multiple times)
        if (intervalID) {
          clearInterval(intervalID);
        }
        isHovered = false;
        // start a counter to see how long it has been since the element was last hovered
        intervalID = setInterval(function () {
          // only increment the counter as long as hover isn't regained
          if (isHovered === false) {
            count++;
          }
          // once the correct amount of time has ellapsed, close the controls panel
          if (count >= FADE_OUT_TIME * 2) {
            closeNav(zoomPanel, elementToTheLeft);
            clearInterval(intervalID);
          }
        }, 500);
      };
    }

    // CHANGE: Added in Update #1
    // updates zoom percentage on tab change
    function tabChangeUpdateZoomWrapper() {
      chrome.tabs.getZoom(function (zoomLevel) {
        let zoomInfo = {
          newZoomFactor: zoomLevel,
        };
        updateZoomIcon(zoomInfo);
      });
    }

    // zoom change listener
    chrome.tabs.onZoomChange.addListener(updateZoomIcon);

    // CHANGE: Added in Update #1
    // Listener for active tab change
    chrome.tabs.onActivated.addListener(tabChangeUpdateZoomWrapper);

    // CHANGE: Added in Update #4
    // Initially load icon, stopped getting added on startup in 3.5
    chrome.tabs.getZoom(function (zoomLevel) {
      let zoomInfo = {
        newZoomFactor: zoomLevel,
      };
      updateZoomIcon(zoomInfo);
    });

    // mutation Observer for Address Bar Changes
    let main = document.getElementsByClassName("mainbar")[0];
    // get the initial state of the addressbar as either urlbar or mailbar
    let oldIsMailBarActive = main.firstChild.classList.contains("toolbar-mailbar");
    let addressBarObserver = new MutationObserver(function (mutations) {
      mutations.forEach(function (mutation) {
        // only re-add on new nodes added. The list addedNodes will only have a
        // length attribute when it contains added nodes
        if (mutation.addedNodes.length) {
          // get the new state of the addressbar
          let isMailBarActive = mutation.addedNodes[0].classList.contains("toolbar-mailbar");

          // if it is different from the previous state, we need to act on it
          if (oldIsMailBarActive !== isMailBarActive) {
            // update the old value for comparisons on future mutations
            oldIsMailBarActive = isMailBarActive;
            // if the addressbar isn't the mailbar, we can re-add the button
            if (!isMailBarActive) {
              // Run all changes that are only in the url bar and not the mail bar
              tabChangeUpdateZoomWrapper();
            }
          }
        }
      });
    });
    addressBarObserver.observe(main, { childList: true });
  }

  // Loop waiting for the browser to load the UI
  let intervalID = setInterval(function () {
    const browser = document.getElementById("browser");
    if (browser) {
      clearInterval(intervalID);
      zoomControl();
    }
  }, 300);
})();
