<script>
  import { base } from '$app/paths';
  import { onMount } from 'svelte';
  export let data;
  
  let loading = true;
  
  onMount(() => {
    // Simulate brief loading for smooth transition
    setTimeout(() => {
      loading = false;
    }, 200);
  });
  
  // Grainorder sequence for navigation
  const grainSequence = [
    'xbdghj', 'xbdghk', 'xbdghl', 'xbdghn', 'xbdghs', 'xbdghv'
    // ... more as we add them
  ];
  
  function getNextGrain(currentCode) {
    const currentIndex = grainSequence.indexOf(currentCode);
    if (currentIndex >= 0 && currentIndex < grainSequence.length - 1) {
      return grainSequence[currentIndex + 1];
    }
    return null;
  }
  
  function getPrevGrain(currentCode) {
    const currentIndex = grainSequence.indexOf(currentCode);
    if (currentIndex > 0) {
      return grainSequence[currentIndex - 1];
    }
    return null;
  }
  
  $: nextGrain = getNextGrain(data.code);
  $: prevGrain = getPrevGrain(data.code);
  $: grainIndex = grainSequence.indexOf(data.code) + 1;
</script>

<svelte:head>
  <title>Grain {data.code} - Ember Harvest 🎃</title>
</svelte:head>

{#if loading}
  <div class="loading">
    <div class="pumpkin-loader">🎃</div>
    <p>Loading grain {data.code}...</p>
  </div>
{:else}
  <nav class="grain-nav">
    <a href="{base}/grainscript" class="back-link">← All grains</a>
    <span class="grain-position">Grain {grainIndex} of {grainSequence.length}</span>
  </nav>
  
  <article class="grain-content">
    {@html data.content || '<p>Grain content loading...</p>'}
  </article>
  
  <nav class="grain-footer-nav">
    {#if prevGrain}
      <a href="{base}/grainscript/{prevGrain}" class="prev-grain">← {prevGrain}</a>
    {:else}
      <span class="nav-disabled">← (first)</span>
    {/if}
    
    <a href="{base}/grainscript" class="all-grains">All grains</a>
    
    {#if nextGrain}
      <a href="{base}/grainscript/{nextGrain}" class="next-grain">{nextGrain} →</a>
    {:else}
      <span class="nav-disabled">(last) →</span>
    {/if}
  </nav>
  
  <div class="grain-footer">
    <p class="meta">Grain {data.code} • Grainbook Issue 1: Ember Harvest 🎃</p>
    <p class="meta">now == next + 1 🌾</p>
  </div>
{/if}

<style>
  .loading {
    text-align: center;
    padding: 4em 2em;
    min-height: 50vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  
  .pumpkin-loader {
    font-size: 4em;
    animation: pumpkin-pulse 1.5s ease-in-out infinite, pumpkin-glow 2s ease-in-out infinite;
  }
  
  @keyframes pumpkin-pulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.1); }
  }
  
  @keyframes pumpkin-glow {
    0%, 100% { filter: drop-shadow(0 0 5px var(--pumpkin)); }
    50% { filter: drop-shadow(0 0 20px var(--pumpkin)) drop-shadow(0 0 30px var(--ember)); }
  }
  
  .loading p {
    font-family: 'Courier New', monospace;
    opacity: 0.7;
    margin-top: 1em;
  }
  
  .grain-nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1em 0;
    border-bottom: 1px solid var(--bd);
    margin-bottom: 2em;
  }
  
  .back-link {
    font-family: 'Courier New', monospace;
    color: var(--lk);
    text-decoration: none;
    opacity: 0.8;
  }
  
  .back-link:hover {
    opacity: 1;
    text-decoration: underline;
  }
  
  .grain-position {
    font-family: 'Courier New', monospace;
    font-size: 0.9em;
    opacity: 0.6;
  }
  
  .grain-content {
    font-family: 'Courier New', monospace;
    line-height: 1.5;
    margin: 2em 0;
  }
  
  .grain-footer-nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 2em 0 1em 0;
    border-top: 1px solid var(--bd);
    margin-top: 3em;
    font-family: 'Courier New', monospace;
  }
  
  .prev-grain, .next-grain, .all-grains {
    color: var(--lk);
    text-decoration: none;
    padding: 0.5em 1em;
    border-radius: 4px;
    transition: background-color 0.2s ease;
  }
  
  .prev-grain:hover, .next-grain:hover, .all-grains:hover {
    background: var(--pumpkin-glow);
    text-decoration: none;
  }
  
  .nav-disabled {
    opacity: 0.3;
    font-style: italic;
  }
  
  .grain-footer {
    text-align: center;
    padding: 2em 0;
    opacity: 0.6;
  }
  
  .grain-footer .meta {
    font-family: 'Courier New', monospace;
    font-size: 0.85em;
    margin: 0.5em 0;
  }
  
  /* Mobile responsive */
  @media (max-width: 640px) {
    .grain-nav {
      flex-direction: column;
      gap: 0.5em;
      align-items: flex-start;
    }
    
    .grain-footer-nav {
      flex-wrap: wrap;
      gap: 0.5em;
      justify-content: center;
    }
    
    .pumpkin-loader {
      font-size: 3em;
    }
  }
</style>
