#!/bin/bash

# Verify all AOI excerpts exist in response files

echo "=== Response 1 AOI Verification ==="

# AOI 3 - Broken URL
grep -q "SDL2 + GTK3 Level Editor Tutorial" /Users/apple/Desktop/Applyloop-project3/Tasks/Task9/RESPONSE_1.md
echo "AOI 3 excerpt found: $?"

# AOI 4 - gdk_window_get_xid
grep -q "gdk_window_get_xid(gdk_window)" /Users/apple/Desktop/Applyloop-project3/Tasks/Task9/RESPONSE_1.md
echo "AOI 4 excerpt found: $?"

# AOI 5 - type mismatch
grep -q "gdk_pixbuf_get_from_surface(sdl_surface" /Users/apple/Desktop/Applyloop-project3/Tasks/Task9/RESPONSE_1.md
echo "AOI 5 excerpt found: $?"

# AOI 6 - undefined sdl_renderer
grep -q "SDL_SetRenderDrawColor(sdl_renderer, 30, 30, 30, 255)" /Users/apple/Desktop/Applyloop-project3/Tasks/Task9/RESPONSE_1.md
echo "AOI 6 excerpt found: $?"

# AOI 7 - undefined sdl_surface
grep -q "gdk_pixbuf_get_from_surface(sdl_surface, 0, 0, width, height)" /Users/apple/Desktop/Applyloop-project3/Tasks/Task9/RESPONSE_1.md
echo "AOI 7 excerpt found: $?"

# AOI 8 - Wayland claim
grep -q "Works on both, but test thoroughly" /Users/apple/Desktop/Applyloop-project3/Tasks/Task9/RESPONSE_1.md
echo "AOI 8 excerpt found: $?"

# AOI 9 - testgles2.c
grep -q "testgles2.c" /Users/apple/Desktop/Applyloop-project3/Tasks/Task9/RESPONSE_1.md
echo "AOI 9 excerpt found: $?"

# AOI 10 - emojis
grep -q "✅" /Users/apple/Desktop/Applyloop-project3/Tasks/Task9/RESPONSE_1.md
echo "AOI 10 excerpt found: $?"

echo ""
echo "=== Response 2 AOI Verification ==="

# Check Response 2 excerpts
grep -q "window_id_str" /Users/apple/Desktop/Applyloop-project3/Tasks/Task9/RESPONSE_2.md
echo "AOI 1 excerpt found: $?"

grep -q "GDK_WINDOW_XID" /Users/apple/Desktop/Applyloop-project3/Tasks/Task9/RESPONSE_2.md
echo "AOI 2 excerpt found: $?"
