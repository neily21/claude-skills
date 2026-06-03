# Liquid Glass CSS Patterns

Complete CSS implementations for Apple-style Liquid Glass effects.

## Table of Contents
1. [Base Glass Classes](#base-glass-classes)
2. [SVG Refraction Filter](#svg-refraction-filter)
3. [Glass Variants](#glass-variants)
4. [Interactive States](#interactive-states)
5. [Dark Mode](#dark-mode)
6. [Animations](#animations)
7. [Complete Example](#complete-example)

---

## Base Glass Classes

### Standard Glass Card
```css
.glass {
  background: rgba(255, 255, 255, 0.18);
  backdrop-filter: blur(16px) saturate(180%);
  -webkit-backdrop-filter: blur(16px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.25);
  border-radius: 20px;
  box-shadow:
    0 8px 32px rgba(0, 0, 0, 0.12),
    inset 0 1px 0 rgba(255, 255, 255, 0.4);
}
```

### Glass with Specular Highlight
```css
.glass-specular {
  position: relative;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(16px) saturate(180%);
  -webkit-backdrop-filter: blur(16px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 24px;
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.15);
}

.glass-specular::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 50%;
  background: linear-gradient(
    180deg,
    rgba(255, 255, 255, 0.3) 0%,
    rgba(255, 255, 255, 0) 100%
  );
  border-radius: 24px 24px 0 0;
  pointer-events: none;
}
```

### Glass Navigation Bar
```css
.glass-navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 64px;
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  z-index: 1000;
}
```

### Glass Sidebar
```css
.glass-sidebar {
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  width: 280px;
  background: rgba(255, 255, 255, 0.12);
  backdrop-filter: blur(24px) saturate(150%);
  -webkit-backdrop-filter: blur(24px) saturate(150%);
  border-right: 1px solid rgba(255, 255, 255, 0.15);
  box-shadow: 4px 0 24px rgba(0, 0, 0, 0.08);
}
```

---

## SVG Refraction Filter

True Liquid Glass includes edge refraction. Add this SVG to your HTML:

```html
<svg style="position: absolute; width: 0; height: 0;">
  <defs>
    <filter id="liquid-glass-filter" x="-50%" y="-50%" width="200%" height="200%">
      <!-- Turbulence for organic distortion -->
      <feTurbulence type="fractalNoise" baseFrequency="0.01" numOctaves="3" result="noise" />

      <!-- Displacement map for refraction -->
      <feDisplacementMap in="SourceGraphic" in2="noise" scale="8" xChannelSelector="R" yChannelSelector="G" result="displaced" />

      <!-- Gaussian blur for softness -->
      <feGaussianBlur in="displaced" stdDeviation="0.5" result="blurred" />

      <!-- Specular lighting for highlights -->
      <feSpecularLighting in="blurred" surfaceScale="2" specularConstant="1" specularExponent="20" result="specular">
        <fePointLight x="100" y="50" z="200" />
      </feSpecularLighting>

      <!-- Composite everything -->
      <feComposite in="specular" in2="SourceGraphic" operator="arithmetic" k1="0" k2="1" k3="0.3" k4="0" />
    </filter>
  </defs>
</svg>
```

Apply with:
```css
.glass-refraction {
  filter: url(#liquid-glass-filter);
}
```

---

## Glass Variants

### Clear Glass (High Transparency)
```css
.glass-clear {
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(12px) saturate(120%);
  -webkit-backdrop-filter: blur(12px) saturate(120%);
  border: 1px solid rgba(255, 255, 255, 0.1);
}
```

### Frosted Glass (More Opacity)
```css
.glass-frosted {
  background: rgba(255, 255, 255, 0.35);
  backdrop-filter: blur(20px) saturate(200%);
  -webkit-backdrop-filter: blur(20px) saturate(200%);
  border: 1px solid rgba(255, 255, 255, 0.4);
}
```

### Tinted Glass
```css
.glass-tinted-blue {
  background: rgba(59, 130, 246, 0.15);
  backdrop-filter: blur(16px) saturate(180%);
  -webkit-backdrop-filter: blur(16px) saturate(180%);
  border: 1px solid rgba(59, 130, 246, 0.25);
}

.glass-tinted-purple {
  background: rgba(139, 92, 246, 0.15);
  backdrop-filter: blur(16px) saturate(180%);
  -webkit-backdrop-filter: blur(16px) saturate(180%);
  border: 1px solid rgba(139, 92, 246, 0.25);
}
```

---

## Interactive States

### Hover Effect
```css
.glass-interactive {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.glass-interactive:hover {
  transform: translateY(-2px) scale(1.01);
  background: rgba(255, 255, 255, 0.22);
  box-shadow:
    0 12px 40px rgba(0, 0, 0, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 0.5);
}

.glass-interactive:active {
  transform: translateY(0) scale(0.99);
}
```

### Glass Button
```css
.glass-button {
  padding: 12px 24px;
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(12px) saturate(180%);
  -webkit-backdrop-filter: blur(12px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 12px;
  color: white;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow:
    0 4px 16px rgba(0, 0, 0, 0.1),
    inset 0 1px 0 rgba(255, 255, 255, 0.3);
}

.glass-button:hover {
  background: rgba(255, 255, 255, 0.28);
  transform: translateY(-1px);
  box-shadow:
    0 6px 20px rgba(0, 0, 0, 0.12),
    inset 0 1px 0 rgba(255, 255, 255, 0.4);
}

.glass-button:active {
  transform: translateY(0);
  background: rgba(255, 255, 255, 0.15);
}
```

---

## Dark Mode

```css
@media (prefers-color-scheme: dark) {
  .glass {
    background: rgba(0, 0, 0, 0.25);
    border-color: rgba(255, 255, 255, 0.1);
    box-shadow:
      0 8px 32px rgba(0, 0, 0, 0.4),
      inset 0 1px 0 rgba(255, 255, 255, 0.1);
  }

  .glass-navbar {
    background: rgba(0, 0, 0, 0.6);
    border-bottom-color: rgba(255, 255, 255, 0.08);
  }

  .glass-sidebar {
    background: rgba(0, 0, 0, 0.4);
    border-right-color: rgba(255, 255, 255, 0.06);
  }
}
```

### Manual Dark Mode Classes
```css
.dark .glass {
  background: rgba(0, 0, 0, 0.25);
  border-color: rgba(255, 255, 255, 0.1);
}

.dark .glass-frosted {
  background: rgba(0, 0, 0, 0.45);
  border-color: rgba(255, 255, 255, 0.15);
}
```

---

## Animations

### Fade In Glass
```css
@keyframes glass-fade-in {
  from {
    opacity: 0;
    transform: translateY(10px) scale(0.98);
    backdrop-filter: blur(0px);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
    backdrop-filter: blur(16px);
  }
}

.glass-animate-in {
  animation: glass-fade-in 0.4s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}
```

### Shimmer Effect
```css
@keyframes glass-shimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}

.glass-shimmer::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(255, 255, 255, 0.15) 50%,
    transparent 100%
  );
  background-size: 200% 100%;
  animation: glass-shimmer 2s ease-in-out infinite;
  pointer-events: none;
  border-radius: inherit;
}
```

### Pulse Glow
```css
@keyframes glass-pulse {
  0%, 100% {
    box-shadow:
      0 8px 32px rgba(0, 0, 0, 0.12),
      inset 0 1px 0 rgba(255, 255, 255, 0.4);
  }
  50% {
    box-shadow:
      0 8px 40px rgba(59, 130, 246, 0.2),
      inset 0 1px 0 rgba(255, 255, 255, 0.5);
  }
}

.glass-pulse {
  animation: glass-pulse 3s ease-in-out infinite;
}
```

---

## Complete Example

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Liquid Glass UI</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      min-height: 100vh;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', sans-serif;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }

    .glass-card {
      width: 100%;
      max-width: 400px;
      padding: 32px;
      background: rgba(255, 255, 255, 0.18);
      backdrop-filter: blur(16px) saturate(180%);
      -webkit-backdrop-filter: blur(16px) saturate(180%);
      border: 1px solid rgba(255, 255, 255, 0.25);
      border-radius: 24px;
      box-shadow:
        0 8px 32px rgba(0, 0, 0, 0.12),
        inset 0 1px 0 rgba(255, 255, 255, 0.4);
      color: white;
    }

    .glass-card h1 {
      font-size: 1.5rem;
      font-weight: 600;
      margin-bottom: 8px;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }

    .glass-card p {
      opacity: 0.9;
      line-height: 1.6;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }

    @media (prefers-reduced-transparency: reduce) {
      .glass-card {
        background: rgba(102, 126, 234, 0.95);
        backdrop-filter: none;
      }
    }
  </style>
</head>
<body>
  <div class="glass-card">
    <h1>Liquid Glass</h1>
    <p>A beautiful translucent card with the signature Apple Liquid Glass effect.</p>
  </div>
</body>
</html>
```

---

## Accessibility Fallbacks

Always include:
```css
@media (prefers-reduced-transparency: reduce) {
  .glass,
  .glass-card,
  .glass-navbar,
  .glass-sidebar {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: none;
    -webkit-backdrop-filter: none;
  }
}

@media (prefers-reduced-motion: reduce) {
  .glass-animate-in,
  .glass-shimmer::after,
  .glass-pulse {
    animation: none;
  }

  .glass-interactive {
    transition: none;
  }
}
```
