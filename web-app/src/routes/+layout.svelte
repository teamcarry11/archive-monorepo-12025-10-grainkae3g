<script>
  import '../lib/theme.css';
  import ThemeToggle from '$lib/ThemeToggle.svelte';
  import ContrastToggle from '$lib/ContrastToggle.svelte';
  import LanguageIndicator from '$lib/LanguageIndicator.svelte';
  import UsernameIndicator from '$lib/UsernameIndicator.svelte';
</script>

<LanguageIndicator />
<UsernameIndicator />
<ContrastToggle />
<ThemeToggle />
<slot />

