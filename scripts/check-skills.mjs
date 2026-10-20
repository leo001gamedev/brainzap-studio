#!/usr/bin/env node
// Check every skill against claude.ai's upload rules, so a bad edit fails here instead of in the upload dialog.
// Usage: node scripts/check-skills.mjs [skills-dir]
import { existsSync, readdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const ALLOWED_KEYS = ['name', 'description', 'license', 'compatibility', 'metadata', 'allowed-tools'];
const MAX_NAME = 64;
const MAX_DESCRIPTION = 1024;
const NAME_PATTERN = /^[a-z0-9]+(-[a-z0-9]+)*$/;
const RESERVED_WORDS = /anthropic|claude/;

const root = process.argv[2] ?? join(dirname(fileURLToPath(import.meta.url)), '..', 'skills');

// Top-level frontmatter keys and their values; indented lines continue the previous key.
function readFrontmatter(text) {
    const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---(\r?\n|$)/);
    if (!match) return null;
    const fields = {};
    let key = null;
    for (const line of match[1].split(/\r?\n/)) {
        const top = line.match(/^([^\s:#][^:]*):\s*(.*)$/);
        if (top) {
            key = top[1].trim();
            fields[key] = top[2];
        } else if (key && /^\s+\S/.test(line)) {
            fields[key] += ' ' + line.trim();
        }
    }
    for (const k of Object.keys(fields)) {
        fields[k] = fields[k].replace(/^[>|][-+]?\s*/, '').replace(/^(['"])(.*)\1$/, '$2').trim();
    }
    return fields;
}

function checkSkill(dir, name) {
    const problems = [];
    const file = join(dir, 'SKILL.md');
    if (!existsSync(file)) return ['missing SKILL.md'];

    const fields = readFrontmatter(readFileSync(file, 'utf8'));
    if (!fields) return ['SKILL.md must start with a --- frontmatter block'];

    for (const key of Object.keys(fields)) {
        if (!ALLOWED_KEYS.includes(key)) problems.push(`frontmatter key "${key}" is not allowed (allowed: ${ALLOWED_KEYS.join(', ')})`);
    }

    const skillName = fields.name ?? '';
    if (!skillName) problems.push('frontmatter has no name');
    else {
        if (skillName !== name) problems.push(`name "${skillName}" must match its folder "${name}"`);
        if (!NAME_PATTERN.test(skillName)) problems.push(`name "${skillName}" may only use lowercase letters, digits and single hyphens`);
        if (skillName.length > MAX_NAME) problems.push(`name is ${skillName.length} characters (max ${MAX_NAME})`);
        if (RESERVED_WORDS.test(skillName)) problems.push(`name "${skillName}" contains a reserved word (anthropic, claude)`);
    }

    const description = fields.description ?? '';
    if (!description) problems.push('frontmatter has no description');
    else {
        if (description.length > MAX_DESCRIPTION) problems.push(`description is ${description.length} characters (max ${MAX_DESCRIPTION})`);
        if (/<[^>]+>/.test(description)) problems.push('description must not contain XML tags');
    }
    return problems;
}

const skills = readdirSync(root).filter((entry) => statSync(join(root, entry)).isDirectory());
let failed = false;
for (const name of skills) {
    const problems = checkSkill(join(root, name), name);
    if (problems.length === 0) {
        console.log(`ok      ${name}`);
    } else {
        failed = true;
        for (const problem of problems) console.log(`FAIL    ${name}: ${problem}`);
    }
}
if (skills.length === 0) {
    console.log(`no skills found in ${root}`);
    failed = true;
}
process.exit(failed ? 1 : 0);
