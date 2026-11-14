#!/usr/bin/env node
// scripts/new-game-project.mjs
// Scaffold a new BrainZap Phaser project from the vine-trail template.
// Usage: node scripts/new-game-project.mjs --name <game-name> [--description <desc>]
//
// Copies vine-trail's full folder structure: src/, scripts/, tests/, vite/,
// public/, platform/, design/, docs/, .github/workflows/, config files,
// and GitHub workflows. Game-specific values are substituted into templates.
// The result is runnable: `npm ci && npm run dev`.

import {
  existsSync,
  mkdirSync,
  writeFileSync,
  readFileSync,
  readdirSync,
  statSync,
} from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, '..');
const VINE_TRAIL = join(ROOT, '..', 'vine-trail');

// ---------- args ----------
const args = process.argv.slice(2);
let gameName = '';
let gameDescription = '';

for (let i = 0; i < args.length; i++) {
  if (args[i] === '--name' && args[i + 1]) {
    gameName = args[i + 1];
    i++;
  } else if (args[i] === '--description' && args[i + 1]) {
    gameDescription = args[i + 1];
    i++;
  }
}

if (!gameName) {
  console.error(
    'Usage: node scripts/new-game-project.mjs --name <game-name> [--description <desc>]'
  );
  process.exit(1);
}

const kebab = (s) =>
  s.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/-+/g, '-').replace(/^-|-$/g, '');
const titleCase = (s) =>
  s
    .split(/[\s_-]+/)
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(' ');
const pascal = (s) =>
  s
    .split(/[\s_-]+/)
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join('');

const name = gameName;
const nameKebab = kebab(gameName);
const nameTitle = titleCase(gameName);
const namePascal = pascal(gameName);
const description =
  gameDescription || `A new BrainZap game built with Phaser 4 + TypeScript + Vite.`;
const firebaseProjectId = nameKebab;

// Strings to replace across all template files.
// Ordered so longer/more specific matches come first.
const replacements = [
  ['brainzap-vine-trail', firebaseProjectId],
  ['vine-trail', nameKebab],
  ['Vine Trail', nameTitle],
  ['VINE_TRAIL', nameKebab.toUpperCase().replace(/-/g, '_')],
  ['vine trail', nameTitle.toLowerCase()],
  ['One vine. Every tile. Fruit in order.', description],
  ['brainzapgames.com', 'REPLACE_WITH_YOUR_DOMAIN'],
  ['https://brainzapgames.goatcounter.com/count', 'REPLACE_WITH_GOATCOUNTER_ENDPOINT'],
  ['REPLACE_WITH_DEV_MEASUREMENT_ID', 'REPLACE_WITH_DEV_MEASUREMENT_ID'],
  ['REPLACE_WITH_LIVE_MEASUREMENT_ID', 'REPLACE_WITH_LIVE_MEASUREMENT_ID'],
];

// Directories to exclude from copy
const EXCLUDE_DIRS = [
  'node_modules',
  '.git',
  'dist',
  'dist-playgama',
  'releases',
];

function substitute(content) {
  let result = content;
  for (const [from, to] of replacements) {
    result = result.replaceAll(from, to);
  }
  return result;
}

function shouldExclude(relPath) {
  const parts = relPath.split(/[/\\]/);
  return parts.some((p) => EXCLUDE_DIRS.includes(p));
}

function copyTemplate(src, dest, relPath = '') {
  const stat = statSync(src);
  if (stat.isDirectory()) {
    if (!existsSync(dest)) mkdirSync(dest, { recursive: true });
    for (const entry of readdirSync(src)) {
      copyTemplate(join(src, entry), join(dest, entry), join(relPath, entry));
    }
  } else {
    if (shouldExclude(relPath)) return;
    const content = readFileSync(src, 'utf8');
    const destDir = dirname(dest);
    if (!existsSync(destDir)) mkdirSync(destDir, { recursive: true });
    writeFileSync(dest, substitute(content));
  }
}

const targetDir = join(ROOT, '..', nameKebab);

if (existsSync(targetDir)) {
  console.error(`Target directory already exists: ${targetDir}`);
  process.exit(1);
}

console.log(`Scaffolding ${nameTitle} (${nameKebab}) from vine-trail template...`);
copyTemplate(VINE_TRAIL, targetDir);

console.log('\nDone. Next steps:');
console.log(`  cd ${nameKebab}`);
console.log('  npm ci');
console.log('');
console.log('Review these game-content files before committing:');
console.log('  src/data/packs/*.json   (level packs - replace with your own)');
console.log('  public/og-image.png     (Open Graph preview image)');
console.log('  public/thumbnail.webp   (store thumbnail)');
console.log('');
console.log('Set GitHub vars:');
console.log('  FIREBASE_PROJECT_ID, SITE_URL, ASSET_URL,');
console.log('  GA_MEASUREMENT_ID_DEV, GA_MEASUREMENT_ID_LIVE');
console.log('');
console.log('Set GitHub secret:');
console.log('  FIREBASE_SERVICE_ACCOUNT');
console.log('');
console.log("Then run /new-game to write the brief and GDD,");
console.log('and start-milestone for M0 (project setup).');
