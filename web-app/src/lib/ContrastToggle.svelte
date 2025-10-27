<script>
  import { onMount } from 'svelte';
  
  let contrast = 'low';
  
  onMount(() => {
    // Check localStorage or default to low contrast (Ember Harvest default)
    contrast = localStorage.getItem('contrast') || 'low';
    if (contrast === 'high') {
      document.documentElement.setAttribute('data-contrast', 'high');
    }
  });
  
  function toggleContrast() {
    contrast = contrast === 'low' ? 'high' : 'low';
    if (contrast === 'high') {
      document.documentElement.setAttribute('data-contrast', 'high');
    } else {
      document.documentElement.removeAttribute('data-contrast');
    }
    localStorage.setItem('contrast', contrast);
  }
</script>

<button 
  on:click={toggleContrast}
  class="contrast-toggle"
  aria-label="Toggle contrast"
  title={contrast === 'low' ? 'Switch to high contrast' : 'Switch to low contrast (default)'}
>
  %
</button>

<style>
  .contrast-toggle {
    position: fixed;
    top: 20px;
    /* Position close to the left of the theme toggle (*) - reduced spacing */
    right: max(calc((100vw - 600px) / 2 + 36px), calc(1rem + 36px));
    background: none;
    border: none;
    color: var(--fg);
    font-size: 24px;
    cursor: pointer;
    padding: 8px 10px;
    line-height: 1;
    opacity: 0.6;
    transition: opacity 0.2s ease, transform 0.2s ease;
    font-family: 'Times New Roman', serif;
    z-index: 1000;
  }
  
  .contrast-toggle:hover {
    opacity: 1;
    transform: scale(1.2);
  }
  
  .contrast-toggle:active {
    transform: scale(1.1);
  }
  
  /* Mobile adjustment */
  @media (max-width: 640px) {
    .contrast-toggle {
      right: calc(0.5rem + 36px);
    }
  }
</style>

