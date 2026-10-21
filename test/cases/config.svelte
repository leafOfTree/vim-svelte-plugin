<template lang="pug">
div
  p(class="a") hello
</template>

<script>
  export let name = 'world';
  $: doubled = count * 2;
</script>

<script lang="ts">
  let count: number = 0;
</script>

<script lang='coffee'>
  greeting = 'Hello'
</script>

<p class:active={name}>Hello {name}</p>

<style lang=less>
@w: 10px;
p {
  width: @w;
}
</style>

<style lang="scss">
$a: 1px;
p {
  a {
    margin: $a;
  }
}
</style>

<style lang="sass">
p
  color: red
</style>
