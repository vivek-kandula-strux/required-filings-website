// scripts/preview.mjs
// Serve dist/ locally to verify the production build.
// No dependencies — uses Node's built-in http + fs.
import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..", "dist");
const PORT = Number(process.env.PORT || 8080);

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".css":  "text/css; charset=utf-8",
  ".js":   "text/javascript; charset=utf-8",
  ".mjs":  "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".svg":  "image/svg+xml",
  ".png":  "image/png",
  ".jpg":  "image/jpeg",
  ".jpeg": "image/jpeg",
  ".webp": "image/webp",
  ".ico":  "image/x-icon",
  ".woff2":"font/woff2",
  ".xml":  "application/xml",
  ".txt":  "text/plain; charset=utf-8",
};

if (!fs.existsSync(ROOT)) {
  console.error(`dist/ not found. Run "npm run build" first.`);
  process.exit(1);
}

const server = http.createServer((req, res) => {
  let url = decodeURIComponent(req.url.split("?")[0]);
  if (url === "/") url = "/index.html";
  const target = path.join(ROOT, url);
  // Prevent path traversal
  if (!target.startsWith(ROOT)) {
    res.writeHead(403).end("forbidden");
    return;
  }
  fs.stat(target, (err, stat) => {
    if (err || !stat.isFile()) {
      // Try appending .html for extension-less URLs
      const alt = target + ".html";
      if (fs.existsSync(alt)) return serve(alt, res);
      // 404 → serve custom 404.html
      const notFound = path.join(ROOT, "404.html");
      if (fs.existsSync(notFound)) {
        res.writeHead(404, { "Content-Type": MIME[".html"] });
        fs.createReadStream(notFound).pipe(res);
      } else {
        res.writeHead(404).end("not found");
      }
      return;
    }
    serve(target, res);
  });
});

function serve(file, res) {
  const ext = path.extname(file).toLowerCase();
  res.writeHead(200, { "Content-Type": MIME[ext] || "application/octet-stream" });
  fs.createReadStream(file).pipe(res);
}

server.listen(PORT, () => {
  console.log(`\n  dist/ preview at http://localhost:${PORT}/\n`);
});
