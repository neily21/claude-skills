# Liquid Glass Dashboard & Data Visualization Patterns

Specialized patterns for BI dashboards, charts, and data visualizations with Liquid Glass aesthetics.

## Table of Contents
1. [Dashboard Layout Principles](#dashboard-layout-principles)
2. [Stat Cards & KPIs](#stat-cards--kpis)
3. [Chart Containers](#chart-containers)
4. [Data Tables](#data-tables)
5. [Apache ECharts Integration](#apache-echarts-integration) ⭐
6. [Vega-Lite Integration](#vega-lite-integration) ⭐
7. [Chart.js Integration](#chartjs-integration)
8. [Recharts Integration](#recharts-integration)
9. [Filter & Control Panels](#filter--control-panels)
10. [Complete BI Dashboard](#complete-bi-dashboard)

---

## Dashboard Layout Principles

### Key Rules for Glass Dashboards
1. **Glass containers only** - Charts render on solid/transparent backgrounds inside glass cards
2. **Hierarchy through blur levels** - Primary panels: 16px blur, secondary: 12px, tertiary: 8px
3. **Content contrast** - Data visualizations need clear backgrounds for legibility
4. **Consistent spacing** - Use 24px gaps between cards, 16px internal padding

### Layout Structure
```jsx
<div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
  {/* Glass Sidebar - Navigation Layer */}
  <aside className="fixed left-0 w-64 h-full bg-black/30 backdrop-blur-[24px]">
    {/* Navigation items */}
  </aside>

  {/* Main Content Area */}
  <main className="ml-64 p-6">
    {/* Glass Header Bar */}
    <header className="bg-white/10 backdrop-blur-[16px] rounded-2xl p-4 mb-6">
      {/* Title, filters, date range */}
    </header>

    {/* Stats Row - Glass Cards */}
    <div className="grid grid-cols-4 gap-6 mb-6">
      {/* KPI Cards */}
    </div>

    {/* Charts Grid - Glass Containers */}
    <div className="grid grid-cols-2 gap-6">
      {/* Chart Cards */}
    </div>
  </main>
</div>
```

---

## Stat Cards & KPIs

### Basic KPI Card
```jsx
const KPICard = ({ label, value, change, icon, trend }) => (
  <div className="
    bg-white/[0.12] backdrop-blur-[16px] backdrop-saturate-[180%]
    border border-white/20 rounded-2xl p-5
    shadow-[0_4px_24px_rgba(0,0,0,0.1),inset_0_1px_0_rgba(255,255,255,0.2)]
    hover:bg-white/[0.15] transition-all duration-300
  ">
    <div className="flex items-start justify-between">
      <div>
        <p className="text-white/60 text-sm font-medium">{label}</p>
        <p className="text-3xl font-bold text-white mt-1 tracking-tight">{value}</p>
      </div>
      {icon && (
        <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center">
          {icon}
        </div>
      )}
    </div>
    {change && (
      <div className="flex items-center gap-1.5 mt-3">
        <span className={`text-sm font-medium ${trend === 'up' ? 'text-emerald-400' : 'text-rose-400'}`}>
          {trend === 'up' ? '↑' : '↓'} {change}
        </span>
        <span className="text-white/40 text-sm">vs last period</span>
      </div>
    )}
  </div>
);
```

### Sparkline KPI Card
```jsx
const SparklineKPI = ({ label, value, data, color = '#818cf8' }) => (
  <div className="
    bg-white/[0.12] backdrop-blur-[16px]
    border border-white/20 rounded-2xl p-5
    shadow-[0_4px_24px_rgba(0,0,0,0.1)]
  ">
    <p className="text-white/60 text-sm">{label}</p>
    <div className="flex items-end justify-between mt-2">
      <p className="text-2xl font-bold text-white">{value}</p>
      <svg viewBox="0 0 100 30" className="w-24 h-8">
        <polyline
          fill="none"
          stroke={color}
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
          points={data.map((v, i) => `${i * (100 / (data.length - 1))},${30 - v * 0.3}`).join(' ')}
        />
      </svg>
    </div>
  </div>
);
```

### Progress KPI Card
```jsx
const ProgressKPI = ({ label, value, total, percentage }) => (
  <div className="
    bg-white/[0.12] backdrop-blur-[16px]
    border border-white/20 rounded-2xl p-5
  ">
    <div className="flex justify-between items-start mb-3">
      <p className="text-white/60 text-sm">{label}</p>
      <span className="text-white/80 text-sm">{percentage}%</span>
    </div>
    <p className="text-2xl font-bold text-white">{value}<span className="text-white/40 text-base font-normal">/{total}</span></p>
    <div className="mt-3 h-1.5 bg-white/10 rounded-full overflow-hidden">
      <div
        className="h-full bg-gradient-to-r from-indigo-500 to-purple-500 rounded-full transition-all duration-500"
        style={{ width: `${percentage}%` }}
      />
    </div>
  </div>
);
```

---

## Chart Containers

### Standard Chart Card
```jsx
const ChartCard = ({ title, subtitle, children, actions }) => (
  <div className="
    bg-white/[0.1] backdrop-blur-[16px] backdrop-saturate-[180%]
    border border-white/15 rounded-3xl
    shadow-[0_8px_32px_rgba(0,0,0,0.12),inset_0_1px_0_rgba(255,255,255,0.15)]
    overflow-hidden
  ">
    {/* Header */}
    <div className="px-6 py-4 border-b border-white/10 flex items-center justify-between">
      <div>
        <h3 className="text-lg font-semibold text-white">{title}</h3>
        {subtitle && <p className="text-white/50 text-sm mt-0.5">{subtitle}</p>}
      </div>
      {actions && <div className="flex items-center gap-2">{actions}</div>}
    </div>

    {/* Chart Area - Solid background for legibility */}
    <div className="p-6 bg-black/20">
      {children}
    </div>
  </div>
);
```

### Tabbed Chart Card
```jsx
const TabbedChartCard = ({ title, tabs, activeTab, onTabChange, children }) => (
  <div className="
    bg-white/[0.1] backdrop-blur-[16px]
    border border-white/15 rounded-3xl overflow-hidden
  ">
    <div className="px-6 py-4 border-b border-white/10">
      <h3 className="text-lg font-semibold text-white mb-4">{title}</h3>
      <div className="flex gap-1 bg-white/5 rounded-xl p-1">
        {tabs.map((tab) => (
          <button
            key={tab.id}
            onClick={() => onTabChange(tab.id)}
            className={`
              px-4 py-2 rounded-lg text-sm font-medium transition-all
              ${activeTab === tab.id
                ? 'bg-white/20 text-white shadow-sm'
                : 'text-white/60 hover:text-white hover:bg-white/10'
              }
            `}
          >
            {tab.label}
          </button>
        ))}
      </div>
    </div>
    <div className="p-6 bg-black/20">{children}</div>
  </div>
);
```

---

## Data Tables

### Glass Table Container
Data tables should NOT have glass applied directly. Use a glass container with a solid inner area:

```jsx
const GlassDataTable = ({ columns, data, title }) => (
  <div className="
    bg-white/[0.1] backdrop-blur-[16px]
    border border-white/15 rounded-3xl overflow-hidden
  ">
    <div className="px-6 py-4 border-b border-white/10">
      <h3 className="text-lg font-semibold text-white">{title}</h3>
    </div>

    {/* Table Area - Semi-transparent background */}
    <div className="bg-black/30">
      <table className="w-full">
        <thead>
          <tr className="border-b border-white/10">
            {columns.map((col) => (
              <th
                key={col.key}
                className="px-6 py-3 text-left text-xs font-semibold text-white/60 uppercase tracking-wider"
              >
                {col.label}
              </th>
            ))}
          </tr>
        </thead>
        <tbody className="divide-y divide-white/5">
          {data.map((row, i) => (
            <tr
              key={i}
              className="hover:bg-white/5 transition-colors"
            >
              {columns.map((col) => (
                <td key={col.key} className="px-6 py-4 text-sm text-white/80">
                  {row[col.key]}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  </div>
);
```

---

## Apache ECharts Integration

Apache ECharts is a powerful charting library. Here's how to apply Liquid Glass theming.

### ECharts Glass Theme Object

```typescript
// glassTheme.ts - Complete ECharts Liquid Glass Theme
import type { EChartsOption } from 'echarts';

export const liquidGlassTheme = {
  // Color palette optimized for glass backgrounds
  color: ['#818cf8', '#34d399', '#fbbf24', '#f87171', '#a78bfa', '#38bdf8', '#fb7185', '#4ade80'],

  // Background - transparent for glass container
  backgroundColor: 'transparent',

  // Text styling
  textStyle: {
    fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Display", "Segoe UI", sans-serif',
    color: 'rgba(255, 255, 255, 0.8)',
  },

  // Title styling
  title: {
    textStyle: {
      color: 'rgba(255, 255, 255, 0.95)',
      fontSize: 16,
      fontWeight: 600,
    },
    subtextStyle: {
      color: 'rgba(255, 255, 255, 0.5)',
      fontSize: 12,
    },
  },

  // Legend styling
  legend: {
    textStyle: {
      color: 'rgba(255, 255, 255, 0.7)',
    },
    pageTextStyle: {
      color: 'rgba(255, 255, 255, 0.6)',
    },
  },

  // Tooltip - Glass styled
  tooltip: {
    backgroundColor: 'rgba(0, 0, 0, 0.75)',
    borderColor: 'rgba(255, 255, 255, 0.15)',
    borderWidth: 1,
    borderRadius: 12,
    padding: [12, 16],
    textStyle: {
      color: 'rgba(255, 255, 255, 0.9)',
      fontSize: 13,
    },
    extraCssText: 'backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); box-shadow: 0 8px 32px rgba(0,0,0,0.3);',
  },

  // Axis styling
  categoryAxis: {
    axisLine: {
      lineStyle: { color: 'rgba(255, 255, 255, 0.15)' },
    },
    axisTick: {
      lineStyle: { color: 'rgba(255, 255, 255, 0.1)' },
    },
    axisLabel: {
      color: 'rgba(255, 255, 255, 0.5)',
    },
    splitLine: {
      lineStyle: { color: 'rgba(255, 255, 255, 0.05)' },
    },
  },

  valueAxis: {
    axisLine: {
      lineStyle: { color: 'rgba(255, 255, 255, 0.15)' },
    },
    axisTick: {
      lineStyle: { color: 'rgba(255, 255, 255, 0.1)' },
    },
    axisLabel: {
      color: 'rgba(255, 255, 255, 0.5)',
    },
    splitLine: {
      lineStyle: { color: 'rgba(255, 255, 255, 0.05)' },
    },
  },

  // Line series
  line: {
    smooth: true,
    symbolSize: 0,
    lineStyle: { width: 2 },
  },

  // Bar series
  bar: {
    barBorderRadius: [4, 4, 0, 0],
    itemStyle: {
      borderRadius: [4, 4, 0, 0],
    },
  },

  // Pie series
  pie: {
    itemStyle: {
      borderColor: 'rgba(0, 0, 0, 0.3)',
      borderWidth: 2,
    },
  },
};
```

### Register and Use Theme

```typescript
import * as echarts from 'echarts';
import { liquidGlassTheme } from './glassTheme';

// Register the theme globally
echarts.registerTheme('liquidGlass', liquidGlassTheme);

// Use in component
const chart = echarts.init(containerRef.current, 'liquidGlass');
```

### ECharts React Component with Glass Container

```tsx
import React, { useRef, useEffect } from 'react';
import * as echarts from 'echarts';
import type { EChartsOption } from 'echarts';

interface GlassEChartProps {
  option: EChartsOption;
  title?: string;
  subtitle?: string;
  height?: number | string;
  className?: string;
}

const GlassEChart: React.FC<GlassEChartProps> = ({
  option,
  title,
  subtitle,
  height = 300,
  className = '',
}) => {
  const chartRef = useRef<HTMLDivElement>(null);
  const chartInstance = useRef<echarts.ECharts | null>(null);

  useEffect(() => {
    if (!chartRef.current) return;

    // Initialize with glass theme
    chartInstance.current = echarts.init(chartRef.current, 'liquidGlass');
    chartInstance.current.setOption(option);

    // Handle resize
    const handleResize = () => chartInstance.current?.resize();
    window.addEventListener('resize', handleResize);

    return () => {
      window.removeEventListener('resize', handleResize);
      chartInstance.current?.dispose();
    };
  }, []);

  useEffect(() => {
    chartInstance.current?.setOption(option, { notMerge: true });
  }, [option]);

  return (
    <div
      className={`
        bg-white/[0.1] backdrop-blur-[16px] backdrop-saturate-[180%]
        border border-white/15 rounded-3xl overflow-hidden
        shadow-[0_8px_32px_rgba(0,0,0,0.12),inset_0_1px_0_rgba(255,255,255,0.15)]
        ${className}
      `}
    >
      {(title || subtitle) && (
        <div className="px-6 py-4 border-b border-white/10">
          {title && <h3 className="text-lg font-semibold text-white">{title}</h3>}
          {subtitle && <p className="text-white/50 text-sm mt-0.5">{subtitle}</p>}
        </div>
      )}
      <div className="p-4 bg-black/20">
        <div ref={chartRef} style={{ height, width: '100%' }} />
      </div>
    </div>
  );
};

export default GlassEChart;
```

### ECharts Line/Area Chart Example

```tsx
const revenueChartOption: EChartsOption = {
  grid: {
    left: 50,
    right: 20,
    top: 20,
    bottom: 30,
  },
  xAxis: {
    type: 'category',
    data: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
    boundaryGap: false,
  },
  yAxis: {
    type: 'value',
  },
  series: [
    {
      name: 'Revenue',
      type: 'line',
      smooth: true,
      data: [150, 230, 224, 218, 335, 447],
      lineStyle: {
        color: '#818cf8',
        width: 3,
      },
      areaStyle: {
        color: {
          type: 'linear',
          x: 0, y: 0, x2: 0, y2: 1,
          colorStops: [
            { offset: 0, color: 'rgba(129, 140, 248, 0.4)' },
            { offset: 1, color: 'rgba(129, 140, 248, 0)' },
          ],
        },
      },
      symbol: 'none',
    },
  ],
};

// Usage
<GlassEChart
  option={revenueChartOption}
  title="Revenue Trend"
  subtitle="Last 6 months"
  height={280}
/>
```

### ECharts Bar Chart Example

```tsx
const barChartOption: EChartsOption = {
  grid: {
    left: 60,
    right: 20,
    top: 20,
    bottom: 40,
  },
  xAxis: {
    type: 'category',
    data: ['Product A', 'Product B', 'Product C', 'Product D', 'Product E'],
    axisLabel: {
      rotate: 0,
    },
  },
  yAxis: {
    type: 'value',
  },
  series: [
    {
      name: 'Sales',
      type: 'bar',
      data: [320, 280, 250, 190, 150],
      itemStyle: {
        color: {
          type: 'linear',
          x: 0, y: 0, x2: 0, y2: 1,
          colorStops: [
            { offset: 0, color: '#818cf8' },
            { offset: 1, color: '#6366f1' },
          ],
        },
        borderRadius: [6, 6, 0, 0],
      },
      emphasis: {
        itemStyle: {
          color: {
            type: 'linear',
            x: 0, y: 0, x2: 0, y2: 1,
            colorStops: [
              { offset: 0, color: '#a5b4fc' },
              { offset: 1, color: '#818cf8' },
            ],
          },
        },
      },
      barWidth: '60%',
    },
  ],
};
```

### ECharts Pie/Donut Chart Example

```tsx
const pieChartOption: EChartsOption = {
  tooltip: {
    trigger: 'item',
    formatter: '{b}: {c} ({d}%)',
  },
  legend: {
    orient: 'vertical',
    right: 20,
    top: 'center',
  },
  series: [
    {
      name: 'Traffic Source',
      type: 'pie',
      radius: ['50%', '70%'],
      center: ['35%', '50%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 6,
        borderColor: 'rgba(0, 0, 0, 0.3)',
        borderWidth: 2,
      },
      label: {
        show: false,
      },
      emphasis: {
        label: {
          show: true,
          fontSize: 14,
          fontWeight: 'bold',
          color: '#fff',
        },
        itemStyle: {
          shadowBlur: 20,
          shadowColor: 'rgba(0, 0, 0, 0.3)',
        },
      },
      data: [
        { value: 1048, name: 'Organic', itemStyle: { color: '#818cf8' } },
        { value: 735, name: 'Direct', itemStyle: { color: '#34d399' } },
        { value: 580, name: 'Referral', itemStyle: { color: '#fbbf24' } },
        { value: 484, name: 'Social', itemStyle: { color: '#f87171' } },
        { value: 300, name: 'Email', itemStyle: { color: '#a78bfa' } },
      ],
    },
  ],
};
```

### ECharts Gauge Chart (KPI Style)

```tsx
const gaugeOption: EChartsOption = {
  series: [
    {
      type: 'gauge',
      startAngle: 200,
      endAngle: -20,
      min: 0,
      max: 100,
      splitNumber: 10,
      itemStyle: {
        color: '#818cf8',
      },
      progress: {
        show: true,
        width: 20,
        itemStyle: {
          color: {
            type: 'linear',
            x: 0, y: 0, x2: 1, y2: 0,
            colorStops: [
              { offset: 0, color: '#818cf8' },
              { offset: 1, color: '#34d399' },
            ],
          },
        },
      },
      pointer: { show: false },
      axisLine: {
        lineStyle: {
          width: 20,
          color: [[1, 'rgba(255, 255, 255, 0.1)']],
        },
      },
      axisTick: { show: false },
      splitLine: { show: false },
      axisLabel: { show: false },
      title: {
        offsetCenter: [0, '30%'],
        fontSize: 14,
        color: 'rgba(255, 255, 255, 0.6)',
      },
      detail: {
        fontSize: 36,
        fontWeight: 'bold',
        offsetCenter: [0, '-10%'],
        valueAnimation: true,
        formatter: '{value}%',
        color: '#fff',
      },
      data: [{ value: 73, name: 'Completion' }],
    },
  ],
};
```

---

## Vega-Lite Integration

Vega-Lite is a declarative visualization grammar. Here's how to apply Liquid Glass theming.

### Vega-Lite Glass Configuration

```typescript
// vegaGlassConfig.ts
import type { Config } from 'vega-lite';

export const liquidGlassConfig: Config = {
  // Background - transparent for glass container
  background: 'transparent',

  // Font configuration
  font: '-apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif',

  // Title styling
  title: {
    color: 'rgba(255, 255, 255, 0.95)',
    fontSize: 16,
    fontWeight: 600,
    subtitleColor: 'rgba(255, 255, 255, 0.5)',
    subtitleFontSize: 12,
  },

  // Axis styling
  axis: {
    domainColor: 'rgba(255, 255, 255, 0.15)',
    gridColor: 'rgba(255, 255, 255, 0.05)',
    tickColor: 'rgba(255, 255, 255, 0.1)',
    labelColor: 'rgba(255, 255, 255, 0.5)',
    titleColor: 'rgba(255, 255, 255, 0.7)',
    labelFont: '-apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif',
    titleFont: '-apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif',
    labelFontSize: 11,
    titleFontSize: 12,
  },

  // Legend styling
  legend: {
    labelColor: 'rgba(255, 255, 255, 0.7)',
    titleColor: 'rgba(255, 255, 255, 0.8)',
    labelFont: '-apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif',
    titleFont: '-apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif',
    labelFontSize: 11,
    titleFontSize: 12,
    symbolStrokeWidth: 0,
  },

  // View styling
  view: {
    stroke: 'transparent',
  },

  // Default color palette
  range: {
    category: ['#818cf8', '#34d399', '#fbbf24', '#f87171', '#a78bfa', '#38bdf8', '#fb7185', '#4ade80'],
    diverging: ['#f87171', '#fbbf24', '#34d399'],
    heatmap: ['#312e81', '#4338ca', '#6366f1', '#818cf8', '#a5b4fc'],
    ramp: ['#312e81', '#818cf8'],
  },

  // Mark defaults
  mark: {
    tooltip: true,
  },

  // Line mark
  line: {
    strokeWidth: 2,
    point: false,
  },

  // Bar mark
  bar: {
    cornerRadiusTopLeft: 4,
    cornerRadiusTopRight: 4,
  },

  // Point mark
  point: {
    filled: true,
    size: 60,
  },

  // Area mark
  area: {
    line: true,
    opacity: 0.3,
  },
};
```

### Vega-Lite React Component with Glass Container

```tsx
import React, { useRef, useEffect } from 'react';
import embed, { VisualizationSpec, EmbedOptions } from 'vega-embed';
import { liquidGlassConfig } from './vegaGlassConfig';

interface GlassVegaLiteProps {
  spec: VisualizationSpec;
  title?: string;
  subtitle?: string;
  height?: number;
  className?: string;
}

const GlassVegaLite: React.FC<GlassVegaLiteProps> = ({
  spec,
  title,
  subtitle,
  height = 300,
  className = '',
}) => {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!containerRef.current) return;

    const embedOptions: EmbedOptions = {
      config: liquidGlassConfig,
      actions: false, // Hide export actions
      renderer: 'svg',
      theme: 'dark',
    };

    // Merge spec with glass-specific settings
    const glassSpec: VisualizationSpec = {
      ...spec,
      background: 'transparent',
      padding: 20,
      height: height - 60, // Account for header
    };

    embed(containerRef.current, glassSpec, embedOptions).catch(console.error);
  }, [spec, height]);

  return (
    <div
      className={`
        bg-white/[0.1] backdrop-blur-[16px] backdrop-saturate-[180%]
        border border-white/15 rounded-3xl overflow-hidden
        shadow-[0_8px_32px_rgba(0,0,0,0.12),inset_0_1px_0_rgba(255,255,255,0.15)]
        ${className}
      `}
    >
      {(title || subtitle) && (
        <div className="px-6 py-4 border-b border-white/10">
          {title && <h3 className="text-lg font-semibold text-white">{title}</h3>}
          {subtitle && <p className="text-white/50 text-sm mt-0.5">{subtitle}</p>}
        </div>
      )}
      <div className="p-4 bg-black/20">
        <div ref={containerRef} style={{ minHeight: height }} />
      </div>
    </div>
  );
};

export default GlassVegaLite;
```

### Vega-Lite Line Chart Example

```tsx
import type { VisualizationSpec } from 'vega-embed';

const lineChartSpec: VisualizationSpec = {
  $schema: 'https://vega.github.io/schema/vega-lite/v5.json',
  width: 'container',
  height: 250,
  data: {
    values: [
      { month: 'Jan', revenue: 150 },
      { month: 'Feb', revenue: 230 },
      { month: 'Mar', revenue: 224 },
      { month: 'Apr', revenue: 218 },
      { month: 'May', revenue: 335 },
      { month: 'Jun', revenue: 447 },
    ],
  },
  mark: {
    type: 'area',
    line: { color: '#818cf8', strokeWidth: 2 },
    color: {
      x1: 1,
      y1: 1,
      x2: 1,
      y2: 0,
      gradient: 'linear',
      stops: [
        { offset: 0, color: 'rgba(129, 140, 248, 0)' },
        { offset: 1, color: 'rgba(129, 140, 248, 0.4)' },
      ],
    },
    interpolate: 'monotone',
  },
  encoding: {
    x: {
      field: 'month',
      type: 'ordinal',
      axis: { title: null },
    },
    y: {
      field: 'revenue',
      type: 'quantitative',
      axis: { title: 'Revenue ($K)', grid: true },
    },
  },
};

// Usage
<GlassVegaLite
  spec={lineChartSpec}
  title="Revenue Trend"
  subtitle="Monthly revenue in thousands"
  height={320}
/>
```

### Vega-Lite Bar Chart Example

```tsx
const barChartSpec: VisualizationSpec = {
  $schema: 'https://vega.github.io/schema/vega-lite/v5.json',
  width: 'container',
  height: 250,
  data: {
    values: [
      { category: 'Product A', sales: 320 },
      { category: 'Product B', sales: 280 },
      { category: 'Product C', sales: 250 },
      { category: 'Product D', sales: 190 },
      { category: 'Product E', sales: 150 },
    ],
  },
  mark: {
    type: 'bar',
    cornerRadiusTopLeft: 6,
    cornerRadiusTopRight: 6,
    color: {
      x1: 1,
      y1: 1,
      x2: 1,
      y2: 0,
      gradient: 'linear',
      stops: [
        { offset: 0, color: '#6366f1' },
        { offset: 1, color: '#818cf8' },
      ],
    },
  },
  encoding: {
    x: {
      field: 'category',
      type: 'nominal',
      axis: { title: null, labelAngle: 0 },
    },
    y: {
      field: 'sales',
      type: 'quantitative',
      axis: { title: 'Sales ($K)' },
    },
    tooltip: [
      { field: 'category', type: 'nominal', title: 'Product' },
      { field: 'sales', type: 'quantitative', title: 'Sales' },
    ],
  },
};
```

### Vega-Lite Pie/Donut Chart Example

```tsx
const donutChartSpec: VisualizationSpec = {
  $schema: 'https://vega.github.io/schema/vega-lite/v5.json',
  width: 200,
  height: 200,
  data: {
    values: [
      { source: 'Organic', value: 1048 },
      { source: 'Direct', value: 735 },
      { source: 'Referral', value: 580 },
      { source: 'Social', value: 484 },
      { source: 'Email', value: 300 },
    ],
  },
  mark: {
    type: 'arc',
    innerRadius: 60,
    outerRadius: 90,
    stroke: 'rgba(0, 0, 0, 0.3)',
    strokeWidth: 2,
  },
  encoding: {
    theta: { field: 'value', type: 'quantitative', stack: true },
    color: {
      field: 'source',
      type: 'nominal',
      scale: {
        domain: ['Organic', 'Direct', 'Referral', 'Social', 'Email'],
        range: ['#818cf8', '#34d399', '#fbbf24', '#f87171', '#a78bfa'],
      },
      legend: {
        orient: 'right',
        title: 'Traffic Source',
      },
    },
    tooltip: [
      { field: 'source', type: 'nominal', title: 'Source' },
      { field: 'value', type: 'quantitative', title: 'Visits' },
    ],
  },
};
```

### Vega-Lite Heatmap Example

```tsx
const heatmapSpec: VisualizationSpec = {
  $schema: 'https://vega.github.io/schema/vega-lite/v5.json',
  width: 'container',
  height: 200,
  data: {
    values: [
      // Sample data: activity by day and hour
      { day: 'Mon', hour: '9am', value: 45 },
      { day: 'Mon', hour: '12pm', value: 78 },
      { day: 'Mon', hour: '3pm', value: 62 },
      { day: 'Tue', hour: '9am', value: 52 },
      { day: 'Tue', hour: '12pm', value: 85 },
      { day: 'Tue', hour: '3pm', value: 71 },
      // ... more data
    ],
  },
  mark: {
    type: 'rect',
    cornerRadius: 4,
  },
  encoding: {
    x: {
      field: 'hour',
      type: 'ordinal',
      axis: { title: null },
    },
    y: {
      field: 'day',
      type: 'ordinal',
      axis: { title: null },
    },
    color: {
      field: 'value',
      type: 'quantitative',
      scale: {
        scheme: 'purples',
        domain: [0, 100],
      },
      legend: { title: 'Activity' },
    },
    tooltip: [
      { field: 'day', type: 'ordinal' },
      { field: 'hour', type: 'ordinal' },
      { field: 'value', type: 'quantitative', title: 'Activity' },
    ],
  },
};
```

### Vega-Lite Multi-Series Chart

```tsx
const multiLineSpec: VisualizationSpec = {
  $schema: 'https://vega.github.io/schema/vega-lite/v5.json',
  width: 'container',
  height: 250,
  data: {
    values: [
      { month: 'Jan', metric: 'Revenue', value: 150 },
      { month: 'Jan', metric: 'Costs', value: 80 },
      { month: 'Feb', metric: 'Revenue', value: 230 },
      { month: 'Feb', metric: 'Costs', value: 95 },
      { month: 'Mar', metric: 'Revenue', value: 224 },
      { month: 'Mar', metric: 'Costs', value: 88 },
      { month: 'Apr', metric: 'Revenue', value: 280 },
      { month: 'Apr', metric: 'Costs', value: 102 },
    ],
  },
  mark: {
    type: 'line',
    strokeWidth: 2,
    point: { filled: true, size: 50 },
  },
  encoding: {
    x: {
      field: 'month',
      type: 'ordinal',
      axis: { title: null },
    },
    y: {
      field: 'value',
      type: 'quantitative',
      axis: { title: 'Amount ($K)' },
    },
    color: {
      field: 'metric',
      type: 'nominal',
      scale: {
        domain: ['Revenue', 'Costs'],
        range: ['#818cf8', '#f87171'],
      },
    },
    strokeDash: {
      field: 'metric',
      type: 'nominal',
      scale: {
        domain: ['Revenue', 'Costs'],
        range: [[], [4, 4]],
      },
      legend: null,
    },
  },
};
```

### Custom Vega-Lite Tooltip (CSS Override)

Add this CSS for glass-styled tooltips:

```css
/* Vega-Lite Glass Tooltip Styles */
#vg-tooltip-element.vg-tooltip {
  background: rgba(0, 0, 0, 0.75) !important;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.15) !important;
  border-radius: 12px !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3) !important;
  padding: 12px 16px !important;
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif !important;
}

#vg-tooltip-element.vg-tooltip h2 {
  color: rgba(255, 255, 255, 0.9) !important;
  font-size: 13px !important;
  font-weight: 600 !important;
  margin-bottom: 8px !important;
}

#vg-tooltip-element.vg-tooltip table tr td.key {
  color: rgba(255, 255, 255, 0.5) !important;
  font-size: 12px !important;
}

#vg-tooltip-element.vg-tooltip table tr td.value {
  color: rgba(255, 255, 255, 0.9) !important;
  font-size: 12px !important;
  font-weight: 500 !important;
}
```

---

## Chart.js Integration

### Chart.js Glass Theme Configuration
```jsx
import { Chart } from 'chart.js';

// Register glass theme defaults
Chart.defaults.color = 'rgba(255, 255, 255, 0.7)';
Chart.defaults.borderColor = 'rgba(255, 255, 255, 0.1)';
Chart.defaults.font.family = '-apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif';

const glassChartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      labels: {
        color: 'rgba(255, 255, 255, 0.7)',
        padding: 20,
        usePointStyle: true,
      },
    },
    tooltip: {
      backgroundColor: 'rgba(0, 0, 0, 0.8)',
      titleColor: 'rgba(255, 255, 255, 0.9)',
      bodyColor: 'rgba(255, 255, 255, 0.7)',
      borderColor: 'rgba(255, 255, 255, 0.1)',
      borderWidth: 1,
      cornerRadius: 12,
      padding: 12,
      displayColors: true,
      boxPadding: 4,
    },
  },
  scales: {
    x: {
      grid: {
        color: 'rgba(255, 255, 255, 0.05)',
      },
      ticks: {
        color: 'rgba(255, 255, 255, 0.5)',
      },
    },
    y: {
      grid: {
        color: 'rgba(255, 255, 255, 0.05)',
      },
      ticks: {
        color: 'rgba(255, 255, 255, 0.5)',
      },
    },
  },
};

// Glass gradient for area/line charts
const createGlassGradient = (ctx, chartArea, color) => {
  const gradient = ctx.createLinearGradient(0, chartArea.top, 0, chartArea.bottom);
  gradient.addColorStop(0, `${color}40`);  // 25% opacity at top
  gradient.addColorStop(1, `${color}00`);  // 0% opacity at bottom
  return gradient;
};
```

### Line Chart Example
```jsx
import { Line } from 'react-chartjs-2';

const GlassLineChart = ({ data }) => {
  const chartData = {
    labels: data.labels,
    datasets: [
      {
        label: 'Revenue',
        data: data.values,
        borderColor: '#818cf8',
        backgroundColor: (context) => {
          const chart = context.chart;
          const { ctx, chartArea } = chart;
          if (!chartArea) return;
          return createGlassGradient(ctx, chartArea, '#818cf8');
        },
        borderWidth: 2,
        fill: true,
        tension: 0.4,
        pointRadius: 0,
        pointHoverRadius: 6,
        pointHoverBackgroundColor: '#818cf8',
        pointHoverBorderColor: '#fff',
        pointHoverBorderWidth: 2,
      },
    ],
  };

  return (
    <ChartCard title="Revenue Trend" subtitle="Last 30 days">
      <div className="h-64">
        <Line data={chartData} options={glassChartOptions} />
      </div>
    </ChartCard>
  );
};
```

---

## Recharts Integration

### Recharts Glass Theme
```jsx
import {
  ResponsiveContainer,
  LineChart,
  Line,
  AreaChart,
  Area,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
} from 'recharts';

// Glass tooltip component
const GlassTooltip = ({ active, payload, label }) => {
  if (!active || !payload) return null;

  return (
    <div className="
      bg-black/80 backdrop-blur-[12px]
      border border-white/20 rounded-xl
      px-4 py-3 shadow-xl
    ">
      <p className="text-white/60 text-xs mb-2">{label}</p>
      {payload.map((entry, i) => (
        <p key={i} className="text-white text-sm font-medium">
          <span style={{ color: entry.color }}>●</span> {entry.name}: {entry.value}
        </p>
      ))}
    </div>
  );
};

// Glass area chart
const GlassAreaChart = ({ data }) => (
  <ChartCard title="Performance Overview">
    <div className="h-64">
      <ResponsiveContainer width="100%" height="100%">
        <AreaChart data={data}>
          <defs>
            <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#818cf8" stopOpacity={0.3} />
              <stop offset="95%" stopColor="#818cf8" stopOpacity={0} />
            </linearGradient>
            <linearGradient id="colorUsers" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#34d399" stopOpacity={0.3} />
              <stop offset="95%" stopColor="#34d399" stopOpacity={0} />
            </linearGradient>
          </defs>
          <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.05)" />
          <XAxis
            dataKey="name"
            stroke="rgba(255,255,255,0.3)"
            tick={{ fill: 'rgba(255,255,255,0.5)', fontSize: 12 }}
          />
          <YAxis
            stroke="rgba(255,255,255,0.3)"
            tick={{ fill: 'rgba(255,255,255,0.5)', fontSize: 12 }}
          />
          <Tooltip content={<GlassTooltip />} />
          <Area
            type="monotone"
            dataKey="revenue"
            stroke="#818cf8"
            strokeWidth={2}
            fillOpacity={1}
            fill="url(#colorRevenue)"
          />
          <Area
            type="monotone"
            dataKey="users"
            stroke="#34d399"
            strokeWidth={2}
            fillOpacity={1}
            fill="url(#colorUsers)"
          />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  </ChartCard>
);
```

### Donut/Pie Chart
```jsx
import { PieChart, Pie, Cell, ResponsiveContainer } from 'recharts';

const GLASS_COLORS = ['#818cf8', '#34d399', '#fbbf24', '#f87171', '#a78bfa'];

const GlassDonutChart = ({ data, title }) => (
  <ChartCard title={title}>
    <div className="h-64 flex items-center">
      <ResponsiveContainer width="50%" height="100%">
        <PieChart>
          <Pie
            data={data}
            cx="50%"
            cy="50%"
            innerRadius={60}
            outerRadius={80}
            paddingAngle={2}
            dataKey="value"
          >
            {data.map((entry, index) => (
              <Cell
                key={`cell-${index}`}
                fill={GLASS_COLORS[index % GLASS_COLORS.length]}
                stroke="rgba(255,255,255,0.1)"
              />
            ))}
          </Pie>
          <Tooltip content={<GlassTooltip />} />
        </PieChart>
      </ResponsiveContainer>
      <div className="w-1/2 space-y-3">
        {data.map((item, i) => (
          <div key={i} className="flex items-center gap-3">
            <div
              className="w-3 h-3 rounded-full"
              style={{ backgroundColor: GLASS_COLORS[i % GLASS_COLORS.length] }}
            />
            <span className="text-white/70 text-sm">{item.name}</span>
            <span className="text-white font-medium ml-auto">{item.value}%</span>
          </div>
        ))}
      </div>
    </div>
  </ChartCard>
);
```

---

## Filter & Control Panels

### Glass Filter Bar
```jsx
const GlassFilterBar = ({ filters, activeFilters, onFilterChange }) => (
  <div className="
    bg-white/[0.08] backdrop-blur-[12px]
    border border-white/15 rounded-2xl
    p-4 flex items-center gap-4 flex-wrap
  ">
    {filters.map((filter) => (
      <div key={filter.id} className="flex items-center gap-2">
        <label className="text-white/60 text-sm">{filter.label}</label>
        <select
          value={activeFilters[filter.id] || ''}
          onChange={(e) => onFilterChange(filter.id, e.target.value)}
          className="
            bg-white/10 border border-white/20 rounded-lg
            px-3 py-1.5 text-sm text-white
            focus:outline-none focus:ring-2 focus:ring-white/30
          "
        >
          {filter.options.map((opt) => (
            <option key={opt.value} value={opt.value} className="bg-gray-900">
              {opt.label}
            </option>
          ))}
        </select>
      </div>
    ))}
  </div>
);
```

### Date Range Picker Glass Style
```jsx
const GlassDateRangePicker = ({ startDate, endDate, onChange }) => (
  <div className="
    bg-white/[0.1] backdrop-blur-[12px]
    border border-white/20 rounded-xl
    px-4 py-2 flex items-center gap-3
  ">
    <svg className="w-5 h-5 text-white/50" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
    </svg>
    <input
      type="date"
      value={startDate}
      onChange={(e) => onChange({ start: e.target.value, end: endDate })}
      className="bg-transparent text-white text-sm focus:outline-none"
    />
    <span className="text-white/40">→</span>
    <input
      type="date"
      value={endDate}
      onChange={(e) => onChange({ start: startDate, end: e.target.value })}
      className="bg-transparent text-white text-sm focus:outline-none"
    />
  </div>
);
```

---

## Complete BI Dashboard

```jsx
import React, { useState } from 'react';

const GlassBIDashboard = () => {
  const [dateRange, setDateRange] = useState({ start: '2025-01-01', end: '2025-01-31' });

  const kpis = [
    { label: 'Total Revenue', value: '$847,234', change: '+12.5%', trend: 'up' },
    { label: 'Active Users', value: '24,521', change: '+8.3%', trend: 'up' },
    { label: 'Conversion Rate', value: '3.42%', change: '+0.8%', trend: 'up' },
    { label: 'Avg. Order Value', value: '$124.50', change: '-2.1%', trend: 'down' },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-indigo-950 to-slate-900">
      {/* Sidebar */}
      <aside className="fixed left-0 top-0 bottom-0 w-64 bg-black/30 backdrop-blur-[24px] border-r border-white/10">
        <div className="p-6">
          <div className="flex items-center gap-3 mb-10">
            <div className="w-10 h-10 rounded-xl bg-indigo-500/30 flex items-center justify-center">
              <span className="text-xl">📊</span>
            </div>
            <span className="text-xl font-bold text-white">Analytics</span>
          </div>
          <nav className="space-y-1">
            {['Overview', 'Revenue', 'Users', 'Products', 'Settings'].map((item, i) => (
              <button
                key={item}
                className={`
                  w-full text-left px-4 py-3 rounded-xl transition-all
                  ${i === 0 ? 'bg-white/15 text-white' : 'text-white/60 hover:bg-white/10 hover:text-white'}
                `}
              >
                {item}
              </button>
            ))}
          </nav>
        </div>
      </aside>

      {/* Main */}
      <main className="ml-64 p-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-3xl font-bold text-white">Dashboard Overview</h1>
            <p className="text-white/50 mt-1">Track your key metrics</p>
          </div>
          <div className="
            bg-white/10 backdrop-blur-[12px]
            border border-white/20 rounded-xl
            px-4 py-2 flex items-center gap-2
          ">
            <span className="text-white/70 text-sm">Jan 1 - Jan 31, 2025</span>
          </div>
        </div>

        {/* KPIs */}
        <div className="grid grid-cols-4 gap-6 mb-8">
          {kpis.map((kpi, i) => (
            <div
              key={i}
              className="
                bg-white/[0.12] backdrop-blur-[16px]
                border border-white/20 rounded-2xl p-6
                shadow-[0_4px_24px_rgba(0,0,0,0.1)]
                hover:bg-white/[0.15] transition-all
              "
            >
              <p className="text-white/60 text-sm">{kpi.label}</p>
              <p className="text-3xl font-bold text-white mt-2">{kpi.value}</p>
              <p className={`text-sm mt-2 ${kpi.trend === 'up' ? 'text-emerald-400' : 'text-rose-400'}`}>
                {kpi.trend === 'up' ? '↑' : '↓'} {kpi.change}
              </p>
            </div>
          ))}
        </div>

        {/* Charts Row */}
        <div className="grid grid-cols-2 gap-6 mb-8">
          {/* Revenue Chart */}
          <div className="
            bg-white/[0.1] backdrop-blur-[16px]
            border border-white/15 rounded-3xl overflow-hidden
          ">
            <div className="px-6 py-4 border-b border-white/10">
              <h3 className="text-lg font-semibold text-white">Revenue Trend</h3>
            </div>
            <div className="p-6 bg-black/20 h-64 flex items-center justify-center text-white/30">
              [Chart.js or Recharts Line Chart Here]
            </div>
          </div>

          {/* Users Chart */}
          <div className="
            bg-white/[0.1] backdrop-blur-[16px]
            border border-white/15 rounded-3xl overflow-hidden
          ">
            <div className="px-6 py-4 border-b border-white/10">
              <h3 className="text-lg font-semibold text-white">User Growth</h3>
            </div>
            <div className="p-6 bg-black/20 h-64 flex items-center justify-center text-white/30">
              [Chart.js or Recharts Area Chart Here]
            </div>
          </div>
        </div>

        {/* Bottom Row */}
        <div className="grid grid-cols-3 gap-6">
          {/* Donut Chart */}
          <div className="
            bg-white/[0.1] backdrop-blur-[16px]
            border border-white/15 rounded-3xl overflow-hidden
          ">
            <div className="px-6 py-4 border-b border-white/10">
              <h3 className="text-lg font-semibold text-white">Traffic Sources</h3>
            </div>
            <div className="p-6 bg-black/20 h-48 flex items-center justify-center text-white/30">
              [Donut Chart Here]
            </div>
          </div>

          {/* Recent Activity */}
          <div className="
            col-span-2
            bg-white/[0.1] backdrop-blur-[16px]
            border border-white/15 rounded-3xl overflow-hidden
          ">
            <div className="px-6 py-4 border-b border-white/10">
              <h3 className="text-lg font-semibold text-white">Recent Transactions</h3>
            </div>
            <div className="bg-black/20">
              {[1, 2, 3, 4].map((i) => (
                <div key={i} className="px-6 py-4 border-b border-white/5 flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-white/10" />
                    <div>
                      <p className="text-white font-medium">Transaction #{i}00{i}</p>
                      <p className="text-white/50 text-sm">Jan {i + 10}, 2025</p>
                    </div>
                  </div>
                  <span className="text-emerald-400 font-semibold">+$1,234</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};

export default GlassBIDashboard;
```

---

## Color Palettes for Data Viz

### Glass-Friendly Chart Colors
```js
// Primary palette - high contrast on dark glass backgrounds
const CHART_COLORS = {
  primary: ['#818cf8', '#34d399', '#fbbf24', '#f87171', '#a78bfa', '#38bdf8'],
  // Semantic colors
  positive: '#34d399',  // emerald-400
  negative: '#f87171',  // red-400
  neutral: '#94a3b8',   // slate-400
  warning: '#fbbf24',   // amber-400
};

// Gradient definitions for area charts
const GRADIENTS = {
  indigo: ['rgba(129, 140, 248, 0.3)', 'rgba(129, 140, 248, 0)'],
  emerald: ['rgba(52, 211, 153, 0.3)', 'rgba(52, 211, 153, 0)'],
  amber: ['rgba(251, 191, 36, 0.3)', 'rgba(251, 191, 36, 0)'],
};
```
