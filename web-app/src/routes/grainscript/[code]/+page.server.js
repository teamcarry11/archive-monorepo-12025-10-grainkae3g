import { error } from '@sveltejs/kit';
import { readFileSync, readdirSync } from 'fs';
import { join } from 'path';

const GRAINSCRIPT_DIR = join(process.cwd(), '../grainstore/grain12pbc/teamdescend14/gkd-prompt-execution--12025-10-26--1700-PDT--moon-mula----------asc-arie05-sun-08h--teamdescend14/grainscript');

// Grainorder sequence (first 100 cards)
// This will eventually call the grainorder library
const grainorderSequence = [
  'xbdghj', 'xbdghk', 'xbdghl', 'xbdghm', 'xbdghn', 'xbdghs', 
  'xbdghv', 'xbdghz', // ... more will be generated
];

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
    let content = readFileSync(filePath, 'utf-8');
    
    // Extract title from first line
    const titleMatch = content.match(/# Graincard \w+ - (.+)/);
    const title = titleMatch ? titleMatch[1] : code;
    
    // STRIP the GitHub-specific bottom metadata from the ASCII box
    // Keep everything UP TO the closing └─── line
    // The Svelte GraincardFooter component will replace it
    const footerStart = content.indexOf('├──────────────────────────────────────────────────────────────────────────────┤');
    if (footerStart > 0) {
      // Keep content up to and including the separator line, then close the box
      content = content.substring(0, footerStart) + 
                '└──────────────────────────────────────────────────────────────────────────────┘\n```';
    }
    
    // Get sort order from grainorder sequence
    const sortOrder = grainorderSequence.indexOf(code);
    
    return {
      code,
      title,
      content,
      sortOrder: sortOrder >= 0 ? sortOrder : 0
    };
  } catch (err) {
    if (err.status === 404) throw err;
    throw error(500, `Error loading graincard ${code}`);
  }
}

