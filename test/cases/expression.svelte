<script>
  let count = 0;
</script>

<button on:click={() => count > 1 && reset()}>
  Reset
</button>

<button
  class="primary"
  on:click={() => {
    count += 1;
  }}
>
  Add
</button>

<input bind:value={name} on:input={(e) => update(e.target.value)} />

<p class={count > 1 ? 'many' : 'one'}>{count > 1 ? 'Many' : 'One'}</p>
