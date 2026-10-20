<script>
  import Nested from './Nested.svelte';
  import * as UI from './ui';

  export let user;
  let name = 'world';
  let checked = false;
  $: doubled = count * 2;
</script>

<svelte:head>
  <title>Hello {name}</title>
</svelte:head>

{#if user.loggedIn}
  <button on:click={() => count > 1 && toggle()}>Log out</button>
{:else if user.pending}
  <p>Waiting</p>
{:else}
  <button on:click|once={toggle}>Log in</button>
{/if}

<ul>
  {#each items as item, i (item.id)}
    <li class:active={i === current} data-id={item.id}>{item.name}</li>
  {:else}
    <li>No items</li>
  {/each}
</ul>

{#await promise}
  <p>Loading</p>
{:then value}
  <p>{value}</p>
{:catch error}
  <p>{error.message}</p>
{/await}

{#key name}
  <Nested {name} bind:checked />
  <UI.Button />
{/key}

<p>{@html content}</p>
{@debug name}
