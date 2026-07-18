/* =============================================================
   form-handler.js
   Auto-detects every <form> on the page, intercepts its submit
   event, and POSTs the field values as JSON to the Pabbly webhook
   defined in form-config.js. No external libraries. Vanilla JS only.
   ============================================================= */

(function () {
  "use strict";

  // ---------- Guard: form-config.js must be loaded BEFORE this file ----------
  if (typeof FORM_CONFIG === "undefined") {
    console.error("[form-handler] FORM_CONFIG is missing. Load form-config.js BEFORE form-handler.js.");
    return;
  }

  // ---------- Inject the CSS used by the inline success / error <div>s ----------
  // We do this once per page so each form-handler.js load doesn't duplicate styles.
  function injectStyles() {
    if (document.getElementById("rf-form-handler-styles")) return; // already injected
    const style = document.createElement("style");
    style.id = "rf-form-handler-styles";
    style.textContent = [
      ".form-success-message,.form-error-message{",
      "  display:block;",
      "  margin:14px 0 0 0;",
      "  padding:12px 16px;",
      "  border-radius:6px;",
      "  font-size:15px;",
      "  line-height:1.45;",
      "  font-family:inherit;",
      "}",
      ".form-success-message{",
      "  background:#e6f5ec;",
      "  color:#0f6b34;",
      "  border:1px solid #b6dfc4;",
      "}",
      ".form-error-message{",
      "  background:#fdecec;",
      "  color:#a31515;",
      "  border:1px solid #f1bcbc;",
      "}"
    ].join("");
    document.head.appendChild(style);
  }

  // ---------- Decide whether a given form should be wired up at all ----------
  // We skip the site-wide search popup (it's a GET search box, not a lead form)
  // and any other form that explicitly uses GET.
  function shouldHandleForm(form) {
    // Method attribute: skip GET forms (search boxes, filters, etc.)
    const method = (form.getAttribute("method") || "").toLowerCase();
    if (method === "get") return false;

    // role="search" is a standards-based way to mark search forms — also skip.
    if ((form.getAttribute("role") || "").toLowerCase() === "search") return false;

    // Skip the Brevon search popup specifically (defensive double-check by class).
    if (form.classList.contains("search-popup__form")) return false;

    return true;
  }

  // ---------- Build a {name: value} object from every named input ----------
  // Uses FormData so checkboxes, radios, selects, textareas all work the same.
  function collectFields(form) {
    const data = {};
    const fd = new FormData(form);
    fd.forEach(function (value, key) {
      // If a field name repeats (e.g. multi-select checkboxes), collapse into an array.
      if (Object.prototype.hasOwnProperty.call(data, key)) {
        if (Array.isArray(data[key])) {
          data[key].push(value);
        } else {
          data[key] = [data[key], value];
        }
      } else {
        data[key] = value;
      }
    });
    return data;
  }

  // ---------- Remove any previously-shown success/error message under THIS form ----------
  function clearMessages(form) {
    const prev = form.parentNode.querySelectorAll(
      ":scope > .form-success-message, :scope > .form-error-message"
    );
    prev.forEach(function (n) { n.remove(); });
  }

  // ---------- Insert a message <div> directly after the form ----------
  function showMessage(form, kind, text) {
    const div = document.createElement("div");
    div.className = kind === "success" ? "form-success-message" : "form-error-message";
    div.setAttribute("role", kind === "success" ? "status" : "alert");
    div.setAttribute("aria-live", kind === "success" ? "polite" : "assertive");
    div.textContent = text;
    // Insert as the next sibling of the form so messages are visually attached to it.
    form.parentNode.insertBefore(div, form.nextSibling);
  }

  // ---------- Find the submit button inside the form (first match wins) ----------
  function getSubmitButton(form) {
    return form.querySelector('button[type="submit"], input[type="submit"]');
  }

  // ---------- Toggle the submit button between idle and "Sending..." states ----------
  // We stash the original label on the element itself so we can restore it cleanly.
  function setLoading(form, isLoading) {
    if (!FORM_CONFIG.showLoadingState) return; // user has disabled this behaviour
    const btn = getSubmitButton(form);
    if (!btn) return;

    if (isLoading) {
      btn.disabled = true;
      // <button> uses .innerHTML for rich content (icons); <input type=submit> uses .value.
      if (btn.tagName === "BUTTON") {
        btn.dataset.rfOriginalHtml = btn.innerHTML;
        btn.innerHTML = "Sending...";
      } else {
        btn.dataset.rfOriginalValue = btn.value;
        btn.value = "Sending...";
      }
    } else {
      btn.disabled = false;
      if (btn.tagName === "BUTTON" && btn.dataset.rfOriginalHtml !== undefined) {
        btn.innerHTML = btn.dataset.rfOriginalHtml;
        delete btn.dataset.rfOriginalHtml;
      } else if (btn.dataset.rfOriginalValue !== undefined) {
        btn.value = btn.dataset.rfOriginalValue;
        delete btn.dataset.rfOriginalValue;
      }
    }
  }

  // ---------- The single submit handler attached to every eligible form ----------
  async function handleSubmit(event) {
    const form = event.currentTarget;
    // Prevent the browser from doing a full page reload / GET to the action URL.
    event.preventDefault();

    // Wipe any previous success/error so users don't see stale messaging.
    clearMessages(form);

    // Gather all named field values into a plain object.
    const payload = collectFields(form);

    // ---------- Honeypot check ----------
    // The contact form has a hidden field called cf_website that real users
    // leave blank. Bots usually fill every input. If it's non-empty we
    // silently pretend success — no Pabbly call, no error message,
    // so the bot has no signal to retry.
    if (payload.cf_website && String(payload.cf_website).trim() !== "") {
      if (FORM_CONFIG.clearFormOnSuccess) form.reset();
      showMessage(form, "success", form.dataset.successMessage || FORM_CONFIG.successMessage);
      return;
    }
    // Don't ship the honeypot value to Pabbly even when empty — it's noise.
    delete payload.cf_website;

    // ---------- Inject the two automatic fields required by the spec ----------
    payload.submitted_at = new Date().toISOString();        // ISO 8601 UTC timestamp
    payload.page_url = window.location.href;                // page the form was submitted from

    // Show "Sending..." on the button if the config allows it.
    setLoading(form, true);

    try {
      // ---------- Send to Pabbly ----------
      // Pabbly's webhook endpoint does NOT return CORS headers, so we MUST use
      // mode: "no-cors". The trade-off: the response is opaque (status === 0,
      // body unreadable), so we can't tell success from a 500 at the protocol
      // level — but the request DOES reach Pabbly. Per spec, we treat any
      // fetch that completes without throwing a NETWORK error as a success.
      await fetch(FORM_CONFIG.webhookURL, {
        method: "POST",
        mode: "no-cors",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
      });

      // If we got here, the network request didn't blow up -> count it as success.
      if (FORM_CONFIG.clearFormOnSuccess) form.reset();
      showMessage(form, "success", form.dataset.successMessage || FORM_CONFIG.successMessage);
    } catch (err) {
      // Only true network failures (offline, DNS error, CORS preflight blocked, etc.)
      // land here. Surface the error to the user and the full stack to the console.
      console.error("[form-handler] Submission failed:", err);
      showMessage(form, "error", FORM_CONFIG.errorMessage);
    } finally {
      // Always restore the submit button so the user can try again if needed.
      setLoading(form, false);
    }
  }

  // ---------- Wire up every eligible form once the DOM is ready ----------
  function init() {
    injectStyles();

    // Live NodeList of every form on the page at init time.
    const forms = document.querySelectorAll("form");
    forms.forEach(function (form) {
      if (!shouldHandleForm(form)) return;       // skip search / GET forms
      if (form.dataset.rfBound === "1") return;  // never double-bind the same form
      form.addEventListener("submit", handleSubmit);
      form.dataset.rfBound = "1";
    });
  }

  // Run once the DOM is parsed. If the script is loaded after DOMContentLoaded
  // has already fired (common when placed before </body>), run immediately.
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
