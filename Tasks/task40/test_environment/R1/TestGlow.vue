<template>
  <div class="relative min-h-screen w-full overflow-hidden">
    <!-- Static background (base color) -->
    <div class="bg-background absolute top-0 -z-20 h-full w-full" />

    <!-- Wire background with animated hue filter -->
    <div class="wire-bg absolute top-0 -z-10 h-full w-full" />

    <!-- Floating orbs overlay -->
    <div class="floating-orbs absolute top-0 h-full w-full">
      <span v-for="n in 3" :key="n" :class="`orb orb-${n}`"></span>
    </div>

    <!-- Content -->
    <slot />
  </div>
  <common-custom-scrollbar />
</template>

<script setup lang="ts"></script>

<style scoped>
/* Base background */
.bg-background {
  background: #0f0f12; /* Dark background */
}

/* Wire Background with animated glowing effect */
.wire-bg {
  background-image: 
    linear-gradient(transparent 0%, transparent 49%, rgba(60, 200, 255, 0.1) 50%, transparent 51%, transparent 100%),
    linear-gradient(90deg, transparent 0%, transparent 49%, rgba(60, 200, 255, 0.1) 50%, transparent 51%, transparent 100%);
  background-size: 40px 40px;
  filter: hue-rotate(0deg) brightness(1.2) saturate(1.5);
  animation: hueShift 20s linear infinite, glowPulse 4s ease-in-out infinite alternate;
}

/* Floating orbs */
.floating-orbs .orb {
  position: absolute;
  border-radius: 50%;
  opacity: 0.6;
  pointer-events: none;
  mix-blend-mode: screen;
}

.orb-1 {
  width: 200px;
  height: 200px;
  background: radial-gradient(circle, rgba(0, 180, 255, 0.4), transparent 70%);
  top: 20%;
  left: 10%;
  animation: float 8s ease-in-out infinite;
}

.orb-2 {
  width: 300px;
  height: 300px;
  background: radial-gradient(circle, rgba(255, 100, 200, 0.3), transparent 70%);
  bottom: 20%;
  right: 15%;
  animation: float 10s ease-in-out infinite reverse;
}

.orb-3 {
  width: 150px;
  height: 150px;
  background: radial-gradient(circle, rgba(200, 255, 100, 0.25), transparent 70%);
  top: 50%;
  right: 10%;
  animation: float 7s ease-in-out infinite 2s;
}

/* Animations */
@keyframes hueShift {
  0% {
    filter: hue-rotate(0deg) brightness(1.2) saturate(1.5);
  }
  100% {
    filter: hue-rotate(360deg) brightness(1.4) saturate(1.6);
  }
}

@keyframes glowPulse {
  0% {
    filter: hue-rotate(0deg) brightness(1.1) saturate(1.5);
  }
  100% {
    filter: hue-rotate(180deg) brightness(1.3) saturate(1.7);
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0) translateX(0);
  }
  50% {
    transform: translateY(-20px) translateX(15px);
  }
}
</style>
