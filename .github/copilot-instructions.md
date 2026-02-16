# GitHub Copilot Instructions for Eterno Project

## Project Architecture

This Laravel project follows a **strict layered architecture**:

```
Controller → Action → Service → Model
```

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

## Testing Approach

- **Test Actions** using Feature tests
- **Mock Services** when testing Actions
- **Focus on business behavior**, not implementation details
- Avoid testing Controllers directly
- **Always follow** [TESTING_GUIDELINES.md](../TESTING_GUIDELINES.md) for comprehensive testing rules
- **Minimum 80% code coverage** for new features
- **Test edge cases thoroughly** — limits, invalid data, empty states

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
