<script>
  let { items, children } = $props();
  let count = $state(0);
  let doubled = $derived(count * 2);

  $effect(() => {
    console.log(count);
  });
</script>

<button onclick={() => count++}>
  {count} doubled is {doubled}
</button>

{#snippet row(item)}
  <li>{item.name}</li>
{/snippet}

<ul>
  {#each items as item}
    {@render row(item)}
  {/each}
</ul>

{#if count > 1}
  {@const half = count / 2}
  <p>{half}</p>
{/if}

{@render children?.()}
