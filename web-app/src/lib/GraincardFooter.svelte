<script>
  import { base } from '$app/paths';
  
  export let code = '';
  export let sortOrder = 0;
  export let totalCards = 1235520;
  
  // Calculate next code based on sort order
  // For now, we'll use the grainorder sequence mapping
  // Eventually this will call the grainorder library
  const grainorderSequence = [
    'xbdghj', 'xbdghk', 'xbdghl', 'xbdghm', 'xbdghn', 'xbdghs', 
    'xbdghv', 'xbdghz', // First 8 for now
    // ... will expand with full grainorder implementation
  ];
  
  const nextCode = sortOrder < grainorderSequence.length - 1 
    ? grainorderSequence[sortOrder + 1] 
    : null;
  
  const prevCode = sortOrder > 0 
    ? grainorderSequence[sortOrder - 1] 
    : null;
</script>

<div class="graincard-footer">
  <div class="footer-content">
    <div class="grainbook-info">
      <span class="grainbook-name">Grainbook: Ember Harvest 🎃</span>
    </div>
    <div class="card-meta">
      <span class="card-number">Card: {code} ({sortOrder + 1} of {totalCards.toLocaleString()})</span>
    </div>
    <div class="navigation">
      {#if nextCode}
        <a href="{base}/grainscript/{nextCode}" class="next-link">
          Next: <strong>{nextCode}</strong> →
        </a>
      {:else}
        <span class="end-marker">End of sequence (more coming...)</span>
      {/if}
    </div>
    <div class="signature">
      <span>now == next + 1 🌾</span>
    </div>
  </div>
</div>

<style>
  .graincard-footer {
    margin: 2rem 0;
    padding: 1.5rem;
    border-top: 2px solid var(--orange);
    background: rgba(255, 130, 0, 0.05);
    font-family: 'Courier New', monospace;
  }
  
  .footer-content {
    display: flex;
    flex-direction: column;
    gap: 0.8rem;
  }
  
  .grainbook-info,
  .card-meta,
  .navigation,
  .signature {
    text-align: center;
  }
  
  .grainbook-name {
    font-size: 1.1em;
    font-weight: bold;
    color: var(--orange);
  }
  
  .card-number {
    opacity: 0.8;
    font-size: 0.95em;
  }
  
  .next-link {
    color: var(--orange);
    text-decoration: none;
    font-size: 1.05em;
    display: inline-block;
    padding: 0.5rem 1rem;
    border: 1px solid var(--orange);
    border-radius: 4px;
    transition: all 0.2s;
  }
  
  .next-link:hover {
    background: var(--orange);
    color: var(--bg);
    transform: translateX(4px);
  }
  
  .next-link strong {
    font-weight: bold;
  }
  
  .end-marker {
    opacity: 0.6;
    font-style: italic;
  }
  
  .signature {
    margin-top: 0.5rem;
    font-size: 0.9em;
    opacity: 0.7;
  }
  
  /* Mobile responsive */
  @media (max-width: 640px) {
    .graincard-footer {
      padding: 1rem;
    }
    
    .next-link {
      font-size: 0.95em;
      padding: 0.4rem 0.8rem;
    }
  }
</style>

