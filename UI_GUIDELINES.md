# UI Guidelines

This document defines strict UI rules for the Eterno Wedding Guest Manager project.

**The goal is:**
- Clean
- Elegant
- Emotional (wedding context)
- Consistent
- Predictable for LLM generation

**No screen should violate these rules.**

---

## 1. Design Principles

1. **Simplicity over feature density** — Less is more. Focus on essential features.
2. **White space is mandatory** — Generous spacing creates elegance and breathing room.
3. **Large typography over small dense text** — Readability first. Use larger, comfortable font sizes.
4. **Soft colors, not aggressive contrast** — Gentle, wedding-appropriate color palette.
5. **Minimal borders** — Use shadows and spacing instead of harsh borders.
6. **Rounded corners everywhere** — Soft, approachable design with `rounded-lg` or `rounded-xl`.
7. **Focus on calm and elegance** — This is not a corporate dashboard. This is a wedding product.

---

## 2. Layout Rules

### Page Structure

Every authenticated page must follow this structure:

1. **Top navigation bar**
2. **Page container centered**
3. **Consistent spacing and padding**

### Container Standards

```blade
<div class="min-h-screen bg-gray-50">
    {{-- Navigation --}}
    <x-navigation />
    
    {{-- Main Content --}}
    <main class="max-w-5xl mx-auto px-6 py-8">
        {{-- Page Header --}}
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-900">Page Title</h1>
            <p class="mt-2 text-gray-600">Optional description</p>
        </div>
        
        {{-- Content sections with consistent spacing --}}
        <div class="space-y-8">
            {{-- Section 1 --}}
            <x-card>
                <!-- Content -->
            </x-card>
            
            {{-- Section 2 --}}
            <x-card>
                <!-- Content -->
            </x-card>
        </div>
    </main>
</div>
```

### Key Layout Classes

- **Container max width**: `max-w-5xl` (1280px)
- **Container padding**: `px-6 py-8`
- **Section spacing**: `space-y-8` (2rem vertical spacing between sections)
- **Background color**: `bg-gray-50` for page background
- **Centered content**: `mx-auto` for horizontal centering

---

## 3. Typography

### Hierarchy

Use clear typographic hierarchy:

```blade
{{-- Page Title --}}
<h1 class="text-3xl font-bold text-gray-900">Main Page Title</h1>

{{-- Section Heading --}}
<h2 class="text-2xl font-semibold text-gray-800">Section Title</h2>

{{-- Subsection Heading --}}
<h3 class="text-xl font-medium text-gray-800">Subsection Title</h3>

{{-- Body Text --}}
<p class="text-base text-gray-700">Regular content text</p>

{{-- Secondary Text --}}
<p class="text-sm text-gray-600">Helper text, descriptions</p>

{{-- Small Text --}}
<p class="text-xs text-gray-500">Labels, captions, metadata</p>
```

### Typography Rules

- **Font sizes**: Prefer larger sizes (text-base, text-lg, text-xl) over small text
- **Line height**: Use comfortable line heights (`leading-relaxed` or `leading-loose`)
- **Font weight**: Use `font-medium`, `font-semibold`, `font-bold` for emphasis
- **Text color**: Use gray-scale for hierarchy (gray-900, gray-800, gray-700, gray-600, gray-500)
- **Avoid**: Dense paragraphs, tiny text, cramped spacing

---

## 4. Color Palette

### Primary Colors

```css
/* Primary Brand Color - Rose */
rose-50   #fff1f2  /* Lightest backgrounds */
rose-100  #ffe4e6  /* Hover states, subtle highlights */
rose-500  #f43f5e  /* Primary actions, important elements */
rose-600  #e11d48  /* Hover state for rose-500 */
rose-700  #be123c  /* Active state */

/* Neutral Colors - Gray */
gray-50   #f9fafb  /* Page background */
gray-100  #f3f4f6  /* Card backgrounds */
gray-200  #e5e7eb  /* Borders, dividers */
gray-300  #d1d5db  /* Disabled states */
gray-600  #4b5563  /* Secondary text */
gray-700  #374151  /* Body text */
gray-800  #1f2937  /* Headings */
gray-900  #111827  /* Primary text */
```

### Color Usage Rules

- **Primary actions**: `bg-rose-500 hover:bg-rose-600 text-white`
- **Secondary actions**: `bg-white hover:bg-gray-50 text-gray-700 border border-gray-300`
- **Danger actions**: `bg-red-500 hover:bg-red-600 text-white`
- **Success states**: `bg-green-500` or `text-green-600`
- **Text colors**: Start with `gray-900` for titles, `gray-700` for body, `gray-600` for secondary
- **Backgrounds**: `bg-gray-50` for pages, `bg-white` for cards
- **Borders**: Use subtle `border-gray-200` or `border-gray-300`

### Avoid

- ❌ Pure black (#000000)
- ❌ Aggressive reds, blues, or neon colors
- ❌ High-contrast color combinations
- ❌ More than 3-4 colors in a single view

---

## 5. Spacing & Padding

### Spacing Scale

Use Tailwind's spacing scale consistently:

```blade
{{-- Micro spacing (4px) --}}
space-y-1, gap-1, p-1

{{-- Small spacing (8px) --}}
space-y-2, gap-2, p-2

{{-- Standard spacing (16px) --}}
space-y-4, gap-4, p-4

{{-- Medium spacing (24px) --}}
space-y-6, gap-6, p-6

{{-- Large spacing (32px) --}}
space-y-8, gap-8, p-8

{{-- Extra large spacing (48px) --}}
space-y-12, gap-12, p-12
```

### Standard Patterns

```blade
{{-- Card padding --}}
<x-card class="p-6">
    <!-- Content -->
</x-card>

{{-- Form field spacing --}}
<div class="space-y-4">
    <div>
        <label>Field 1</label>
        <input />
    </div>
    <div>
        <label>Field 2</label>
        <input />
    </div>
</div>

{{-- Section spacing --}}
<div class="space-y-8">
    <section><!-- Section 1 --></section>
    <section><!-- Section 2 --></section>
</div>

{{-- Button groups --}}
<div class="flex gap-3">
    <button>Action 1</button>
    <button>Action 2</button>
</div>
```

---

## 6. Components

### Buttons

**Primary Button**
```blade
<x-button variant="primary">
    Save Changes
</x-button>

{{-- Implementation --}}
<button class="px-4 py-2 bg-rose-500 text-white rounded-lg hover:bg-rose-600 focus:ring-2 focus:ring-rose-500 focus:ring-offset-2 transition-colors">
    Save Changes
</button>
```

**Secondary Button**
```blade
<x-button variant="secondary">
    Cancel
</x-button>

{{-- Implementation --}}
<button class="px-4 py-2 bg-white text-gray-700 border border-gray-300 rounded-lg hover:bg-gray-50 focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 transition-colors">
    Cancel
</button>
```

**Danger Button**
```blade
<x-button variant="danger">
    Delete
</x-button>

{{-- Implementation --}}
<button class="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition-colors">
    Delete
</button>
```

### Button Rules

- **Size**: Comfortable padding `px-4 py-2` or `px-6 py-3` for larger buttons
- **Border radius**: `rounded-lg` (8px)
- **Transitions**: Always include `transition-colors` for smooth hover effects
- **Focus states**: Use `focus:ring-2` for accessibility
- **Icon buttons**: Include text labels or use clear iconography

---

### Cards

```blade
<x-card>
    <x-slot:header>
        <h3 class="text-lg font-semibold text-gray-900">Card Title</h3>
    </x-slot:header>
    
    <div class="space-y-4">
        {{-- Card content --}}
    </div>
    
    <x-slot:footer>
        <div class="flex justify-end gap-3">
            <x-button variant="secondary">Cancel</x-button>
            <x-button variant="primary">Save</x-button>
        </div>
    </x-slot:footer>
</x-card>

{{-- Implementation --}}
<div class="bg-white rounded-lg shadow-sm border border-gray-200">
    {{-- Header (optional) --}}
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-lg font-semibold text-gray-900">Card Title</h3>
    </div>
    
    {{-- Body --}}
    <div class="p-6">
        <!-- Card content -->
    </div>
    
    {{-- Footer (optional) --}}
    <div class="px-6 py-4 bg-gray-50 border-t border-gray-200 rounded-b-lg">
        <!-- Footer actions -->
    </div>
</div>
```

### Card Rules

- **Background**: `bg-white`
- **Border radius**: `rounded-lg`
- **Shadow**: `shadow-sm` (subtle shadow)
- **Border**: `border border-gray-200` (subtle border)
- **Padding**: `p-6` for body, `px-6 py-4` for header/footer
- **Spacing**: Use `space-y-8` between cards

---

### Forms & Inputs

```blade
<div class="space-y-6">
    {{-- Text Input --}}
    <div>
        <label for="name" class="block text-sm font-medium text-gray-700 mb-2">
            Name
        </label>
        <input 
            type="text" 
            id="name"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-rose-500 focus:border-rose-500 transition-colors"
            placeholder="Enter your name"
        />
        <p class="mt-1 text-sm text-gray-500">Helper text goes here</p>
    </div>
    
    {{-- Select Dropdown --}}
    <div>
        <label for="status" class="block text-sm font-medium text-gray-700 mb-2">
            Status
        </label>
        <select 
            id="status"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-rose-500 focus:border-rose-500 transition-colors"
        >
            <option>Pending</option>
            <option>Confirmed</option>
            <option>Declined</option>
        </select>
    </div>
    
    {{-- Checkbox --}}
    <div class="flex items-start">
        <input 
            type="checkbox" 
            id="terms"
            class="mt-1 w-4 h-4 text-rose-500 border-gray-300 rounded focus:ring-rose-500"
        />
        <label for="terms" class="ml-2 text-sm text-gray-700">
            I agree to the terms and conditions
        </label>
    </div>
</div>
```

### Input Rules

- **Width**: Full width `w-full` by default
- **Padding**: `px-4 py-2` for comfortable click targets
- **Border**: `border border-gray-300`
- **Border radius**: `rounded-lg`
- **Focus state**: `focus:ring-2 focus:ring-rose-500 focus:border-rose-500`
- **Labels**: Always include labels with `text-sm font-medium text-gray-700`
- **Helper text**: Use `text-sm text-gray-500` below inputs
- **Error state**: Add `border-red-500 focus:ring-red-500` for validation errors

---

### Tables

```blade
<x-table>
    <x-slot:header>
        <th>Name</th>
        <th>Email</th>
        <th>Status</th>
        <th>Actions</th>
    </x-slot:header>
    
    <x-slot:body>
        <tr>
            <td>John Doe</td>
            <td>john@example.com</td>
            <td><x-badge variant="success">Confirmed</x-badge></td>
            <td>
                <button>Edit</button>
            </td>
        </tr>
    </x-slot:body>
</x-table>

{{-- Implementation --}}
<div class="overflow-x-auto">
    <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
            <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Name
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Email
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Status
                </th>
                <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                </th>
            </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
            <tr class="hover:bg-gray-50 transition-colors">
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">John Doe</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">john@example.com</td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <span class="px-2 py-1 text-xs font-medium rounded-full bg-green-100 text-green-800">
                        Confirmed
                    </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm">
                    <button class="text-rose-500 hover:text-rose-700">Edit</button>
                </td>
            </tr>
        </tbody>
    </table>
</div>
```

### Table Rules

- **Wrapper**: Use `overflow-x-auto` for responsive scrolling
- **Header background**: `bg-gray-50`
- **Dividers**: `divide-y divide-gray-200` for row separation
- **Cell padding**: `px-6 py-4` for comfortable spacing
- **Hover state**: `hover:bg-gray-50` on rows
- **Text alignment**: Left-align text, right-align actions
- **Header text**: `text-xs font-medium text-gray-500 uppercase`

---

### Badges & Status Indicators

```blade
{{-- Success Badge --}}
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
    Confirmed
</span>

{{-- Warning Badge --}}
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
    Pending
</span>

{{-- Danger Badge --}}
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
    Declined
</span>

{{-- Info Badge --}}
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
    Info
</span>
```

### Badge Rules

- **Shape**: `rounded-full` for pill shape
- **Size**: `text-xs font-medium`
- **Padding**: `px-2.5 py-0.5`
- **Colors**: Use background + text color pairs (e.g., `bg-green-100 text-green-800`)
- **Usage**: Status indicators, counts, labels

---

### Metric Cards (Dashboard)

```blade
<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
    {{-- Metric Card --}}
    <x-metric-card>
        <x-slot:label>Total Guests</x-slot:label>
        <x-slot:value>156</x-slot:value>
        <x-slot:change positive>+12%</x-slot:change>
    </x-metric-card>
</div>

{{-- Implementation --}}
<div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
    <div class="flex items-center justify-between">
        <p class="text-sm font-medium text-gray-600">Total Guests</p>
        <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <!-- Icon -->
        </svg>
    </div>
    <div class="mt-4">
        <p class="text-3xl font-bold text-gray-900">156</p>
        <p class="mt-2 text-sm text-green-600 flex items-center">
            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z" clip-rule="evenodd"/>
            </svg>
            +12% from last month
        </p>
    </div>
</div>
```

### Metric Card Rules

- **Layout**: Use grid with responsive columns (`grid-cols-1 md:grid-cols-3`)
- **Value size**: Large, bold numbers (`text-3xl font-bold`)
- **Label**: Small, medium weight (`text-sm font-medium text-gray-600`)
- **Change indicator**: Color-coded with icons (green for positive, red for negative)
- **Icon**: Top-right corner, subtle color

---

## 7. Responsive Design

### Breakpoints

Use Tailwind's responsive prefixes:

```blade
{{-- Mobile-first approach --}}
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <!-- Cards -->
</div>

<div class="flex flex-col md:flex-row gap-4">
    <!-- Buttons -->
</div>
```

### Responsive Rules

- **Default**: Mobile layout (single column)
- **Medium screens (md:)**: 768px+ (tablets)
- **Large screens (lg:)**: 1024px+ (desktops)
- **Padding**: Reduce on mobile (`px-4 md:px-6`)
- **Font sizes**: Scale down on mobile if needed
- **Navigation**: Consider mobile menu for small screens

---

## 8. Dark Mode (Future Feature)

When implementing dark mode:

```blade
{{-- Light mode (default) --}}
<div class="bg-white text-gray-900 dark:bg-gray-900 dark:text-gray-100">
    <!-- Content -->
</div>

{{-- Card in dark mode --}}
<div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700">
    <!-- Content -->
</div>
```

### Dark Mode Color Mapping

- `bg-white` → `dark:bg-gray-900`
- `bg-gray-50` → `dark:bg-gray-800`
- `bg-gray-100` → `dark:bg-gray-700`
- `text-gray-900` → `dark:text-gray-100`
- `text-gray-700` → `dark:text-gray-300`
- `border-gray-200` → `dark:border-gray-700`

---

## 9. Icons

### Icon Guidelines

- **Library**: Use Heroicons (https://heroicons.com/) or similar
- **Size**: `w-5 h-5` for inline icons, `w-6 h-6` for standalone
- **Color**: Match surrounding text color
- **Stroke width**: Use `stroke-width="2"` for consistency
- **Placement**: Left or right of text, never without context

```blade
{{-- Button with icon --}}
<button class="inline-flex items-center gap-2 px-4 py-2 bg-rose-500 text-white rounded-lg">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
    </svg>
    Add Guest
</button>
```

---

## 10. Animations & Transitions

### Transition Rules

- **Always include transitions** on interactive elements
- **Use** `transition-colors` for color changes
- **Use** `transition-all` sparingly (performance impact)
- **Duration**: Default to 150-200ms

```blade
{{-- Button transitions --}}
<button class="bg-rose-500 hover:bg-rose-600 transition-colors duration-150">
    Click me
</button>

{{-- Card hover --}}
<div class="bg-white hover:shadow-lg transition-shadow duration-200">
    <!-- Content -->
</div>

{{-- Smooth fade-in --}}
<div class="opacity-0 animate-fade-in">
    <!-- Content -->
</div>
```

### Animation Guidelines

- **Keep animations subtle** — This is an elegant wedding app, not a game
- **Use for feedback** — Loading states, success messages, deletions
- **Avoid excessive motion** — Don't animate everything
- **Respect accessibility** — Consider `prefers-reduced-motion`

---

## 11. Empty States

### Empty State Pattern

```blade
<div class="text-center py-12">
    {{-- Icon --}}
    <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
    </svg>
    
    {{-- Title --}}
    <h3 class="mt-4 text-lg font-medium text-gray-900">No guests yet</h3>
    
    {{-- Description --}}
    <p class="mt-2 text-sm text-gray-600">
        Get started by adding your first guest to the wedding list.
    </p>
    
    {{-- Action --}}
    <div class="mt-6">
        <x-button variant="primary">
            Add First Guest
        </x-button>
    </div>
</div>
```

### Empty State Rules

- **Center content** with `text-center`
- **Large icon** (12x12) in gray-400
- **Clear title** explaining what's missing
- **Helpful description** with guidance
- **Primary action** to create first item
- **Generous padding** (`py-12`)

---

## 12. Loading States

### Loading Patterns

```blade
{{-- Spinner --}}
<div class="flex items-center justify-center py-8">
    <svg class="animate-spin h-8 w-8 text-rose-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>
</div>

{{-- Skeleton loader --}}
<div class="animate-pulse space-y-4">
    <div class="h-4 bg-gray-200 rounded w-3/4"></div>
    <div class="h-4 bg-gray-200 rounded w-1/2"></div>
    <div class="h-4 bg-gray-200 rounded w-5/6"></div>
</div>

{{-- Button loading state --}}
<button disabled class="inline-flex items-center gap-2 px-4 py-2 bg-rose-500 text-white rounded-lg opacity-50 cursor-not-allowed">
    <svg class="animate-spin h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>
    Processing...
</button>
```

---

## 13. Alerts & Messages

### Alert Patterns

```blade
{{-- Success Alert --}}
<div class="rounded-lg bg-green-50 border border-green-200 p-4">
    <div class="flex items-start">
        <svg class="w-5 h-5 text-green-500 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
        </svg>
        <div class="ml-3">
            <h3 class="text-sm font-medium text-green-800">Guest added successfully</h3>
            <p class="mt-1 text-sm text-green-700">John Doe has been added to your wedding guest list.</p>
        </div>
    </div>
</div>

{{-- Error Alert --}}
<div class="rounded-lg bg-red-50 border border-red-200 p-4">
    <div class="flex items-start">
        <svg class="w-5 h-5 text-red-500 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
        </svg>
        <div class="ml-3">
            <h3 class="text-sm font-medium text-red-800">Error saving guest</h3>
            <p class="mt-1 text-sm text-red-700">Please check the form and try again.</p>
        </div>
    </div>
</div>

{{-- Warning Alert --}}
<div class="rounded-lg bg-yellow-50 border border-yellow-200 p-4">
    <div class="flex items-start">
        <svg class="w-5 h-5 text-yellow-500 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
        </svg>
        <div class="ml-3">
            <h3 class="text-sm font-medium text-yellow-800">Payment pending</h3>
            <p class="mt-1 text-sm text-yellow-700">Your payment is being processed. This may take a few minutes.</p>
        </div>
    </div>
</div>
```

---

## 14. Modals & Dialogs

### Modal Pattern

```blade
{{-- Modal Backdrop --}}
<div class="fixed inset-0 bg-gray-500 bg-opacity-75 z-40"></div>

{{-- Modal Container --}}
<div class="fixed inset-0 z-50 overflow-y-auto">
    <div class="flex min-h-full items-center justify-center p-4">
        {{-- Modal Content --}}
        <div class="bg-white rounded-lg shadow-xl max-w-lg w-full">
            {{-- Header --}}
            <div class="px-6 py-4 border-b border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900">Delete Guest</h3>
            </div>
            
            {{-- Body --}}
            <div class="px-6 py-4">
                <p class="text-gray-700">Are you sure you want to delete this guest? This action cannot be undone.</p>
            </div>
            
            {{-- Footer --}}
            <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end gap-3">
                <x-button variant="secondary">Cancel</x-button>
                <x-button variant="danger">Delete</x-button>
            </div>
        </div>
    </div>
</div>
```

### Modal Rules

- **Backdrop**: Semi-transparent gray overlay (`bg-gray-500 bg-opacity-75`)
- **Centering**: Use flexbox for vertical and horizontal centering
- **Max width**: Limit modal width (`max-w-lg` or `max-w-2xl`)
- **Z-index**: Ensure modal is above other content (`z-50`)
- **Rounded corners**: `rounded-lg`
- **Actions**: Right-aligned in footer
- **Close**: Include close button or cancel action

---

## 15. Navigation

### Top Navigation Bar

```blade
<nav class="bg-white border-b border-gray-200">
    <div class="max-w-7xl mx-auto px-6">
        <div class="flex justify-between items-center h-16">
            {{-- Logo --}}
            <div class="flex items-center">
                <a href="/" class="text-xl font-bold text-rose-500">
                    Eterno
                </a>
            </div>
            
            {{-- Navigation Links --}}
            <div class="hidden md:flex items-center space-x-8">
                <a href="/dashboard" class="text-gray-700 hover:text-rose-500 transition-colors">
                    Dashboard
                </a>
                <a href="/guests" class="text-gray-700 hover:text-rose-500 transition-colors">
                    Guests
                </a>
                <a href="/checkin" class="text-gray-700 hover:text-rose-500 transition-colors">
                    Check-in
                </a>
            </div>
            
            {{-- User Menu --}}
            <div class="flex items-center gap-4">
                <span class="text-sm text-gray-600">John Doe</span>
                <button class="text-gray-700 hover:text-rose-500">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <!-- User icon -->
                    </svg>
                </button>
            </div>
        </div>
    </div>
</nav>
```

### Navigation Rules

- **Height**: Fixed height `h-16` (64px)
- **Background**: White with subtle border
- **Logo**: Bold, rose-500 color
- **Links**: Gray text with rose hover state
- **Spacing**: `space-x-8` between links
- **Mobile**: Hide links on mobile (`hidden md:flex`), show hamburger menu
- **Active state**: Add `text-rose-500` or `border-b-2 border-rose-500` for current page

---

## 16. LLM Code Generation Rules

When generating UI code with LLMs:

### Must Do ✅

1. **Always use Blade components** (`<x-button>`, `<x-card>`, etc.)
2. **Follow the container structure** with `max-w-5xl mx-auto px-6 py-8`
3. **Use semantic spacing** (`space-y-8` between sections, `space-y-4` within sections)
4. **Include focus states** on all interactive elements
5. **Use the correct color palette** (rose-500 primary, gray scale)
6. **Include transitions** on hover states
7. **Provide empty states** for lists and collections
8. **Add loading states** for async operations
9. **Use proper typography hierarchy** (h1, h2, h3 with correct sizes)
10. **Center content** with `mx-auto`

### Never Do ❌

1. ❌ **Never** use pure black (#000) or aggressive colors
2. ❌ **Never** skip spacing between sections
3. ❌ **Never** use small, dense text
4. ❌ **Never** create layouts wider than `max-w-5xl`
5. ❌ **Never** use square corners (always `rounded-lg`)
6. ❌ **Never** skip focus states on interactive elements
7. ❌ **Never** use inline styles (use Tailwind classes)
8. ❌ **Never** create custom colors outside the defined palette
9. ❌ **Never** forget responsive design (`md:`, `lg:` prefixes)
10. ❌ **Never** skip empty states on lists

---

## 17. Checklist for New Pages

Before marking a page as complete, verify:

- [ ] Page uses `max-w-5xl mx-auto px-6 py-8` container
- [ ] Sections have `space-y-8` vertical spacing
- [ ] All buttons use `<x-button>` component with correct variant
- [ ] All cards use `<x-card>` component with `rounded-lg shadow-sm`
- [ ] Typography follows hierarchy (text-3xl, text-2xl, text-xl, text-base)
- [ ] Colors are from approved palette (rose-500, gray scale)
- [ ] All interactive elements have hover and focus states
- [ ] Empty states are included for lists/collections
- [ ] Loading states are implemented for async operations
- [ ] Forms use proper labels, inputs, and validation error display
- [ ] Responsive design works on mobile, tablet, and desktop
- [ ] All text is readable (no tiny text)
- [ ] Generous white space throughout
- [ ] Icons are consistent size (w-5 h-5)
- [ ] Transitions are smooth (transition-colors)

---

## 18. Examples

### Example: Dashboard Page

```blade
@extends('layouts.app')

@section('content')
<div class="min-h-screen bg-gray-50">
    <x-navigation />
    
    <main class="max-w-5xl mx-auto px-6 py-8">
        {{-- Page Header --}}
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-900">Dashboard</h1>
            <p class="mt-2 text-gray-600">Welcome back! Here's an overview of your wedding.</p>
        </div>
        
        {{-- Metrics --}}
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <x-metric-card label="Total Guests" value="156" change="+12" positive />
            <x-metric-card label="Confirmed" value="124" change="+8" positive />
            <x-metric-card label="Declined" value="12" change="-2" negative />
        </div>
        
        {{-- Recent Activity --}}
        <div class="space-y-8">
            <x-card>
                <x-slot:header>
                    <h2 class="text-lg font-semibold text-gray-900">Recent RSVPs</h2>
                </x-slot:header>
                
                <div class="space-y-4">
                    {{-- Activity items --}}
                </div>
            </x-card>
        </div>
    </main>
</div>
@endsection
```

### Example: Guest List Page

```blade
@extends('layouts.app')

@section('content')
<div class="min-h-screen bg-gray-50">
    <x-navigation />
    
    <main class="max-w-5xl mx-auto px-6 py-8">
        {{-- Page Header --}}
        <div class="flex items-center justify-between mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900">Guests</h1>
                <p class="mt-2 text-gray-600">Manage your wedding guest list</p>
            </div>
            <x-button variant="primary" href="/guests/create">
                Add Guest
            </x-button>
        </div>
        
        {{-- Filters --}}
        <x-card class="mb-8">
            <div class="flex gap-4">
                <input 
                    type="text" 
                    placeholder="Search guests..."
                    class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-rose-500"
                />
                <select class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-rose-500">
                    <option>All Status</option>
                    <option>Confirmed</option>
                    <option>Pending</option>
                    <option>Declined</option>
                </select>
            </div>
        </x-card>
        
        {{-- Guest Table --}}
        <x-card>
            <x-table>
                <x-slot:header>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Status</th>
                    <th>Actions</th>
                </x-slot:header>
                <x-slot:body>
                    @forelse($guests as $guest)
                        <tr>
                            <td>{{ $guest->name }}</td>
                            <td>{{ $guest->email }}</td>
                            <td>{{ $guest->phone }}</td>
                            <td>
                                <x-badge :variant="$guest->status">
                                    {{ $guest->status }}
                                </x-badge>
                            </td>
                            <td>
                                <div class="flex gap-2">
                                    <a href="/guests/{{ $guest->id }}/edit" class="text-rose-500 hover:text-rose-700">
                                        Edit
                                    </a>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="5">
                                <x-empty-state 
                                    title="No guests yet"
                                    description="Get started by adding your first guest to the wedding list."
                                    action="Add First Guest"
                                    href="/guests/create"
                                />
                            </td>
                        </tr>
                    @endforelse
                </x-slot:body>
            </x-table>
        </x-card>
    </main>
</div>
@endsection
```

---

## Conclusion

These UI guidelines are **mandatory** for all screens in the Eterno project.

The goal is to create a **consistent, elegant, and predictable** user experience that reflects the emotional and celebratory nature of weddings.

When in doubt, choose:
- **Simplicity** over complexity
- **Space** over density
- **Large** over small
- **Soft** over harsh
- **Elegant** over aggressive

**Remember**: This is a wedding product. Design with emotion, care, and celebration in mind.
