import { error } from '@sveltejs/kit';

export async function load({ params }) {
  const { code } = params;
  
  // Valid grain codes
  const validCodes = ['xbdghj', 'xbdghk', 'xbdghl', 'xbdghn', 'xbdghs', 'xbdghv'];
  
  if (!validCodes.includes(code)) {
    throw error(404, `Grain ${code} not found`);
  }
  
  // Grain titles mapping
  const titles = {
    'xbdghj': 'Grainbranch README Sync (Ketos Primary)',
    'xbdghk': 'Babashka Comparison',
    'xbdghl': 'Graincard Format Specification',
    'xbdghn': 'Grainorder Alphabet System',
    'xbdghs': 'Graintime Temporal Calculation',
    'xbdghv': 'Moon Cycles and Branching'
  };
  
  // TODO: Load actual grain content from markdown files
  // For now, return basic structure
  const content = `
    <div class="grain-box">
      <h1>Grain ${code}</h1>
      <h2>${titles[code]}</h2>
      <p class="loading-note">
        <em>Grain content will be loaded from markdown files.<br>
        Currently showing placeholder. Check GitHub for full content.</em>
      </p>
      <p>
        <a href="https://github.com/kae3g/grainkae3g/tree/gkd-prompt-execution--12025-10-27--0145-PDT--moon-p_ashadha----asc-leo023-sun-03h----teamdescend14/grainstore/grain12pbc/teamdescend14/gkd-prompt-execution--12025-10-27--0145-PDT--moon-p_ashadha----asc-leo023-sun-03h----teamdescend14/grains/${code}-*.md" 
           target="_blank">
          View on GitHub →
        </a>
      </p>
    </div>
  `;
  
  return {
    code,
    title: titles[code],
    content
  };
}

