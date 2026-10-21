<script>
  import { count } from './stores';

  $: doubled = $count * 2;
  $: {
    console.log(doubled);
  }
</script>

<p>{$count}</p>

<style>
  p {
    font-size: 2em;
  }
</style>
