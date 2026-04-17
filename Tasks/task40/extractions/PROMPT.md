make a moving hue filter animation for this components that makes the wires in the backgroun looks like there are  
glowing

\<template\>

  \<div class="relative min-h-screen w-full"\>

    \<div class="bg-background absolute top-0 \-z-20 h-full w-full" /\>

    \<div class="wire-bg absolute top-0 \-z-10 h-full w-full" /\>

    \<\!-- Floating orbs overlay \--\>

    \<div class="floating-orbs absolute top-0 h-full w-full"\>

      \<span v-for="\_ in 1"\>\</span\>

    \</div\>

    \<slot /\>

  \</div\>

  \<common-custom-scrollbar /\>

\</template\>

\<script setup lang="ts"\>\</script\>

