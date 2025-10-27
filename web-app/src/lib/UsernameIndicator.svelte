<script>
  import { onMount } from 'svelte';
  import { base } from '$app/paths';
  
  let username = 'kae3g'; // Default
  
  onMount(async () => {
    try {
      const res = await fetch(`${base}/site-config.json`);
      const config = await res.json();
      username = config.username || 'kae3g';
    } catch (e) {
      console.warn('Could not load site config, using default username');
    }
  });
</script>

<a 
  href="https://github.com/kae3g/grainkae3g/tree/gkd-prompt-execution--12025-10-26--1700-PDT--moon-mula----------asc-arie05-sun-08h--teamdescend14/grainstore/grain6pbc/teamdescend14/gkd-prompt-execution--12025-10-26--1700-PDT--moon-mula----------asc-arie05-sun-08h--teamdescend14/grainscripts"
  class="username-indicator"
  target="_blank"
  rel="noopener noreferrer"
  title="View grainscripts on GitHub"
>{username}</a>

<style>
  .username-indicator {
    text-decoration: none;
    position: fixed;
    top: 20px;
    /* Golden ratio position: ~61.8% from left edge of content column
       Content is max 600px centered, so from center we calculate:
       50% + (61.8% - 50%) * 600px / 100vw for the offset
       Simplified: position at golden ratio between content center and right edge */
    right: calc((100vw - 600px) / 2 + 600px * 0.382);
    color: var(--fg);
    font-size: 0.75em;
    font-family: 'Courier New', monospace;
    opacity: 0.6;
    z-index: 1000;
  }
  
  /* Mobile adjustment - place it left of the toggles with clean spacing */
  @media (max-width: 640px) {
    .username-indicator {
      right: 6.5rem;
    }
  }
</style>

