import { error } from '@sveltejs/kit';
import { readFileSync, readdirSync } from 'fs';
import { join } from 'path';

const GRAINSCRIPT_DIR = join(process.cwd(), '../grainstore/grain6pbc/teamdescend14/gkd-prompt-execution--12025-10-26--1700-PDT--moon-mula----------asc-arie05-sun-08h--teamdescend14/grainscript');

export async function load({ params }) {
  const { code } = params;
  
  try {
    // Find file matching the code
    const files = readdirSync(GRAINSCRIPT_DIR);
    const matchingFile = files.find(f => f.startsWith(`${code}-`));
    
    if (!matchingFile) {
      throw error(404, `Graincard ${code} not found`);
    }
    
    const filePath = join(GRAINSCRIPT_DIR, matchingFile);
    const content = readFileSync(filePath, 'utf-8');
    
    // Extract title from first line
    const titleMatch = content.match(/# Graincard \w+ - (.+)/);
    const title = titleMatch ? titleMatch[1] : code;
    
    // Extract next card link
    const nextMatch = content.match(/Next: \[(\w+)\]/);
    const nextCard = nextMatch ? nextMatch[1] : null;
    
    return {
      code,
      title,
      content,
      nextCard
    };
  } catch (err) {
    if (err.status === 404) throw err;
    throw error(500, `Error loading graincard ${code}`);
  }
}

