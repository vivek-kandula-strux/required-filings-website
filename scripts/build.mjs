// scripts/build.mjs
// -----------------------------------------------------------------
// Production build for RequiredFilings.com
// -----------------------------------------------------------------
// Reads:  required-filings/  (source, human-authored)
// Writes: dist/              (minified, ready to zip)
//
// What it does:
//   1. Mirror the source tree into dist/, skipping dev-only files.
//   2. Minify every .html with html-minifier-terser.
//   3. Minify every .css with clean-css.
//   4. Minify every .js (skip already-min files) with terser.
//   5. Run SVGO over .svg (skip logo backups — they're raster-embedded).
//   6. Report per-file byte savings.
//
// Non-goals:
//   - Does NOT rename or fingerprint. Cache-busting is via .htaccess mtime.
//   - Does NOT rewrite links. Filenames stay identical.
//   - Does NOT run PurgeCSS. Deferred until we can safelist all dynamic
//     classes without regressing the wireframe (see build.md Phase 12.4).
// -----------------------------------------------------------------

import { promises as fs } from "node:fs";
import { existsSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

import { minify as minifyHtml } from "html-minifier-terser";
import CleanCSS from "clean-css";
import { minify as minifyJs } from "terser";
import { optimize as optimizeSvg } from "svgo";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const SRC = path.join(ROOT, "required-filings");
const DIST = path.join(ROOT, "dist");

// Files/dirs to skip when mirroring
const EXCLUDE_DIRS = new Set([
  "scss",
  ".gstack",
  "home-2",
  "home-3",
  "home-4",
  "home-5",
  "header", // 5 unreferenced .jpg files
]);
const EXCLUDE_FILES = new Set([
  "audit.sh",
  ".nojekyll",
  "favicon-2.svg",
  "favicon-3.svg",
  "favicon-4.svg",
  "favicon-5.svg",
]);
const EXCLUDE_SUFFIXES = [".map"];

// html-minifier-terser options — conservative, preserves quirks the template relies on
// AND matches the source's html-validate 0-warning state (Phase 18.4).
const HTML_OPTIONS = {
  collapseWhitespace: true,
  conservativeCollapse: true,     // keep at least one space where whitespace mattered
  removeComments: true,
  ignoreCustomComments: [/^!/, /^\s*google/i, /^\s*Pabbly/i], // keep licence + integration markers
  minifyCSS: true,
  minifyJS: true,
  removeAttributeQuotes: false,   // keep quotes — safer for template class chains
  removeRedundantAttributes: false, // KEEP explicit type="text"/type="submit" — html-validate requires them
  removeScriptTypeAttributes: true,
  removeStyleLinkTypeAttributes: true,
  useShortDoctype: false,         // KEEP <!DOCTYPE html> uppercase (html-validate style rule)
  decodeEntities: false,          // preserve ₹ and em-dashes exactly
  sortAttributes: false,
  sortClassName: false,
  processConditionalComments: false,
  keepClosingSlash: false,
};

const cleanCssInstance = new CleanCSS({
  level: {
    1: { all: true },
    2: { all: false, removeDuplicateRules: true, mergeMedia: true },
  },
  returnPromise: true,
});

// svgo 4: preset-default already includes cleanupIds. removeViewBox was moved
// out of preset-default in v3 — disable it separately.
const SVG_CONFIG = {
  multipass: true,
  plugins: [
    {
      name: "preset-default",
      params: {
        overrides: {
          cleanupIds: { minify: false },  // preserve IDs (some CSS/JS targets them)
        },
      },
    },
    // removeViewBox is disabled by omission (it's not in preset-default in svgo 3+)
  ],
};

const stats = {
  htmlBefore: 0, htmlAfter: 0, htmlCount: 0,
  cssBefore: 0, cssAfter: 0, cssCount: 0,
  jsBefore: 0, jsAfter: 0, jsCount: 0,
  svgBefore: 0, svgAfter: 0, svgCount: 0,
  copiedBytes: 0, copiedCount: 0,
  skipped: 0,
};

// -----------------------------------------------------------------
// Utility
// -----------------------------------------------------------------
const fmt = (n) => n.toLocaleString("en-US");
const pct = (before, after) =>
  before === 0 ? "—" : ((1 - after / before) * 100).toFixed(1) + "%";

async function* walk(dir, base = dir) {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  for (const entry of entries) {
    const full = path.join(dir, entry.name);
    const rel = path.relative(base, full);
    if (entry.isDirectory()) {
      if (EXCLUDE_DIRS.has(entry.name)) {
        stats.skipped++;
        continue;
      }
      yield* walk(full, base);
    } else if (entry.isFile()) {
      if (EXCLUDE_FILES.has(entry.name)) { stats.skipped++; continue; }
      if (EXCLUDE_SUFFIXES.some((s) => entry.name.endsWith(s))) { stats.skipped++; continue; }
      yield { full, rel };
    }
  }
}

async function ensureDir(p) {
  await fs.mkdir(path.dirname(p), { recursive: true });
}

// -----------------------------------------------------------------
// Per-file processors
// -----------------------------------------------------------------
async function processHtml(src, dest) {
  const source = await fs.readFile(src, "utf8");
  const minified = await minifyHtml(source, HTML_OPTIONS);
  await ensureDir(dest);
  await fs.writeFile(dest, minified, "utf8");
  stats.htmlCount++;
  stats.htmlBefore += Buffer.byteLength(source, "utf8");
  stats.htmlAfter += Buffer.byteLength(minified, "utf8");
}

async function processCss(src, dest) {
  const source = await fs.readFile(src, "utf8");
  // Skip already-min files — running clean-css on a min bundle rarely helps and
  // risks breaking edge-case syntax that survived the original minification.
  if (src.endsWith(".min.css")) {
    await ensureDir(dest);
    await fs.writeFile(dest, source, "utf8");
    stats.copiedCount++;
    stats.copiedBytes += Buffer.byteLength(source, "utf8");
    return;
  }
  const result = await cleanCssInstance.minify(source);
  if (result.errors.length > 0) {
    console.error(`  ! clean-css errors in ${src}:`, result.errors);
    // Fall back to source on error rather than shipping broken CSS
    await ensureDir(dest);
    await fs.writeFile(dest, source, "utf8");
    return;
  }
  await ensureDir(dest);
  await fs.writeFile(dest, result.styles, "utf8");
  stats.cssCount++;
  stats.cssBefore += Buffer.byteLength(source, "utf8");
  stats.cssAfter += Buffer.byteLength(result.styles, "utf8");
}

async function processJs(src, dest) {
  const source = await fs.readFile(src, "utf8");
  // Skip already-min files
  if (src.endsWith(".min.js")) {
    await ensureDir(dest);
    await fs.writeFile(dest, source, "utf8");
    stats.copiedCount++;
    stats.copiedBytes += Buffer.byteLength(source, "utf8");
    return;
  }
  try {
    const result = await minifyJs(source, {
      compress: {
        drop_console: false,  // keep console — analytics.js uses it for diagnostics
        drop_debugger: true,
        passes: 2,
      },
      mangle: true,
      format: { comments: /^!|@preserve|@license|@cc_on/i },
    });
    await ensureDir(dest);
    await fs.writeFile(dest, result.code, "utf8");
    stats.jsCount++;
    stats.jsBefore += Buffer.byteLength(source, "utf8");
    stats.jsAfter += Buffer.byteLength(result.code, "utf8");
  } catch (e) {
    console.error(`  ! terser failed on ${src}: ${e.message}. Copying source unchanged.`);
    await ensureDir(dest);
    await fs.writeFile(dest, source, "utf8");
  }
}

async function processSvg(src, dest) {
  const source = await fs.readFile(src, "utf8");
  try {
    const result = optimizeSvg(source, { ...SVG_CONFIG, path: src });
    await ensureDir(dest);
    await fs.writeFile(dest, result.data, "utf8");
    stats.svgCount++;
    stats.svgBefore += Buffer.byteLength(source, "utf8");
    stats.svgAfter += Buffer.byteLength(result.data, "utf8");
  } catch (e) {
    console.error(`  ! svgo failed on ${src}: ${e.message}. Copying source unchanged.`);
    await ensureDir(dest);
    await fs.writeFile(dest, source, "utf8");
  }
}

async function copyBinary(src, dest) {
  await ensureDir(dest);
  await fs.copyFile(src, dest);
  const size = (await fs.stat(dest)).size;
  stats.copiedCount++;
  stats.copiedBytes += size;
}

// -----------------------------------------------------------------
// Main
// -----------------------------------------------------------------
async function main() {
  const args = process.argv.slice(2);
  const clean = args.includes("--clean");

  if (!existsSync(SRC)) {
    throw new Error(`Source not found: ${SRC}`);
  }

  if (clean && existsSync(DIST)) {
    console.log(`  cleaning ${DIST} …`);
    await fs.rm(DIST, { recursive: true, force: true });
  }

  console.log(`\n== Building dist/ from required-filings/ ==\n`);
  const start = Date.now();

  for await (const { full, rel } of walk(SRC)) {
    const dest = path.join(DIST, rel);
    const ext = path.extname(full).toLowerCase();

    switch (ext) {
      case ".html":
      case ".htm":
        await processHtml(full, dest);
        break;
      case ".css":
        await processCss(full, dest);
        break;
      case ".js":
      case ".mjs":
        await processJs(full, dest);
        break;
      case ".svg":
        await processSvg(full, dest);
        break;
      default:
        await copyBinary(full, dest);
    }
  }

  const elapsed = ((Date.now() - start) / 1000).toFixed(1);

  console.log("== Results ==\n");
  const rows = [
    ["HTML", stats.htmlCount, stats.htmlBefore, stats.htmlAfter],
    ["CSS",  stats.cssCount,  stats.cssBefore,  stats.cssAfter],
    ["JS",   stats.jsCount,   stats.jsBefore,   stats.jsAfter],
    ["SVG",  stats.svgCount,  stats.svgBefore,  stats.svgAfter],
  ];
  console.log("  Type    Files   Before          After           Saved");
  console.log("  " + "-".repeat(58));
  for (const [name, count, before, after] of rows) {
    console.log(
      `  ${name.padEnd(6)} ${String(count).padStart(5)}   ${fmt(before).padStart(14)}  ${fmt(after).padStart(14)}  ${pct(before, after).padStart(6)}`
    );
  }
  console.log(
    `  Copied ${String(stats.copiedCount).padStart(5)}   ${fmt(stats.copiedBytes).padStart(14)}  (already-min + binary)`
  );
  console.log(`\n  Skipped ${stats.skipped} excluded files/dirs`);
  console.log(`  Elapsed: ${elapsed}s`);
  console.log(`  Output:  ${DIST}\n`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
