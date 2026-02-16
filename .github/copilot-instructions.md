# GitHub Copilot Instructions for Eterno Project

## Project Architecture

This Laravel project follows a **strict layered architecture**:

```
Controller → Action → Service → Model
```

## Code Quality Standards

This project enforces **strict code quality standards** for consistency and maintainability.

> **Important:** These standards apply to **all new code** and files being modified. Apply these rules when creating new features or editing existing files.

### Core Requirements

- **PHP 8.3+** with modern features (readonly properties, Enums, typed properties)
- **PSR-12** formatting via Laravel Pint
- **PHPStan Level 8** static analysis
- **Rector** for automated refactoring
- **80%+ test coverage** for all new features
- **`declare(strict_types=1);`** in all PHP files

### Quality Tools

Run these commands before every commit:

```bash
./vendor/bin/pint              # Format code (PSR-12)
vendor/bin/phpstan analyse     # Static analysis (Level 8)
php artisan test               # Run tests
php artisan test --coverage    # Check coverage
```

**For complete code style guidelines, see [CODING_STYLE_GUIDELINES.md](../CODING_STYLE_GUIDELINES.md).**

## Critical Rules for Code Generation

### 1. Controllers
- ❌ **NEVER** add business logic to controllers
- ✅ Controllers should ONLY:
  - Receive HTTP requests
  - Call FormRequest for validation
  - Create DTOs
  - Call Actions
  - Return responses

### 2. Actions (Use Cases)
- ✅ **ALWAYS** create an Action for new business logic
- ✅ Actions must have only ONE public method: `execute()`
- ✅ Actions receive DTOs or explicit parameters (NEVER Request objects)
- ✅ Actions return domain models or value objects
- ✅ Actions may call Services, dispatch Events, use DB transactions

### 3. Services
- ✅ Services contain reusable domain logic
- ❌ **NEVER** inject Request objects into Services
- ❌ **NEVER** use Auth facade in Services
- ✅ Services should be stateless when possible

### 4. DTOs (Data Transfer Objects)
- ✅ **ALWAYS** create a DTO for structured input to Actions
- ✅ DTOs are immutable with typed properties
- ❌ DTOs must NOT contain business logic
- ❌ DTOs must NOT access the database

### 5. Validation
- ✅ **ALWAYS** use FormRequest classes for validation
- ❌ **NEVER** use inline validation in controllers

### 6. Status Values
- ✅ **ALWAYS** use PHP Enums for status fields
- ❌ **NEVER** use raw strings for statuses

### 7. Models
- ✅ Models should ONLY define: relationships, casts, scopes
- ❌ **NEVER** add business logic to models

### 8. Dependency Injection
- ✅ Use dependency injection everywhere
- ✅ Type-hint all dependencies

## Code Generation Template

When generating a new feature, follow this pattern:

### 1. Create FormRequest
```php
// app/Http/Requests/CreateWeddingRequest.php
class CreateWeddingRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            // ... validation rules
        ];
    }
}
```

### 2. Create DTO
```php
// app/DTOs/CreateWeddingData.php
readonly class CreateWeddingData
{
    public function __construct(
        public string $name,
        public string $date,
        // ... typed properties
    ) {}
}
```

### 3. Create Action
```php
// app/Actions/CreateWeddingAction.php
class CreateWeddingAction
{
    public function __construct(
        private WeddingService $weddingService
    ) {}

    public function execute(CreateWeddingData $data): Wedding
    {
        // Orchestrate the use case
        return $this->weddingService->create($data);
    }
}
```

### 4. Create Service (if needed)
```php
// app/Services/WeddingService.php
class WeddingService
{
    public function create(CreateWeddingData $data): Wedding
    {
        // Domain logic here
        return Wedding::create([
            'name' => $data->name,
            'date' => $data->date,
        ]);
    }
}
```

### 5. Create Controller
```php
// app/Http/Controllers/WeddingController.php
class WeddingController extends Controller
{
    public function __construct(
        private CreateWeddingAction $createWeddingAction
    ) {}

    public function store(CreateWeddingRequest $request)
    {
        $data = new CreateWeddingData(
            name: $request->input('name'),
            date: $request->input('date'),
        );

        $wedding = $this->createWeddingAction->execute($data);

        return redirect()->route('weddings.show', $wedding);
    }
}
```

## Naming Conventions

- **Actions**: `{Verb}{Entity}Action` (e.g., `CreateWeddingAction`, `UpdateGuestAction`)
- **Services**: `{Entity}Service` (e.g., `WeddingService`, `RSVPService`)
- **DTOs**: `{Verb}{Entity}Data` (e.g., `CreateWeddingData`, `UpdateGuestData`)
- **FormRequests**: `{Verb}{Entity}Request` (e.g., `CreateWeddingRequest`)
- **Enums**: `{Entity}Status` or `{Entity}Type` (e.g., `RSVPStatus`, `PaymentStatus`)
- **Variables/Properties**: camelCase (e.g., `$userId`, `$guestList`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_GUESTS`, `DEFAULT_CAPACITY`)

## Code Style Requirements

### Mandatory in Every PHP File

```php
<?php
declare(strict_types=1);

namespace App\Actions;

// All class code here
```

### Type Declarations

✅ **ALWAYS:**
- Use typed properties: `public string $name`
- Use readonly for DTOs: `readonly class CreateWeddingData`
- Declare return types: `public function execute(): Wedding`
- Use PHP 8.3 features: constructor property promotion, Enums
- Use nullable types explicitly: `?string $email`

❌ **NEVER:**
- Skip `declare(strict_types=1);`
- Use `mixed` type (unless absolutely necessary)
- Skip return type declarations
- Use docblock types instead of native types

### Example DTO

```php
<?php
declare(strict_types=1);

namespace App\DTOs;

readonly class CreateWeddingData
{
    public function __construct(
        public int $userId,
        public string $name,
        public string $date,
        public string $venue,
        public ?int $capacity = null,
    ) {}
}
```

### Example Action

```php
<?php
declare(strict_types=1);

namespace App\Actions;

class CreateWeddingAction
{
    public function __construct(
        private WeddingService $weddingService
    ) {}

    public function execute(CreateWeddingData $data): Wedding
    {
        // Implementation
        return $this->weddingService->create($data);
    }
}
```

## Testing Approach

- **Test Actions** using Feature tests
- **Mock Services** when testing Actions
- **Focus on business behavior**, not implementation details
- Avoid testing Controllers directly
- **Always follow** [TESTING_GUIDELINES.md](../TESTING_GUIDELINES.md) for comprehensive testing rules
- **Minimum 80% code coverage** for new features
- **Test edge cases thoroughly** — limits, invalid data, empty states

## UI Guidelines

This project follows **strict UI/UX design principles** for elegance and consistency.

### Design Principles

1. **Simplicity over feature density** — Less is more
2. **White space is mandatory** — Generous spacing creates elegance
3. **Large typography over small dense text** — Readability first
4. **Soft colors, not aggressive contrast** — Wedding-appropriate palette
5. **Minimal borders** — Use shadows and spacing
6. **Rounded corners everywhere** — `rounded-lg` or `rounded-xl`
7. **Focus on calm and elegance** — This is a wedding product, not a corporate dashboard

### Layout Standards

Every page must follow this structure:

```blade
<div class="min-h-screen bg-gray-50">
    <x-navigation />
    
    <main class="max-w-5xl mx-auto px-6 py-8">
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-900">Page Title</h1>
            <p class="mt-2 text-gray-600">Optional description</p>
        </div>
        
        <div class="space-y-8">
            <x-card>
                <!-- Content -->
            </x-card>
        </div>
    </main>
</div>
```

**Key layout classes:**
- Container: `max-w-5xl mx-auto px-6 py-8`
- Section spacing: `space-y-8`
- Page background: `bg-gray-50`
- Card background: `bg-white`

### Typography Hierarchy

```blade
<h1 class="text-3xl font-bold text-gray-900">Page Title</h1>
<h2 class="text-2xl font-semibold text-gray-800">Section Title</h2>
<h3 class="text-xl font-medium text-gray-800">Subsection Title</h3>
<p class="text-base text-gray-700">Body text</p>
<p class="text-sm text-gray-600">Secondary text</p>
```

### Color Palette

- **Primary actions**: `bg-rose-500 hover:bg-rose-600 text-white`
- **Secondary actions**: `bg-white hover:bg-gray-50 text-gray-700 border border-gray-300`
- **Danger actions**: `bg-red-500 hover:bg-red-600 text-white`
- **Text colors**: `text-gray-900` (titles), `text-gray-700` (body), `text-gray-600` (secondary)
- **Backgrounds**: `bg-gray-50` (pages), `bg-white` (cards)
- **Borders**: `border-gray-200` or `border-gray-300`

### Components

Always use Blade components:

```blade
<x-button variant="primary">Save</x-button>
<x-button variant="secondary">Cancel</x-button>
<x-button variant="danger">Delete</x-button>

<x-card>
    <x-card-header>Card Title</x-card-header>
    <x-card-body>Card content</x-card-body>
</x-card>

<x-input label="Name" name="name" />
<x-textarea label="Notes" name="notes" />
```

### Spacing Standards

- **Between sections**: `space-y-8` (32px)
- **Within sections**: `space-y-4` (16px)
- **Card padding**: `p-6` (24px)
- **Button padding**: `px-4 py-2`
- **Form fields**: `space-y-4`

### UI Generation Rules for LLMs

✅ **Must Do:**
1. Always use Blade components (`<x-button>`, `<x-card>`)
2. Follow container structure with `max-w-5xl mx-auto px-6 py-8`
3. Use semantic spacing (`space-y-8` between sections)
4. Include focus states on interactive elements
5. Use correct color palette (rose-500 primary, gray scale)
6. Include transitions on hover states
7. Provide empty states for lists
8. Add loading states for async operations
9. Use proper typography hierarchy
10. Center content with `mx-auto`

❌ **Never Do:**
1. Never use pure black (#000) or aggressive colors
2. Never skip spacing between sections
3. Never use small, dense text
4. Never create layouts wider than `max-w-5xl`
5. Never use square corners (always `rounded-lg`)
6. Never skip focus states
7. Never use inline styles
8. Never create custom colors outside palette
9. Never forget responsive design (`md:`, `lg:` prefixes)
10. Never skip empty states on lists

### Page Checklist

Before completing a page, verify:
- [ ] Uses `max-w-5xl mx-auto px-6 py-8` container
- [ ] Sections have `space-y-8` spacing
- [ ] All buttons use `<x-button>` component
- [ ] All cards use `<x-card>` component
- [ ] Typography follows hierarchy
- [ ] Colors from approved palette
- [ ] Interactive elements have hover/focus states
- [ ] Empty states included
- [ ] Loading states implemented
- [ ] Generous white space throughout

For detailed UI guidelines, see [UI_GUIDELINES.md](../UI_GUIDELINES.md).

## Common Mistakes to Avoid

❌ **DON'T:**
```php
// Controller with business logic
public function store(Request $request) {
    $wedding = new Wedding();
    $wedding->name = $request->name;
    if ($request->has('premium')) {
        $wedding->capacity = 200;
    }
    $wedding->save();
    return redirect()->back();
}
```

✅ **DO:**
```php
// Controller delegates to Action
public function store(CreateWeddingRequest $request) {
    $data = new CreateWeddingData(...$request->validated());
    $wedding = $this->createWeddingAction->execute($data);
    return redirect()->route('weddings.show', $wedding);
}
```

---

❌ **DON'T:**
```php
// Service with HTTP concerns
class WeddingService {
    public function create(Request $request) {
        $user = Auth::user();
        // ...
    }
}
```

✅ **DO:**
```php
// Service with clean dependencies
class WeddingService {
    public function create(CreateWeddingData $data, User $user) {
        // ...
    }
}
```

## Remember

**This architectural consistency is MANDATORY.** When generating code:
1. Think: "Which layer does this belong to?"
2. Always create the full chain: FormRequest → DTO → Action → Service
3. Keep controllers thin
4. Keep services focused and reusable
5. Use dependency injection everywhere

For detailed information, see:
- [ARCHITECTURES_GUIDELINES.md](../ARCHITECTURES_GUIDELINES.md) — Architecture and code structure
- [TESTING_GUIDELINES.md](../TESTING_GUIDELINES.md) — Comprehensive testing rules and patterns
- [UI_GUIDELINES.md](../UI_GUIDELINES.md) — UI/UX design principles
- [CODING_STYLE_GUIDELINES.md](../CODING_STYLE_GUIDELINES.md) — Code style, formatting, and quality standards
