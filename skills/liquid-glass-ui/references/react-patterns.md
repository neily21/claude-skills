# Liquid Glass React Patterns

React components and hooks for Apple-style Liquid Glass interfaces.

## Table of Contents
1. [Base Glass Component](#base-glass-component)
2. [Glass Card Component](#glass-card-component)
3. [Glass Navigation](#glass-navigation)
4. [Glass Modal](#glass-modal)
5. [useGlassEffect Hook](#useglasseffect-hook)
6. [Tailwind Configuration](#tailwind-configuration)
7. [Complete Dashboard Layout](#complete-dashboard-layout)

---

## Base Glass Component

### Flexible Glass Container
```jsx
import React from 'react';

const Glass = ({
  children,
  variant = 'default',
  className = '',
  hover = false,
  ...props
}) => {
  const variants = {
    default: 'bg-white/[0.18] border-white/25',
    clear: 'bg-white/[0.08] border-white/10',
    frosted: 'bg-white/[0.35] border-white/40',
    dark: 'bg-black/25 border-white/10',
  };

  const baseStyles = `
    backdrop-blur-[16px] backdrop-saturate-[180%]
    border rounded-2xl
    shadow-[0_8px_32px_rgba(0,0,0,0.12),inset_0_1px_0_rgba(255,255,255,0.4)]
  `;

  const hoverStyles = hover
    ? 'transition-all duration-300 hover:translate-y-[-2px] hover:scale-[1.01] hover:bg-white/[0.22] hover:shadow-[0_12px_40px_rgba(0,0,0,0.15)]'
    : '';

  return (
    <div
      className={`${baseStyles} ${variants[variant]} ${hoverStyles} ${className}`}
      {...props}
    >
      {children}
    </div>
  );
};

export default Glass;
```

---

## Glass Card Component

```jsx
import React from 'react';

const GlassCard = ({
  title,
  subtitle,
  children,
  icon,
  tint,
  className = '',
}) => {
  const tintColors = {
    blue: 'bg-blue-500/15 border-blue-400/25',
    green: 'bg-green-500/12 border-green-400/20',
    amber: 'bg-amber-500/12 border-amber-400/20',
    red: 'bg-red-500/12 border-red-400/20',
    purple: 'bg-purple-500/15 border-purple-400/25',
  };

  const bgClass = tint ? tintColors[tint] : 'bg-white/[0.18] border-white/25';

  return (
    <div
      className={`
        ${bgClass}
        backdrop-blur-[16px] backdrop-saturate-[180%]
        border rounded-3xl p-6
        shadow-[0_8px_32px_rgba(0,0,0,0.12),inset_0_1px_0_rgba(255,255,255,0.4)]
        transition-all duration-300
        hover:translate-y-[-2px] hover:shadow-[0_12px_40px_rgba(0,0,0,0.15)]
        ${className}
      `}
    >
      {(icon || title) && (
        <div className="flex items-center gap-3 mb-4">
          {icon && (
            <div className="w-10 h-10 rounded-xl bg-white/20 flex items-center justify-center">
              {icon}
            </div>
          )}
          <div>
            {title && (
              <h3 className="text-lg font-semibold text-white drop-shadow-sm">
                {title}
              </h3>
            )}
            {subtitle && (
              <p className="text-sm text-white/70">{subtitle}</p>
            )}
          </div>
        </div>
      )}
      <div className="text-white/90">{children}</div>
    </div>
  );
};

export default GlassCard;
```

---

## Glass Navigation

### Top Navigation Bar
```jsx
import React, { useState, useEffect } from 'react';

const GlassNavbar = ({ logo, links = [], actions }) => {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 10);
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <nav
      className={`
        fixed top-0 left-0 right-0 z-50 h-16
        backdrop-blur-[20px] backdrop-saturate-[180%]
        border-b transition-all duration-300
        ${scrolled
          ? 'bg-white/[0.72] border-white/20 shadow-sm'
          : 'bg-white/[0.5] border-transparent'
        }
      `}
    >
      <div className="max-w-7xl mx-auto px-6 h-full flex items-center justify-between">
        <div className="flex items-center gap-8">
          {logo}
          <div className="hidden md:flex items-center gap-6">
            {links.map((link, i) => (
              <a
                key={i}
                href={link.href}
                className="text-sm font-medium text-gray-800/80 hover:text-gray-900 transition-colors"
              >
                {link.label}
              </a>
            ))}
          </div>
        </div>
        {actions && <div className="flex items-center gap-4">{actions}</div>}
      </div>
    </nav>
  );
};

export default GlassNavbar;
```

### Sidebar Navigation
```jsx
import React from 'react';

const GlassSidebar = ({ items = [], activeItem, onItemClick }) => {
  return (
    <aside
      className="
        fixed left-0 top-0 bottom-0 w-64
        bg-black/[0.25] backdrop-blur-[24px] backdrop-saturate-150
        border-r border-white/10
        shadow-[4px_0_24px_rgba(0,0,0,0.08)]
      "
    >
      <div className="p-6">
        <h2 className="text-xl font-bold text-white mb-8">Dashboard</h2>
        <nav className="space-y-1">
          {items.map((item) => (
            <button
              key={item.id}
              onClick={() => onItemClick?.(item.id)}
              className={`
                w-full flex items-center gap-3 px-4 py-3 rounded-xl
                transition-all duration-200 text-left
                ${activeItem === item.id
                  ? 'bg-white/20 text-white shadow-sm'
                  : 'text-white/70 hover:bg-white/10 hover:text-white'
                }
              `}
            >
              {item.icon}
              <span className="font-medium">{item.label}</span>
            </button>
          ))}
        </nav>
      </div>
    </aside>
  );
};

export default GlassSidebar;
```

---

## Glass Modal

```jsx
import React, { useEffect } from 'react';

const GlassModal = ({ isOpen, onClose, title, children, size = 'md' }) => {
  const sizes = {
    sm: 'max-w-sm',
    md: 'max-w-md',
    lg: 'max-w-lg',
    xl: 'max-w-xl',
  };

  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      {/* Backdrop */}
      <div
        className="absolute inset-0 bg-black/40 backdrop-blur-sm"
        onClick={onClose}
      />

      {/* Modal */}
      <div
        className={`
          relative ${sizes[size]} w-full
          bg-white/[0.2] backdrop-blur-[24px] backdrop-saturate-[180%]
          border border-white/25 rounded-3xl
          shadow-[0_25px_50px_rgba(0,0,0,0.25),inset_0_1px_0_rgba(255,255,255,0.4)]
          animate-in fade-in zoom-in-95 duration-200
        `}
      >
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-white/10">
          <h2 className="text-xl font-semibold text-white">{title}</h2>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-white/10 hover:bg-white/20 flex items-center justify-center transition-colors"
          >
            <svg className="w-4 h-4 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* Content */}
        <div className="p-6 text-white/90">{children}</div>
      </div>
    </div>
  );
};

export default GlassModal;
```

---

## useGlassEffect Hook

Custom hook for dynamic glass effects:

```jsx
import { useState, useEffect, useCallback } from 'react';

const useGlassEffect = (options = {}) => {
  const {
    blur = 16,
    saturation = 180,
    opacity = 0.18,
    borderOpacity = 0.25,
    darkMode = false,
  } = options;

  const [reduceTransparency, setReduceTransparency] = useState(false);
  const [reduceMotion, setReduceMotion] = useState(false);

  useEffect(() => {
    const transparencyQuery = window.matchMedia('(prefers-reduced-transparency: reduce)');
    const motionQuery = window.matchMedia('(prefers-reduced-motion: reduce)');

    setReduceTransparency(transparencyQuery.matches);
    setReduceMotion(motionQuery.matches);

    const handleTransparency = (e) => setReduceTransparency(e.matches);
    const handleMotion = (e) => setReduceMotion(e.matches);

    transparencyQuery.addEventListener('change', handleTransparency);
    motionQuery.addEventListener('change', handleMotion);

    return () => {
      transparencyQuery.removeEventListener('change', handleTransparency);
      motionQuery.removeEventListener('change', handleMotion);
    };
  }, []);

  const getGlassStyles = useCallback(() => {
    if (reduceTransparency) {
      return {
        background: darkMode ? 'rgba(30, 30, 30, 0.95)' : 'rgba(255, 255, 255, 0.95)',
        backdropFilter: 'none',
        WebkitBackdropFilter: 'none',
      };
    }

    const bgColor = darkMode
      ? `rgba(0, 0, 0, ${opacity + 0.1})`
      : `rgba(255, 255, 255, ${opacity})`;

    const borderColor = darkMode
      ? `rgba(255, 255, 255, ${borderOpacity * 0.5})`
      : `rgba(255, 255, 255, ${borderOpacity})`;

    return {
      background: bgColor,
      backdropFilter: `blur(${blur}px) saturate(${saturation}%)`,
      WebkitBackdropFilter: `blur(${blur}px) saturate(${saturation}%)`,
      border: `1px solid ${borderColor}`,
      borderRadius: '20px',
      boxShadow: darkMode
        ? '0 8px 32px rgba(0, 0, 0, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.1)'
        : '0 8px 32px rgba(0, 0, 0, 0.12), inset 0 1px 0 rgba(255, 255, 255, 0.4)',
      transition: reduceMotion ? 'none' : 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
    };
  }, [blur, saturation, opacity, borderOpacity, darkMode, reduceTransparency, reduceMotion]);

  return {
    glassStyles: getGlassStyles(),
    reduceTransparency,
    reduceMotion,
  };
};

export default useGlassEffect;
```

---

## Tailwind Configuration

Add to `tailwind.config.js`:

```js
module.exports = {
  theme: {
    extend: {
      backdropBlur: {
        xs: '2px',
        glass: '16px',
        'glass-heavy': '24px',
      },
      backdropSaturate: {
        glass: '180%',
      },
      colors: {
        glass: {
          light: 'rgba(255, 255, 255, 0.18)',
          dark: 'rgba(0, 0, 0, 0.25)',
          border: 'rgba(255, 255, 255, 0.25)',
          'border-dark': 'rgba(255, 255, 255, 0.1)',
        },
      },
      boxShadow: {
        glass: '0 8px 32px rgba(0, 0, 0, 0.12), inset 0 1px 0 rgba(255, 255, 255, 0.4)',
        'glass-dark': '0 8px 32px rgba(0, 0, 0, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.1)',
        'glass-hover': '0 12px 40px rgba(0, 0, 0, 0.15), inset 0 1px 0 rgba(255, 255, 255, 0.5)',
      },
      animation: {
        'glass-fade-in': 'glassFadeIn 0.4s cubic-bezier(0.4, 0, 0.2, 1) forwards',
      },
      keyframes: {
        glassFadeIn: {
          from: {
            opacity: '0',
            transform: 'translateY(10px) scale(0.98)',
          },
          to: {
            opacity: '1',
            transform: 'translateY(0) scale(1)',
          },
        },
      },
    },
  },
  plugins: [],
};
```

### Utility Classes Usage
```jsx
// Basic glass card with Tailwind
<div className="bg-white/[0.18] backdrop-blur-glass backdrop-saturate-glass border border-glass-border rounded-2xl shadow-glass p-6">
  Content here
</div>

// Dark mode variant
<div className="bg-glass-dark backdrop-blur-glass-heavy border border-glass-border-dark rounded-2xl shadow-glass-dark p-6">
  Dark mode content
</div>
```

---

## Complete Dashboard Layout

```jsx
import React, { useState } from 'react';

const GlassDashboard = () => {
  const [activeNav, setActiveNav] = useState('overview');

  const navItems = [
    { id: 'overview', label: 'Overview', icon: '📊' },
    { id: 'analytics', label: 'Analytics', icon: '📈' },
    { id: 'reports', label: 'Reports', icon: '📋' },
    { id: 'settings', label: 'Settings', icon: '⚙️' },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-500 via-purple-500 to-pink-500">
      {/* Sidebar */}
      <aside className="fixed left-0 top-0 bottom-0 w-64 bg-black/25 backdrop-blur-[24px] border-r border-white/10">
        <div className="p-6">
          <h1 className="text-2xl font-bold text-white mb-8">Dashboard</h1>
          <nav className="space-y-1">
            {navItems.map((item) => (
              <button
                key={item.id}
                onClick={() => setActiveNav(item.id)}
                className={`
                  w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all
                  ${activeNav === item.id
                    ? 'bg-white/20 text-white'
                    : 'text-white/70 hover:bg-white/10 hover:text-white'
                  }
                `}
              >
                <span>{item.icon}</span>
                <span className="font-medium">{item.label}</span>
              </button>
            ))}
          </nav>
        </div>
      </aside>

      {/* Main Content */}
      <main className="ml-64 p-8">
        {/* Header */}
        <header className="mb-8">
          <h2 className="text-3xl font-bold text-white drop-shadow-lg">
            Welcome back
          </h2>
          <p className="text-white/70 mt-1">Here's your overview</p>
        </header>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {[
            { label: 'Total Revenue', value: '$45,231', change: '+12.5%' },
            { label: 'Active Users', value: '2,345', change: '+8.2%' },
            { label: 'Conversion', value: '3.24%', change: '+2.1%' },
            { label: 'Avg. Session', value: '4m 32s', change: '-0.8%' },
          ].map((stat, i) => (
            <div
              key={i}
              className="
                bg-white/[0.18] backdrop-blur-[16px] backdrop-saturate-[180%]
                border border-white/25 rounded-2xl p-6
                shadow-[0_8px_32px_rgba(0,0,0,0.12),inset_0_1px_0_rgba(255,255,255,0.4)]
                hover:translate-y-[-2px] transition-transform
              "
            >
              <p className="text-white/70 text-sm">{stat.label}</p>
              <p className="text-2xl font-bold text-white mt-1">{stat.value}</p>
              <p className={`text-sm mt-2 ${stat.change.startsWith('+') ? 'text-green-300' : 'text-red-300'}`}>
                {stat.change} from last month
              </p>
            </div>
          ))}
        </div>

        {/* Main Card */}
        <div className="
          bg-white/[0.15] backdrop-blur-[20px] backdrop-saturate-[180%]
          border border-white/20 rounded-3xl p-8
          shadow-[0_8px_32px_rgba(0,0,0,0.12),inset_0_1px_0_rgba(255,255,255,0.3)]
        ">
          <h3 className="text-xl font-semibold text-white mb-4">Analytics Overview</h3>
          <div className="h-64 flex items-center justify-center text-white/50">
            Chart placeholder
          </div>
        </div>
      </main>
    </div>
  );
};

export default GlassDashboard;
```
