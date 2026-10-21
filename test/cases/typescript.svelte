<script lang="ts">
  import type { Item } from './types';

  let { items }: { items: Item[] } = $props();
  let count: number = $state(0);
  const name = 'world';

  function add(item: Item): void {
    if (item) {
      items.push(item);
    }
  }
</script>

<p>{name} {count}</p>
