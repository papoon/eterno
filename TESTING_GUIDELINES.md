# Testing Guidelines

This document defines **mandatory testing rules** for the Eterno Wedding Guest Manager project, specifically for the **multi-event / B2B upgrade**.

All tests must follow these guidelines to ensure consistency, maintainability, and high code quality.

---

## Core Testing Principles

1. **Use PHPUnit** for all unit and feature tests
2. **Test Actions and Services first** — Controllers are just orchestrators
3. **Add HTTP/E2E tests** for FormRequest validation, authentication, and critical flows
4. **Mock external services** (Stripe, Paddle, email providers)
5. **Maintain 80%+ code coverage** for new features
6. **Keep Controllers thin** — Don't test controller orchestration, but do test the HTTP layer
7. **Test edge cases thoroughly** — limits, invalid data, empty states, boundary conditions
8. **Use DTOs as input** for Action tests
9. **Follow the same layered architecture** in tests as in production code

---

## Testing Architecture

```
HTTP/E2E Tests → Controllers → Actions → Services (mocked when needed) → Models
Feature Tests → Actions → Services (mocked when needed) → Models
Unit Tests → Services → Models
```

### What to Test

✅ **Must Test:**
- Actions (feature tests calling Actions directly)
- Services (unit tests for complex logic)
- HTTP endpoints (end-to-end tests for FormRequest validation, authorization, routing)
- Edge cases and boundary conditions
- Authorization and permissions
- Data validation through FormRequests
- Business rules enforcement

✅ **Optional but Recommended:**
- End-to-end HTTP tests for critical user flows
- FormRequest validation rules via HTTP tests
- Authentication and authorization via HTTP tests

❌ **Don't Test:**
- Controller orchestration logic (keep controllers thin)
- Blade views (unless testing complex components)
- Eloquent relationships (unless custom logic involved)
- Third-party library internals

---

## Test Structure

### Feature Tests

Feature tests should test complete use cases from the perspective of a user or system interaction.

**Location:** `tests/Feature/`

**Naming Convention:** `{Feature}{Action}Test.php`
- Examples: `CreateWeddingTest.php`, `SubmitRSVPTest.php`, `CheckInGuestTest.php`

**Structure:**
```php
class CreateWeddingTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function user_can_create_multiple_weddings(): void
    {
        // Arrange
        $user = User::factory()->create();
        $data = new CreateWeddingData(...);
        
        // Act
        $action = app(CreateWeddingAction::class);
        $wedding = $action->execute($data);
        
        // Assert
        $this->assertDatabaseHas('weddings', [
            'name' => $data->name,
            'user_id' => $user->id,
        ]);
    }
}
```

### Unit Tests

Unit tests focus on isolated pieces of logic, primarily in Services.

**Location:** `tests/Unit/`

**Naming Convention:** `{Service}Test.php`
- Examples: `WeddingServiceTest.php`, `RSVPServiceTest.php`

---

### HTTP / End-to-End Tests

HTTP tests verify the complete request/response cycle, including routing, middleware, authentication, authorization, and FormRequest validation.

**Location:** `tests/Feature/Http/`

**Naming Convention:** `{Feature}HttpTest.php`
- Examples: `CreateWeddingHttpTest.php`, `GuestManagementHttpTest.php`

**When to Use HTTP Tests:**
- Testing FormRequest validation rules
- Testing authentication and authorization middleware
- Testing routing and HTTP status codes
- Testing CSRF protection
- Testing rate limiting
- Critical user flows that need end-to-end validation

**Structure:**
```php
class CreateWeddingHttpTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function it_validates_required_fields(): void
    {
        $user = User::factory()->create();
        
        $response = $this->actingAs($user)->post(route('weddings.store'), [
            'name' => '', // Missing required field
            'date' => '',
            'venue' => '',
        ]);
        
        $response->assertSessionHasErrors(['name', 'date', 'venue']);
    }
    
    /** @test */
    public function it_creates_wedding_with_valid_data(): void
    {
        $user = User::factory()->create();
        
        $response = $this->actingAs($user)->post(route('weddings.store'), [
            'name' => 'My Wedding',
            'date' => '2025-06-15',
            'venue' => 'Beautiful Venue',
        ]);
        
        $response->assertRedirect();
        $this->assertDatabaseHas('weddings', [
            'name' => 'My Wedding',
            'user_id' => $user->id,
        ]);
    }
    
    /** @test */
    public function it_requires_authentication(): void
    {
        $response = $this->post(route('weddings.store'), [
            'name' => 'My Wedding',
            'date' => '2025-06-15',
            'venue' => 'Beautiful Venue',
        ]);
        
        $response->assertRedirect(route('login'));
    }
}
```

**Key Differences:**
- **HTTP Tests**: Test via HTTP requests (`$this->post()`, `$this->get()`, etc.), include validation, auth, routing
- **Feature Tests**: Test Actions directly via `app(Action::class)->execute()`, focus on business logic
- **Unit Tests**: Test Services in isolation with mocked dependencies

---

## Testing Guidelines by Feature

### 1️⃣ Multi-Event Support

#### Feature: Create Wedding (Multi-event)

**Tests Required:**

1. ✅ User can create multiple weddings
2. ✅ Wedding belongs to correct planner
3. ✅ Validation errors appear for required fields (name, date, venue)
4. ✅ Attempt to create wedding exceeding plan limit → fail with appropriate error
5. ✅ Slug generated automatically from wedding name
6. ✅ Duplicate wedding name allowed for different users
7. ✅ Wedding name unique per user

**Test Type:** Feature / Action test + HTTP test for validation

**Example Feature Test (Action):**
```php
/** @test */
public function cannot_create_wedding_exceeding_plan_limit(): void
{
    $user = User::factory()->withPlan('starter', limit: 2)->create();
    Wedding::factory()->count(2)->for($user)->create();
    
    $this->expectException(PlanLimitExceededException::class);
    
    $action = app(CreateWeddingAction::class);
    $action->execute(new CreateWeddingData(
        name: 'Third Wedding',
        date: '2025-01-01',
        venue: 'Test Venue',
        userId: $user->id
    ));
}
```

**Example HTTP Test (Validation):**
```php
/** @test */
public function it_validates_required_fields_when_creating_wedding(): void
{
    $user = User::factory()->create();
    
    $response = $this->actingAs($user)->post(route('weddings.store'), [
        'name' => '',  // Missing required
        'date' => '',  // Missing required
        'venue' => '',  // Missing required
    ]);
    
    $response->assertSessionHasErrors(['name', 'date', 'venue']);
}
```

---

#### Feature: Update/Delete Wedding

**Tests Required:**

1. ✅ Planner can edit wedding details (name, date, venue, capacity)
2. ✅ Planner cannot edit weddings of another user (403 Forbidden)
3. ✅ Deleting wedding cascades to associated guests
4. ✅ Database state verified after update/delete
5. ✅ Edge case: deleting wedding with zero guests works
6. ✅ Cannot delete wedding if already checked-in guests exist (optional business rule)

**Test Type:** Feature / Action test

---

### 2️⃣ Guest Management

#### Feature: Import Guests (CSV)

**Tests Required:**

1. ✅ CSV uploaded correctly → guests created
2. ✅ Incorrect CSV columns → error thrown with helpful message
3. ✅ Guests belong to correct wedding
4. ✅ Duplicate email in CSV → handled gracefully (either skip or merge)
5. ✅ Import preserves allowed plus-ones
6. ✅ Edge: CSV empty → warning message, no guests created
7. ✅ Edge: CSV with special characters in names → handled correctly
8. ✅ CSV with missing optional fields → guests created with defaults

**Test Type:** Feature / Action test

**Example Test:**
```php
/** @test */
public function import_handles_duplicate_emails_gracefully(): void
{
    $wedding = Wedding::factory()->create();
    $csvContent = "name,email,plus_ones\nJohn Doe,john@example.com,2\nJane Doe,john@example.com,1";
    
    $action = app(ImportGuestsAction::class);
    $result = $action->execute(new ImportGuestsData(
        weddingId: $wedding->id,
        csvContent: $csvContent
    ));
    
    $this->assertEquals(1, Guest::where('email', 'john@example.com')->count());
    $this->assertContains('Duplicate email detected', $result->warnings);
}
```

---

#### Feature: CRUD Guests

**Tests Required:**

1. ✅ Create guest manually with all fields
2. ✅ Update guest info (name, RSVP status, plus-ones, dietary notes)
3. ✅ Delete guest
4. ✅ Cannot edit guest from another wedding (403 Forbidden)
5. ✅ RSVP status enum validated (only allowed values)
6. ✅ Edge: plus-ones exceed wedding capacity → error
7. ✅ Edge: negative plus-ones → validation error
8. ✅ Edge: update non-existent guest → 404

**Test Type:** Unit + Feature tests

---

### 3️⃣ RSVP Public Page

**Tests Required:**

1. ✅ Guest can confirm presence via unique code
2. ✅ Guest can decline attendance
3. ✅ Plus-ones recorded correctly
4. ✅ Dietary notes saved and retrieved
5. ✅ Invalid code → 404 Not Found
6. ✅ Guest cannot submit twice if already confirmed (idempotent)
7. ✅ Confirmed guest updates wedding statistics
8. ✅ RSVP deadline enforced (if applicable)
9. ✅ Edge: submitting RSVP for expired wedding → warning or blocked

**Test Type:** Feature tests (DTO + Action)

**Example Test:**
```php
/** @test */
public function guest_can_confirm_presence_via_unique_code(): void
{
    $guest = Guest::factory()->create(['rsvp_status' => RSVPStatus::PENDING]);
    
    $action = app(SubmitRSVPAction::class);
    $action->execute(new SubmitRSVPData(
        code: $guest->unique_code,
        status: RSVPStatus::CONFIRMED,
        plusOnes: 2,
        dietaryNotes: 'Vegetarian'
    ));
    
    $guest->refresh();
    $this->assertEquals(RSVPStatus::CONFIRMED, $guest->rsvp_status);
    $this->assertEquals(2, $guest->plus_ones_confirmed);
    $this->assertEquals('Vegetarian', $guest->dietary_notes);
}
```

---

### 4️⃣ Check-in Mode

**Tests Required:**

1. ✅ Planner can search guests by name/email
2. ✅ Check-in button marks guest as present
3. ✅ Cannot check-in unconfirmed guests (business rule)
4. ✅ Cannot double check-in (idempotent)
5. ✅ Check-in count updates dynamically
6. ✅ Edge: check-in beyond wedding capacity → blocked or warning
7. ✅ Check-in timestamp recorded
8. ✅ Cannot check-in guests from another planner's wedding (403)

**Test Type:** Feature tests (CheckInAction + Service)

---

### 5️⃣ Dashboard Multi-Event

**Tests Required:**

1. ✅ Planner sees all their weddings
2. ✅ Wedding metrics displayed: total guests, confirmed, pending, declined
3. ✅ Navigation to wedding details works
4. ✅ Filter by date/status works correctly
5. ✅ Empty dashboard → show friendly message
6. ✅ Edge: large number of weddings → paginated correctly
7. ✅ Metrics aggregated correctly across multiple events
8. ✅ Only own weddings visible (no data leakage)

**Test Type:** Feature tests (Service + Action)

---

### 6️⃣ Export Reports

**Tests Required:**

1. ✅ Export individual wedding → CSV/PDF format correct
2. ✅ Export multi-wedding → CSV aggregates data from all events
3. ✅ Columns match specification (name, email, RSVP status, notes, check-in status)
4. ✅ Planner cannot export weddings from other planners (403)
5. ✅ Empty wedding → export empty file with headers
6. ✅ Edge: special characters in names → properly escaped
7. ✅ Edge: large dataset → export succeeds without timeout
8. ✅ PDF includes wedding branding (if applicable)

**Test Type:** Feature + Unit tests

---

### 7️⃣ B2B / Subscription & Plan Limits

**Tests Required:**

1. ✅ Subscription creation works (Stripe/Paddle integration mocked)
2. ✅ Planner cannot create wedding beyond plan limit
3. ✅ Upgrade plan → new limit applies immediately
4. ✅ Downgrade plan → existing events preserved, future limited
5. ✅ Billing dashboard shows correct limit remaining
6. ✅ Failed payment triggers alert
7. ✅ Subscription renewal updates limits
8. ✅ Cancelled subscription → grace period behavior
9. ✅ Edge: attempt to create wedding during grace period

**Test Type:** Unit + Feature + Mock Stripe/Paddle

**Example Test:**
```php
/** @test */
public function cannot_create_wedding_beyond_plan_limit(): void
{
    $user = User::factory()
        ->withSubscription(plan: 'starter', eventLimit: 3)
        ->create();
    
    Wedding::factory()->count(3)->for($user)->create();
    
    $this->expectException(PlanLimitExceededException::class);
    $this->expectExceptionMessage('Your Starter plan allows up to 3 events');
    
    $action = app(CreateWeddingAction::class);
    $action->execute(new CreateWeddingData(
        name: 'Fourth Wedding',
        date: '2025-06-01',
        venue: 'Test Venue',
        userId: $user->id
    ));
}
```

---

### 8️⃣ Alerts & Notifications

**Tests Required:**

1. ✅ Planner receives alert when approaching plan limit (e.g., 80% used)
2. ✅ Planner receives alert when payment fails
3. ✅ Alerts displayed in dashboard
4. ✅ Edge: multiple alerts → displayed correctly without overlap
5. ✅ Email notification sent (mocked)
6. ✅ Clicking upgrade link → redirects to billing page
7. ✅ Alerts can be dismissed
8. ✅ Dismissed alerts don't reappear

**Test Type:** Feature / Mock email

---

### 9️⃣ Edge Cases & Security

**Tests Required:**

1. ✅ Attempt actions without auth → redirected to login (302)
2. ✅ Planner cannot access weddings/guests of another planner → 403 Forbidden
3. ✅ Invalid IDs in URL → 404 Not Found
4. ✅ SQL injection tested in all text inputs → sanitized
5. ✅ XSS tested in guest names, notes, dietary info → escaped
6. ✅ Maximum number of guests per wedding enforced
7. ✅ Maximum events per plan enforced
8. ✅ CSRF protection on all state-changing operations
9. ✅ Rate limiting on public RSVP endpoints
10. ✅ Edge: concurrent request handling (race conditions)

**Test Type:** Feature / Security tests

---

## Mocking External Services

### Mocking Stripe/Paddle

```php
use Mockery;
use App\Services\PaymentService;

protected function setUp(): void
{
    parent::setUp();
    
    $mockPaymentService = Mockery::mock(PaymentService::class);
    $mockPaymentService->shouldReceive('createSubscription')
        ->andReturn(new Subscription(['status' => 'active']));
    
    $this->app->instance(PaymentService::class, $mockPaymentService);
}
```

### Mocking Email

```php
use Illuminate\Support\Facades\Mail;
use App\Mail\WelcomeEmail;

Mail::fake();

// ... perform action that sends email

Mail::assertSent(WelcomeEmail::class, function ($mail) use ($user) {
    return $mail->hasTo($user->email);
});
```

---

## Test Data Factories

Use Laravel Factories for consistent test data:

```php
// database/factories/WeddingFactory.php
class WeddingFactory extends Factory
{
    public function definition(): array
    {
        return [
            'name' => $this->faker->words(3, true),
            'date' => $this->faker->dateTimeBetween('+1 month', '+2 years'),
            'venue' => $this->faker->address(),
            'capacity' => $this->faker->numberBetween(50, 300),
            'slug' => $this->faker->slug(),
        ];
    }
    
    public function withGuests(int $count = 10): static
    {
        return $this->has(Guest::factory()->count($count));
    }
}
```

---

## Coverage Requirements

### Minimum Coverage by Component

- **Actions:** 95%+
- **Services:** 90%+
- **DTOs:** Not applicable (no logic)
- **Models:** 80%+ (scopes, custom methods)
- **Policies:** 100%
- **FormRequests:** Not directly tested (tested via feature tests)

### Running Coverage

```bash
php artisan test --coverage
php artisan test --coverage --min=80
```

---

## Test Naming Conventions

### Method Names

Use descriptive method names that read like specifications:

✅ **Good:**
```php
public function user_can_create_multiple_weddings(): void
public function cannot_create_wedding_exceeding_plan_limit(): void
public function guest_cannot_submit_rsvp_twice(): void
```

❌ **Bad:**
```php
public function test1(): void
public function testWedding(): void
public function create(): void
```

### File Organization

```
tests/
├── Feature/
│   ├── Http/
│   │   ├── CreateWeddingHttpTest.php
│   │   ├── UpdateWeddingHttpTest.php
│   │   ├── GuestManagementHttpTest.php
│   │   ├── RSVPHttpTest.php
│   │   └── CheckInHttpTest.php
│   ├── Wedding/
│   │   ├── CreateWeddingTest.php
│   │   ├── UpdateWeddingTest.php
│   │   └── DeleteWeddingTest.php
│   ├── Guest/
│   │   ├── ImportGuestsTest.php
│   │   ├── CreateGuestTest.php
│   │   └── UpdateGuestTest.php
│   ├── RSVP/
│   │   └── SubmitRSVPTest.php
│   ├── CheckIn/
│   │   └── CheckInGuestTest.php
│   └── Subscription/
│       ├── CreateSubscriptionTest.php
│       └── UpgradePlanTest.php
├── Unit/
│   ├── Services/
│   │   ├── WeddingServiceTest.php
│   │   ├── RSVPServiceTest.php
│   │   └── CheckInServiceTest.php
│   └── Models/
│       ├── WeddingTest.php
│       └── GuestTest.php
└── TestCase.php
```

---

## Running Tests

### Run All Tests

```bash
php artisan test
```

### Run Specific Test Suite

```bash
php artisan test --testsuite=Feature
php artisan test --testsuite=Unit
```

### Run Specific Test File

```bash
php artisan test tests/Feature/Wedding/CreateWeddingTest.php
```

### Run Specific Test Method

```bash
php artisan test --filter=user_can_create_multiple_weddings
```

### Run with Coverage

```bash
php artisan test --coverage
php artisan test --coverage --min=80
```

---

## Continuous Integration

All tests must pass before merging:

```yaml
# .github/workflows/tests.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
      - name: Install Dependencies
        run: composer install
      - name: Run Tests
        run: php artisan test --coverage --min=80
```

---

## Testing Checklist for New Features

When implementing a new feature, ensure:

- [ ] Feature tests written for all Actions (testing business logic)
- [ ] HTTP tests written for FormRequest validation and authentication
- [ ] Unit tests written for complex Service logic
- [ ] Edge cases and boundary conditions tested
- [ ] Security tests for authorization and input validation
- [ ] External services mocked appropriately
- [ ] Test data factories created or updated
- [ ] All tests pass locally
- [ ] Coverage meets 80%+ requirement
- [ ] Tests follow naming conventions
- [ ] Tests are organized in appropriate directories

---

## LLM Test Generation Rules

When an LLM (GitHub Copilot, ChatGPT, etc.) generates tests:

1. ✅ **Always generate Action tests** as Feature tests (testing Actions directly)
2. ✅ **Generate HTTP tests** for FormRequest validation, authentication, and critical flows
3. ✅ **Always use DTOs** as input to Actions
4. ✅ **Mock external services** (Stripe, Paddle, email)
5. ✅ **Follow naming conventions** strictly
6. ✅ **Test edge cases** for every feature
7. ✅ **Use factories** for test data
8. ✅ **Assert database state** after mutations
9. ❌ **Never test Controller orchestration logic** (keep controllers thin)
10. ❌ **Never skip edge case tests**
11. ❌ **Never use raw array data** instead of DTOs

### Test Type Decision Tree

- **Need to test business logic?** → Feature test calling Action directly
- **Need to test validation rules?** → HTTP test with invalid data
- **Need to test authentication/authorization?** → HTTP test without auth
- **Need to test a Service in isolation?** → Unit test with mocked dependencies
- **Need to test a critical user flow?** → HTTP test for the complete flow

---

## Common Testing Patterns

### Testing Authorization

```php
/** @test */
public function planner_cannot_access_another_planners_wedding(): void
{
    $planner1 = User::factory()->create();
    $planner2 = User::factory()->create();
    $wedding = Wedding::factory()->for($planner1)->create();
    
    $this->actingAs($planner2);
    
    $this->expectException(AuthorizationException::class);
    
    $action = app(UpdateWeddingAction::class);
    $action->execute(new UpdateWeddingData(
        weddingId: $wedding->id,
        name: 'New Name',
        userId: $planner2->id
    ));
}
```

### Testing Validation

**Action-level validation (DTO validation):**
```php
/** @test */
public function wedding_requires_valid_date(): void
{
    $this->expectException(ValidationException::class);
    
    $action = app(CreateWeddingAction::class);
    $action->execute(new CreateWeddingData(
        name: 'Test Wedding',
        date: 'invalid-date',  // Invalid date format
        venue: 'Test Venue',
        userId: auth()->id()
    ));
}
```

**HTTP-level validation (FormRequest validation):**
```php
/** @test */
public function it_validates_wedding_required_fields(): void
{
    $user = User::factory()->create();
    
    $response = $this->actingAs($user)->post(route('weddings.store'), [
        'name' => '',  // Required field missing
        'date' => '',  // Required field missing
        'venue' => '',  // Required field missing
    ]);
    
    $response->assertSessionHasErrors(['name', 'date', 'venue']);
}

/** @test */
public function it_validates_wedding_date_format(): void
{
    $user = User::factory()->create();
    
    $response = $this->actingAs($user)->post(route('weddings.store'), [
        'name' => 'My Wedding',
        'date' => 'invalid-date',  // Invalid date format
        'venue' => 'Beautiful Venue',
    ]);
    
    $response->assertSessionHasErrors(['date']);
}
```

### Testing Events

```php
use Illuminate\Support\Facades\Event;

/** @test */
public function wedding_created_event_dispatched(): void
{
    Event::fake([WeddingCreated::class]);
    
    $action = app(CreateWeddingAction::class);
    $wedding = $action->execute(new CreateWeddingData(...));
    
    Event::assertDispatched(WeddingCreated::class, function ($event) use ($wedding) {
        return $event->wedding->id === $wedding->id;
    });
}
```

---

## Summary

**This document is the source of truth for testing in the Eterno project.**

All new features must have tests following these guidelines. When working with LLMs to generate code:

1. Reference this document first
2. Generate tests following these patterns
3. Write HTTP tests for validation and authentication
4. Write Feature tests for business logic (Actions)
5. Write Unit tests for complex Services
6. Ensure 80%+ coverage
7. Mock external dependencies
8. Test edge cases thoroughly

**Testing is not optional. It is a requirement for all feature development.**

For architecture guidelines, see [ARCHITECTURES_GUIDELINES.md](ARCHITECTURES_GUIDELINES.md).

For UI guidelines, see [UI_GUIDELINES.md](UI_GUIDELINES.md).
