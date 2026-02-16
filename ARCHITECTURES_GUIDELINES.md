Architecture Overview
This project follows a strict layered architecture designed for:

Maintainability
Testability
Clear separation of concerns
Consistency when working with LLMs
Predictable structure for future contributors
The architecture is based on:

Controller → Action → Service → Model

Core Principles
Controllers contain no business logic.
Every business operation is represented by an Action.
Actions expose only one public method: execute().
Services contain reusable domain logic.
Models contain no business logic (only relationships, casts, scopes).
Validation is handled exclusively by FormRequest classes.
Status values must use Enums.
Actions must never receive Request objects.
Services must not access Auth or HTTP concerns.
Dependency Injection is required everywhere.
Folder Structure
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

Layer Responsibilities
Controllers
Responsible for:

Receiving HTTP requests
Calling FormRequest validation
Creating DTOs
Calling Actions
Returning responses
Controllers must:

Never contain business rules
Never perform calculations
Never directly manipulate models beyond retrieval
Form Requests
Responsible for:

Input validation
Authorization (if simple)
All validation must be defined here.
No inline validation inside controllers.

DTOs (Data Transfer Objects)
DTOs:

Are immutable
Contain typed properties
Represent structured input for Actions
Decouple HTTP layer from domain layer
DTOs must:

Not contain business logic
Not access database
Only transport structured data
Actions (Use Cases)
Each Action represents a single use case.

Examples:

CreateWeddingAction
UpdateGuestAction
SubmitRSVPAction
CheckInGuestAction
Rules:

Only one public method: execute()
Accept DTOs or explicit parameters
Return domain models or value objects
May call Services
May dispatch Events
May use DB transactions
Actions orchestrate business operations.

Services
Services contain reusable domain logic.

Examples:

RSVPService
CheckInService
WeddingCapacityService
PaymentService
Rules:

No HTTP awareness
No Request usage
No direct Auth usage
Can depend on Models
Can contain pure business rules
Services should be stateless when possible.

Models
Models are Eloquent ORM representations.

Models must:

Define relationships
Define casts
Define scopes
Avoid embedding business rules
No heavy logic inside models.

Enums
All status fields must use PHP Enums.

Examples:

RSVPStatus
PaymentStatus
Never use raw strings for statuses.

Example Flow
Example: Submit RSVP
RSVPController receives request
FormRequest validates input
Controller creates RSVPResponseData DTO
Controller calls SubmitRSVPAction
Action calls RSVPService
Guest model is updated
Controller returns response
Testing Strategy
Test Actions using Feature tests
Mock Services if needed
Avoid testing Controllers directly
Focus tests on business behavior
LLM Development Rules
When generating code with LLM:

Always create an Action for new business logic.
Always create a DTO for structured input.
Never place logic inside Controllers.
Never pass Request into Services.
Follow naming conventions strictly.
This consistency is mandatory.
