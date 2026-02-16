# Architecture Guidelines

## Architecture Overview

This project follows a strict layered architecture designed for:

- **Maintainability**
- **Testability**
- **Clear separation of concerns**
- **Consistency when working with LLMs**
- **Predictable structure for future contributors**

The architecture is based on:

```
Controller → Action → Service → Model
```

---

## Core Principles

1. **Controllers contain no business logic.**
2. **Every business operation is represented by an Action.**
3. **Actions expose only one public method: `execute()`.**
4. **Services contain reusable domain logic.**
5. **Models contain no business logic** (only relationships, casts, scopes).
6. **Validation is handled exclusively by FormRequest classes.**
7. **Status values must use Enums.**
8. **Actions must never receive Request objects.**
9. **Services must not access Auth or HTTP concerns.**
10. **Dependency Injection is required everywhere.**

---

## Folder Structure

```
app/
 ├── Actions/
 ├── Services/
 ├── DTOs/
 ├── Enums/
 ├── Models/
 ├── Policies/
 └── Http/
      ├── Controllers/
      └── Requests/
```

---

## Layer Responsibilities

### Controllers

**Responsible for:**
- Receiving HTTP requests
- Calling FormRequest validation
- Creating DTOs
- Calling Actions
- Returning responses

**Controllers must:**
- Never contain business rules
- Never perform calculations
- Never directly manipulate models beyond retrieval

---

### Form Requests

**Responsible for:**
- Input validation
- Authorization (if simple)

**Rules:**
- All validation must be defined here.
- No inline validation inside controllers.

---

### DTOs (Data Transfer Objects)

**DTOs:**
- Are immutable
- Contain typed properties
- Represent structured input for Actions
- Decouple HTTP layer from domain layer

**DTOs must:**
- Not contain business logic
- Not access database
- Only transport structured data

---

### Actions (Use Cases)

Each Action represents a single use case.

**Examples:**
- `CreateWeddingAction`
- `UpdateGuestAction`
- `SubmitRSVPAction`
- `CheckInGuestAction`

**Rules:**
- Only one public method: `execute()`
- Accept DTOs or explicit parameters
- Return domain models or value objects
- May call Services
- May dispatch Events
- May use DB transactions

**Actions orchestrate business operations.**

---

### Services

Services contain reusable domain logic.

**Examples:**
- `RSVPService`
- `CheckInService`
- `WeddingCapacityService`
- `PaymentService`

**Rules:**
- No HTTP awareness
- No Request usage
- No direct Auth usage
- Can depend on Models
- Can contain pure business rules

**Services should be stateless when possible.**

---

### Models

Models are Eloquent ORM representations.

**Models must:**
- Define relationships
- Define casts
- Define scopes
- Avoid embedding business rules

**No heavy logic inside models.**

---

### Enums

All status fields must use PHP Enums.

**Examples:**
- `RSVPStatus`
- `PaymentStatus`

**Never use raw strings for statuses.**

---

## Example Flow

### Example: Submit RSVP

1. `RSVPController` receives request
2. `FormRequest` validates input
3. Controller creates `RSVPResponseData` DTO
4. Controller calls `SubmitRSVPAction`
5. Action calls `RSVPService`
6. `Guest` model is updated
7. Controller returns response

---

## Testing Strategy

- **Test Actions** using Feature tests
- **Mock Services** if needed
- **Avoid testing Controllers** directly
- **Focus tests** on business behavior

---

## LLM Development Rules

When generating code with LLM:

- ✅ **Always create an Action** for new business logic.
- ✅ **Always create a DTO** for structured input.
- ❌ **Never place logic inside Controllers.**
- ❌ **Never pass Request into Services.**
- ✅ **Follow naming conventions strictly.**

**This consistency is mandatory.**
