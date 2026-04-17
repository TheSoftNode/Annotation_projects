<template>
  <div class="relative min-h-screen w-full">
    <!-- Base background color -->
    <div class="bg-background absolute top-0 -z-20 h-full w-full" />
    
    <!-- The wire background with the glow animation class -->
    <div class="wire-bg absolute top-0 -z-10 h-full w-full wire-glow-animation" />
    
    <!-- Floating orbs overlay -->
    <div class="floating-orbs absolute top-0 h-full w-full">
      <span v-for="_ in 1"></span>
    </div>
    
    <slot />
  </div>
  <common-custom-scrollbar />
</template>

<script setup lang="ts">
// No script changes needed
</script>

<style scoped>
/* 
  This keyframe animation cycles the hue filter. 
  The hue-rotate(0deg) acts as a reset to ensure smooth looping.
*/
@keyframes wire-glow-move {
  0% {
    filter: hue-rotate(0deg) saturate(1.5) brightness(1.1);
  }
  50% {
    /* Rotate colors significantly and boost brightness for the 'glow' effect */
    filter: hue-rotate(180deg) saturate(2) brightness(1.3);
  }
  100% {
    filter: hue-rotate(360deg) saturate(1.5) brightness(1.1);
  }
}

.wire-glow-animation {
  /* Apply the animation: duration | timing-function | iteration */
  animation: wire-glow-move 8s linear infinite;
  
  /* Optional: Ensure the wires texture blends well if it has transparency */
  background-blend-mode: screen; 
}
</style>
