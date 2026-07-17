/* =============================================================
   analytics.js
   Consent-gated GA4 + Microsoft Clarity loader with a lightweight
   cookie banner. No third-party dependencies. Vanilla JS only.

   Setup: replace the two TOKENS below with real IDs when the
   client provisions them. Until then, the banner still runs but
   analytics never load.
   ============================================================= */

(function () {
  "use strict";

  var CONSENT_KEY = "rf-consent-v1";
  var GA4_ID     = "[TBD-ga4-id]";     // e.g. "G-XXXXXXXXXX"
  var CLARITY_ID = "[TBD-clarity-id]"; // e.g. "abc123xyz"

  function loadGA4() {
    if (!/^G-[A-Z0-9]+$/.test(GA4_ID)) return;
    var s = document.createElement("script");
    s.async = true;
    s.src = "https://www.googletagmanager.com/gtag/js?id=" + GA4_ID;
    document.head.appendChild(s);
    window.dataLayer = window.dataLayer || [];
    window.gtag = function () { window.dataLayer.push(arguments); };
    window.gtag("js", new Date());
    window.gtag("config", GA4_ID, { anonymize_ip: true });

    // Named conversion events for launch (form submits, tel/whatsapp/email clicks)
    document.addEventListener("submit", function (e) {
      var f = e.target;
      if (f && f.tagName === "FORM" && f.id) {
        window.gtag("event", "form_submit", { form_id: f.id });
      }
    });
    document.addEventListener("click", function (e) {
      var a = e.target.closest && e.target.closest("a[href]");
      if (!a) return;
      var href = a.getAttribute("href") || "";
      if (href.indexOf("tel:") === 0)          window.gtag("event", "phone_click",    { phone: href.slice(4) });
      else if (href.indexOf("mailto:") === 0)  window.gtag("event", "email_click",    { email: href.slice(7) });
      else if (href.indexOf("wa.me/") > -1 ||
               href.indexOf("whatsapp.com") > -1) window.gtag("event", "whatsapp_click");
    });
  }

  function loadClarity() {
    if (!/^[a-z0-9]+$/i.test(CLARITY_ID)) return;
    (function (c, l, a, r, i, t, y) {
      c[a] = c[a] || function () { (c[a].q = c[a].q || []).push(arguments); };
      t = l.createElement(r); t.async = 1; t.src = "https://www.clarity.ms/tag/" + i;
      y = l.getElementsByTagName(r)[0]; y.parentNode.insertBefore(t, y);
    })(window, document, "clarity", "script", CLARITY_ID);
  }

  function loadAll() { loadGA4(); loadClarity(); }

  function showBanner() {
    var style = document.createElement("style");
    style.textContent =
      "#rf-cookie-banner{position:fixed;left:20px;right:20px;bottom:20px;z-index:9999;" +
      "background:#111827;color:#fff;border-radius:8px;box-shadow:0 8px 24px rgba(0,0,0,.25);" +
      "padding:16px 20px;max-width:720px;margin:0 auto;font-family:inherit;font-size:14px;line-height:1.5}" +
      ".rf-cookie-inner{display:flex;align-items:center;justify-content:space-between;gap:16px;flex-wrap:wrap}" +
      "#rf-cookie-banner p{margin:0;flex:1;min-width:220px;color:#e5e7eb}" +
      "#rf-cookie-banner a{color:#f5c977;text-decoration:underline}" +
      ".rf-cookie-actions{display:flex;gap:8px}" +
      ".rf-cookie-btn{border:0;border-radius:4px;padding:8px 16px;font-weight:600;cursor:pointer;font-size:14px;font-family:inherit}" +
      ".rf-cookie-accept{background:#f5c977;color:#111827}" +
      ".rf-cookie-decline{background:transparent;color:#e5e7eb;border:1px solid #4b5563}";
    document.head.appendChild(style);

    var div = document.createElement("div");
    div.id = "rf-cookie-banner";
    div.setAttribute("role", "dialog");
    div.setAttribute("aria-label", "Cookie notice");
    div.innerHTML =
      '<div class="rf-cookie-inner">' +
      '<p>We use cookies to measure site performance and improve your experience. Read our <a href="privacy.html">Privacy Policy</a>.</p>' +
      '<div class="rf-cookie-actions">' +
      '<button type="button" class="rf-cookie-btn rf-cookie-decline">Decline</button>' +
      '<button type="button" class="rf-cookie-btn rf-cookie-accept">Accept</button>' +
      "</div></div>";
    document.body.appendChild(div);

    div.querySelector(".rf-cookie-accept").addEventListener("click", function () {
      try { localStorage.setItem(CONSENT_KEY, "granted"); } catch (e) {}
      div.remove();
      loadAll();
    });
    div.querySelector(".rf-cookie-decline").addEventListener("click", function () {
      try { localStorage.setItem(CONSENT_KEY, "denied"); } catch (e) {}
      div.remove();
    });
  }

  function bootstrap() {
    var state;
    try { state = localStorage.getItem(CONSENT_KEY); } catch (e) { state = null; }
    if (state === "granted") loadAll();
    else if (!state)        showBanner();
    // "denied" - do nothing
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", bootstrap);
  } else {
    bootstrap();
  }
})();
