<script>
  export let data;
  
  const { code, content, title, nextCard } = data;
</script>

<svelte:head>
  <title>{code} - {title} - Ember Harvest 🎃</title>
</svelte:head>

<div class="graincard-wrapper">
  <div class="graincard-content">
    {@html content}
  </div>
</div>

<style>
  .graincard-wrapper {
    max-width: 100%;
    margin: 0 auto;
    padding: 1rem;
  }
  
  .graincard-content {
    font-family: 'Courier New', 'Courier', monospace;
    font-size: 14px;
    line-height: 1.4;
    white-space: pre-wrap;
    overflow-x: auto;
  }
  
  .graincard-content :global(pre) {
    margin: 0;
    padding: 0;
    background: transparent;
  }
  
  .graincard-content :global(code) {
    font-family: inherit;
    background: transparent;
  }
  
  /* Make links visible */
  .graincard-content :global(a) {
    color: var(--orange);
    text-decoration: none;
  }
  
  .graincard-content :global(a:hover) {
    text-decoration: underline;
  }
  
  /* Responsive - adjust font size for mobile */
  @media (max-width: 640px) {
    .graincard-content {
      font-size: 12px;
    }
  }
  
  /* Tablet landscape (MOVIE MODE) */
  @media (min-width: 641px) and (max-width: 1024px) and (orientation: landscape) {
    .graincard-content {
      font-size: 13px;
    }
  }
</style>

