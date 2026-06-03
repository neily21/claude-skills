---
name: liquid-glass-ui
description: |
  Create Apple-style Liquid Glass UI interfaces for web applications, dashboards, and data visualizations.
  Use this skill when building: glassmorphism UIs, BI dashboards with glass effects, data visualization panels,
  iOS 26-inspired web interfaces, translucent navigation bars, floating glass cards, or any UI requiring
  the distinctive Apple Liquid Glass aesthetic with blur, refraction, and specular highlights.
  Includes comprehensive theming for Apache ECharts, Vega-Lite, Chart.js, and Recharts.
  TRIGGERS: "liquid glass", "glassmorphism", "iOS 26 style", "Apple glass UI", "frosted glass dashboard",
  "translucent interface", "glass effect", "blur UI", "glass cards", "floating glass panels", "Apple design",
  "glass morphism", "frosted UI", "transparent cards", "glass navigation", "blur background UI",
  "echarts glass", "vega-lite glass", "glass charts", "glass dashboard", "echarts theme", "vega theme".
---

# Liquid Glass UI Design System

Create polished, Apple-style Liquid Glass interfaces combining translucency, refraction, depth, and motion responsiveness.

## Core Principles

1. **Hierarchy First**: Glass floats controls above content—content leads, controls recede
2. **Navigation Only**: Apply glass to toolbars, sidebars, cards, modals—never to content (tables, lists, media)
3. **Adaptive Material**: Glass responds to background, light, and interaction states

## Visual Specifications

| Property | Light Mode | Dark Mode |
|----------|------------|-----------|
| Background | `rgba(255,255,255,0.15-0.25)` | `rgba(0,0,0,0.2-0.4)` |
| Blur | 12-20px | 16-24px |
| Border | `rgba(255,255,255,0.25-0.4)` | `rgba(255,255,255,0.1-0.2)` |
| Saturation | 180% | 150% |

## Quick Start - Basic Glass Card

```css
.glass-card {
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

## Reference Files

- **[CSS Patterns](references/css-patterns.md)**: Complete CSS implementations, SVG filters, animations, dark mode
- **[React Patterns](references/react-patterns.md)**: React/JSX components with hooks and Tailwind
- **[Dashboard Patterns](references/dashboard-patterns.md)**: BI dashboards, Apache ECharts, Vega-Lite, Chart.js, Recharts glass themes

## Supported Chart Libraries

| Library | Support | Features |
|---------|---------|----------|
| **Apache ECharts** | ✅ Full | Theme object, React component, line/bar/pie/gauge examples |
| **Vega-Lite** | ✅ Full | Config object, React component, declarative specs, CSS tooltip override |
| **Chart.js** | ✅ Full | Global defaults, gradient helpers, tooltip styling |
| **Recharts** | ✅ Full | Custom tooltip component, gradient definitions |

## Design Rules

### Apply Glass To
- Navigation bars, tab bars, sidebars
- Floating panels, modals, sheets
- Cards, tooltips, popovers
- Toolbars, action bars

### Never Apply Glass To
- Data tables, lists, grids
- Content areas, media players
- Form inputs (use glass containers instead)
- Other glass elements (no glass-on-glass)

## Semantic Color Tinting

Use tints sparingly for meaning:
```css
/* Primary Action */  rgba(59, 130, 246, 0.15)
/* Success */         rgba(34, 197, 94, 0.12)
/* Warning */         rgba(251, 191, 36, 0.12)
/* Danger */          rgba(239, 68, 68, 0.12)
```

## Typography on Glass

- Use SF Pro, system-ui, or -apple-system font stack
- Apply subtle text-shadow: `0 1px 2px rgba(0,0,0,0.1)`
- Maintain WCAG AA contrast (4.5:1 minimum)
- White text with glass works best on dark/colorful backgrounds

## Accessibility Requirements

Always include reduced transparency fallback:
```css
@media (prefers-reduced-transparency: reduce) {
  .glass-card {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: none;
  }
}
```

## Common Mistakes to Avoid

1. Using `opacity` property (breaks backdrop-filter)—use rgba() instead
2. Forgetting `-webkit-backdrop-filter` prefix
3. Over-blurring (stay in 12-20px range)
4. Stacking glass on glass (causes rendering issues)
5. Applying glass to content instead of navigation
