# Coding Style Guidelines

This document defines coding standards and quality guidelines for the **Eterno Wedding Guest Manager** project.

**Goal:** High-quality, maintainable, consistent code, compatible with **PHP 8.3**, **Laravel 11**, and LLM-assisted development.

> **Note:** These guidelines apply to **all new code**. Existing code should be updated gradually during refactoring or when making changes to specific files.

---

## 1️⃣ PHP Version Requirements

- All code must be compatible with **PHP 8.3**
- Use modern PHP 8.3 features:
  - **readonly properties**
  - **Enums**
  - **Union types**
  - **Constructor property promotion**
  - **Named arguments**
  - **Attributes**
- Avoid deprecated features from PHP 8.2 and prior
- Use `declare(strict_types=1);` in all PHP files

**Example:**

```php
<?php
declare(strict_types=1);

namespace App\DTOs;

readonly class WeddingData
{
    public function __construct(
        public int $userId,
        public string $coupleName,
        public \DateTimeImmutable $date,
        public string $venue,
    ) {}
}
```

---

## 2️⃣ PSR-12 & Code Formatting

- Follow **PSR-12** standard (via Laravel Pint)
- Use **4-space indentation**
- Curly braces on same line for classes and methods
- Opening PHP tag `<?php` only (no short tags)
- One class/interface/enum per file
- Use `declare(strict_types=1);` at the top of all PHP files

### Formatting Rules

**Correct:**
```php
<?php
declare(strict_types=1);

namespace App\Actions;

class CreateWeddingAction
{
    public function execute(CreateWeddingData $data): Wedding
    {
        // Implementation
    }
}
```

**Incorrect:**
```php
<?php
namespace App\Actions;

class CreateWeddingAction {
    function execute($data) {
        // Implementation
    }
}
```

---

## 3️⃣ PHPStan — Static Analysis (Level 8)

### Requirements

- Enforce **PHPStan level 8** for all code
- Strict typing and type safety
- Detect dead code, undefined variables, invalid property access

### Run PHPStan

```bash
vendor/bin/phpstan analyse --level=8 app
```

### Rules

- ✅ **Typed properties mandatory** in DTOs and Actions
- ✅ **Nullable types explicit:** `?string $email`
- ✅ **Return types declared** on all methods
- ✅ **No @var** unless unavoidable
- ❌ **Avoid `mixed`** unless absolutely necessary
- ✅ **Document array types** with `@param array<int, string>` when needed

**Example:**

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
        return $this->weddingService->create($data);
    }
}
```

---

## 4️⃣ Laravel Pint — Code Formatting (PSR-12)

### Configuration

Create `pint.json` in project root:

```json
{
    "preset": "psr12",
    "exclude": ["vendor", "storage", "node_modules"],
    "rules": {
        "array_syntax": {"syntax": "short"},
        "single_line_throw": true,
        "blank_line_after_namespace": true,
        "blank_line_after_opening_tag": true,
        "blank_line_before_statement": {
            "statements": ["return"]
        },
        "no_unused_imports": true
    }
}
```

### Run Pint

```bash
./vendor/bin/pint
```

**Auto-format before every push or PR.**

---

## 5️⃣ Rector — Automated Refactoring

### Purpose

- PHP 8.3 migration and modernizations
- Automated code improvements
- Type declarations
- Dead code removal

### Configuration

Create `rector.php` in project root:

```php
<?php
declare(strict_types=1);

use Rector\Config\RectorConfig;
use Rector\Set\ValueObject\SetList;
use Rector\Set\ValueObject\LevelSetList;

return RectorConfig::configure()
    ->withPaths([
        __DIR__ . '/app',
        __DIR__ . '/database',
    ])
    ->withSets([
        LevelSetList::UP_TO_PHP_83,
        SetList::CODE_QUALITY,
        SetList::TYPE_DECLARATION,
        SetList::DEAD_CODE,
    ])
    ->withSkip([
        // Add paths to skip if needed
    ]);
```

### Run Rector

```bash
vendor/bin/rector process
```

**Run Rector before major upgrades and refactoring sessions.**

---

## 6️⃣ Namespace & Autoloading

### PSR-4 Autoloading

Folder structure must match namespace consistently:

```
app/
 ├── Actions/        → App\Actions
 ├── Services/       → App\Services
 ├── DTOs/           → App\DTOs
 ├── Enums/          → App\Enums
 ├── Models/         → App\Models
 ├── Policies/       → App\Policies
 └── Http/
      ├── Controllers → App\Http\Controllers
      └── Requests    → App\Http\Requests
```

All classes must be autoloadable via Composer's PSR-4 autoloader.

---

## 7️⃣ Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| **Classes** | PascalCase | `CreateWeddingAction` |
| **Services** | PascalCase + `Service` suffix | `RSVPService`, `WeddingService` |
| **Actions** | PascalCase + `Action` suffix | `CreateWeddingAction`, `SubmitRSVPAction` |
| **DTOs** | PascalCase + `Data` suffix | `CreateWeddingData`, `UpdateGuestData` |
| **Enums** | PascalCase, singular | `RSVPStatus`, `PaymentStatus` |
| **Variables** | camelCase | `$userId`, `$guestList` |
| **Methods** | camelCase, descriptive | `submitRSVP()`, `checkInGuest()` |
| **Constants** | UPPER_SNAKE_CASE | `MAX_GUESTS`, `DEFAULT_CAPACITY` |
| **Properties** | camelCase, readonly when possible | `public readonly string $name;` |

---

## 8️⃣ Comments & DocBlocks

### Philosophy

**Prefer typed properties and strict types over comments.**

### When to Use Comments

✅ **Use DocBlocks for:**
- Methods with complex logic
- Return types with generics (e.g., `@return array<int, Guest>`)
- `@throws` annotations for domain exceptions
- Public APIs that need documentation

❌ **Avoid:**
- Inline comments like `// TODO` unless paired with issue ID
- Obvious comments that just repeat the code
- Commented-out code

**Example:**

```php
/**
 * Create a new wedding for the user.
 *
 * @param CreateWeddingData $data The wedding data
 * @return Wedding The created wedding
 * @throws PlanLimitExceededException When user exceeds their plan limit
 */
public function execute(CreateWeddingData $data): Wedding
{
    return $this->weddingService->create($data);
}
```

---

## 9️⃣ Testing Conventions

### Testing Requirements

- Use **PHPUnit** for all tests
- **Test Actions first** using Feature tests
- **Test Services** using Unit tests
- **Mock external dependencies** (Stripe, email, webhooks)
- **Coverage goal: 80%+**

### Test Structure

```php
<?php
declare(strict_types=1);

namespace Tests\Feature\Wedding;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;

class CreateWeddingTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_create_wedding(): void
    {
        // Arrange
        $user = User::factory()->create();
        $data = new CreateWeddingData(
            userId: $user->id,
            name: 'My Wedding',
            date: '2025-06-15',
            venue: 'Beautiful Venue',
        );
        
        // Act
        $action = app(CreateWeddingAction::class);
        $wedding = $action->execute($data);
        
        // Assert
        $this->assertDatabaseHas('weddings', [
            'name' => 'My Wedding',
            'user_id' => $user->id,
        ]);
    }
}
```

**For comprehensive testing guidelines, see [TESTING_GUIDELINES.md](TESTING_GUIDELINES.md).**

---

## 🔟 Git & Code Workflow

### Before Pushing Code

**Run these commands in order:**

```bash
# 1. Format code
./vendor/bin/pint

# 2. Static analysis
vendor/bin/phpstan analyse --level=8

# 3. Run tests
php artisan test

# 4. Check coverage
php artisan test --coverage --min=80
```

### Pull Request Requirements

- ✅ All tests must pass
- ✅ PHPStan level 8 must pass
- ✅ Code must be formatted with Pint
- ✅ Coverage must be 80%+ for new code
- ✅ PR must have descriptive title and description
- ✅ Changes must follow architectural guidelines

---

## 🎯 Code Quality Checklist

Before submitting a PR, verify:

- [ ] Code follows PSR-12 (run Pint)
- [ ] PHPStan level 8 passes
- [ ] All tests pass
- [ ] Coverage is 80%+
- [ ] `declare(strict_types=1);` in all PHP files
- [ ] All properties are typed
- [ ] All methods have return types
- [ ] DTOs are readonly
- [ ] Enums used for status fields
- [ ] No business logic in Controllers
- [ ] Actions have single `execute()` method
- [ ] Services are stateless
- [ ] Dependency injection used everywhere
- [ ] No `mixed` types unless necessary
- [ ] No unused imports

---

## 📚 Integration with Other Guidelines

This document focuses on **code style and quality**. For complete project guidelines, see:

- **[ARCHITECTURES_GUIDELINES.md](ARCHITECTURES_GUIDELINES.md)** — Architecture patterns and layer responsibilities
- **[TESTING_GUIDELINES.md](TESTING_GUIDELINES.md)** — Comprehensive testing rules and patterns
- **[UI_GUIDELINES.md](UI_GUIDELINES.md)** — UI/UX design principles

---

## 🤖 LLM-Friendly Patterns

When working with LLMs (GitHub Copilot, ChatGPT, etc.):

✅ **DO:**
- Follow strict typing
- Use readonly properties in DTOs
- Use Enums for statuses
- Follow naming conventions exactly
- Create separate Action classes
- Write descriptive method names
- Use dependency injection

❌ **DON'T:**
- Use `mixed` types
- Skip type declarations
- Use raw strings for statuses
- Put business logic in Controllers
- Use `@var` annotations unless necessary
- Create large monolithic classes

**Consistency is key for LLM-assisted development.**

---

## ✅ Summary

| Tool | Purpose | Command |
|------|---------|---------|
| **PHP 8.3** | Modern PHP features | N/A |
| **PSR-12** | Code formatting standard | Via Pint |
| **Laravel Pint** | Auto-formatter | `./vendor/bin/pint` |
| **PHPStan Level 8** | Static analysis | `vendor/bin/phpstan analyse` |
| **Rector** | Automated refactoring | `vendor/bin/rector process` |
| **PHPUnit** | Testing framework | `php artisan test` |

**All code must pass these quality checks before merging.**

---

## 🔧 Installation

### Install PHPStan

```bash
composer require --dev phpstan/phpstan
```

### Install Rector

```bash
composer require --dev rector/rector
```

### Pint (Already Installed)

Laravel Pint is included with Laravel by default.

---

## 🔄 Gradual Adoption Strategy

These guidelines apply to **all new code** starting immediately. For existing code:

### When to Apply These Standards

✅ **Apply when:**
- Creating new files (Actions, DTOs, Services, Controllers)
- Making significant changes to existing files
- Refactoring legacy code
- Adding new features or fixing bugs

⏳ **Defer for later:**
- Files you're not actively changing
- Large-scale reformatting (do in dedicated refactoring PRs)
- Third-party code or generated files

### Gradual Migration

1. **Start with new code**: All new files follow these guidelines 100%
2. **Touch and improve**: When editing old files, add `declare(strict_types=1);`, type hints, and format with Pint
3. **Dedicated refactoring**: Schedule periodic refactoring sessions to modernize old code
4. **Use Rector**: Run Rector to automatically upgrade PHP version features

**Goal:** All code follows these standards within 6 months of guideline adoption.

---

## 📞 Questions?

For questions about code style:
- Review existing code in `app/Actions`, `app/Services`, `app/DTOs`
- Check the other guideline documents
- Follow PSR-12 and PHPStan recommendations

**Consistency is mandatory. Quality is non-negotiable.**
