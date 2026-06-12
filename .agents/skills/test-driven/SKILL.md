---
name: test-driven
description: "Enforces TDD practices and test quality standards. Validates naming conventions, AAA structure (Arrange-Act-Assert), test isolation, and coverage minimums. Java: Mockito + @ExtendWith(MockitoExtension) only for unit tests — no @SpringBootTest. TypeScript: Vitest. Use when writing tests, reviewing test quality, or setting up TDD workflow."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: backend-dev, frontend-dev, testing
  phase: development, testing
---

# Test-Driven Development Skill

You are enforcing **Test-Driven Development (TDD)** practices and **test quality
standards** for **{{PROJECT_NAME}}**.

---

## TDD Workflow

### Red-Green-Refactor Cycle

1. **RED**: Write a failing test that describes the desired behavior
2. **GREEN**: Write the minimum code to make the test pass
3. **REFACTOR**: Clean up code while keeping tests green

### Before Writing Implementation Code

1. Understand the requirement/acceptance criteria
2. Write test cases FIRST (at least the happy path)
3. Run tests — they should FAIL (red)
4. Implement the minimum code to pass
5. Run tests — they should PASS (green)
6. Refactor if needed
7. Repeat for edge cases

---

## Test Quality Standards

### Naming Convention

**Test class/module names:**
```
// Java
class UserServiceTest { }
class PaymentControllerIntegrationTest { }

// TypeScript
describe('UserService', () => { });
describe('PaymentController', () => { });
```

**Test method names** — describe BEHAVIOR, not implementation:
```java
// ✅ Good — describes behavior
@Test
void shouldReturnUserWhenIdExists() { }

@Test
void shouldThrowNotFoundExceptionWhenUserDoesNotExist() { }

@Test
void shouldCalculateTotalWithDiscount() { }

// ❌ Bad — describes implementation
@Test
void testGetUser() { }

@Test
void testFindById() { }
```

```typescript
// ✅ Good
it('should return user when id exists', () => { });
it('should throw not found error when user does not exist', () => { });

// ❌ Bad
it('getUser works', () => { });
it('test findById', () => { });
```

### AAA Pattern (Arrange-Act-Assert)

Every test must follow this structure:

```java
@Test
void shouldReturnUserWhenIdExists() {
    // Arrange
    var userId = UUID.randomUUID();
    var expectedUser = new User(userId, "John Doe");
    when(userRepository.findById(userId)).thenReturn(Optional.of(expectedUser));

    // Act
    var result = userService.getUser(userId);

    // Assert
    assertThat(result).isEqualTo(expectedUser);
    verify(userRepository).findById(userId);
}
```

```typescript
it('should return user when id exists', async () => {
  // Arrange
  const userId = '123';
  const expectedUser = { id: userId, name: 'John Doe' };
  vi.mocked(userRepository.findById).mockResolvedValue(expectedUser);

  // Act
  const result = await userService.getUser(userId);

  // Assert
  expect(result).toEqual(expectedUser);
  expect(userRepository.findById).toHaveBeenCalledWith(userId);
});
```

**Rules:**
- ONE Act section per test — test one behavior at a time
- Arrange sets up ALL preconditions before the Act
- Assert verifies ALL expected outcomes after the Act
- No logic in Assert section — only comparisons

### Test Isolation

- **Each test must be independent** — no shared state between tests
- **No test ordering dependency** — tests must pass in any order
- **Clean setup/teardown** — reset mocks, clear databases between tests
- **No shared mutable state** — each test creates its own data

```java
// ✅ Good — isolated test
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    @Mock private UserRepository userRepository;
    @InjectMocks private UserService userService;

    @Test
    void shouldCreateUser() {
        // Each test sets up its own data
        var request = new CreateUserRequest("John", "john@test.com");
        when(userRepository.save(any())).thenReturn(new User(UUID.randomUUID(), "John"));

        var result = userService.createUser(request);

        assertThat(result.getName()).isEqualTo("John");
    }
}
```

### What NOT to Do

```java
// ❌ BAD: @SpringBootTest for unit tests
@SpringBootTest  // WRONG — this is an integration test annotation
class UserServiceTest { }

// ❌ BAD: Testing implementation details
@Test
void shouldCallRepositorySave() {
    userService.createUser(request);
    verify(userRepository, times(1)).save(any());  // Testing HOW, not WHAT
}

// ❌ BAD: Multiple assertions testing different behaviors
@Test
void shouldDoEverything() {
    var user = userService.getUser(id);
    assertThat(user.getName()).isEqualTo("John");
    var orders = orderService.getOrders(id);  // Different service!
    assertThat(orders).hasSize(3);
}

// ❌ BAD: Fragile assertions
assertThat(result.toString()).contains("User(id=123, name=John)");  // Depends on toString format
```

---

## Java Testing Standards

### Unit Tests

```java
@ExtendWith(MockitoExtension.class)
class ServiceNameTest {

    @Mock
    private DependencyRepository repository;

    @Mock
    private ExternalService externalService;

    @InjectMocks
    private ServiceName service;

    @Test
    void shouldBehaviorWhenCondition() {
        // Arrange
        // Act
        // Assert
    }
}
```

**Rules:**
- **Always use `@ExtendWith(MockitoExtension.class)`** — never `@SpringBootTest` for unit tests
- **Mock all dependencies** — use `@Mock` and `@InjectMocks`
- **No database access** — unit tests are in-memory only
- **No HTTP calls** — mock all external services
- **Fast execution** — unit tests should complete in milliseconds

### Integration Tests

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test")
class ControllerIntegrationTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void shouldReturnUserWhenAuthenticated() {
        // Use real Spring context, real database (Testcontainers)
    }
}
```

**Rules:**
- Use `@SpringBootTest` ONLY for integration tests
- Use Testcontainers for database dependencies
- Use `@ActiveProfiles("test")` for test configuration
- Separate test source set: `src/integrationTest/`

---

## TypeScript Testing Standards

### Unit Tests (Vitest)

```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { UserService } from './user.service';

describe('UserService', () => {
  let service: UserService;
  let mockRepository: Mocked<UserRepository>;

  beforeEach(() => {
    mockRepository = {
      findById: vi.fn(),
      save: vi.fn(),
    };
    service = new UserService(mockRepository);
  });

  it('should return user when id exists', async () => {
    // Arrange
    const expectedUser = { id: '123', name: 'John' };
    mockRepository.findById.mockResolvedValue(expectedUser);

    // Act
    const result = await service.getUser('123');

    // Assert
    expect(result).toEqual(expectedUser);
  });
});
```

### Component Tests

```typescript
import { render, screen, fireEvent } from '@testing-library/vue';
import UserProfile from './UserProfile.vue';

describe('UserProfile', () => {
  it('should display user name when loaded', async () => {
    // Arrange
    const user = { name: 'John Doe', role: 'Admin' };

    // Act
    render(UserProfile, { props: { user } });

    // Assert
    expect(screen.getByText('John Doe')).toBeVisible();
    expect(screen.getByText('Admin')).toBeVisible();
  });
});
```

---

## Coverage Requirements

### Minimum Coverage: {{MIN_COVERAGE}}

| Type | Target | Scope |
|------|--------|-------|
| Line coverage | {{MIN_COVERAGE}} | All production code |
| Branch coverage | {{MIN_COVERAGE}} - 10% | All conditionals |
| Critical paths | 100% | Payment, auth, security logic |

### Coverage Report Check

```bash
# Java (JaCoCo)
mvn verify
# Check: target/site/jacoco/index.html

# TypeScript (Vitest + Istanbul)
npx vitest --coverage
# Check: coverage/lcov-report/index.html
```

---

## Test Case Checklist

Before marking a test as complete:

- [ ] Test name describes behavior (not implementation)
- [ ] Follows AAA pattern (Arrange-Act-Assert)
- [ ] Only ONE Act per test
- [ ] Test is isolated (no shared state)
- [ ] No test ordering dependency
- [ ] Mocks used appropriately (not over-mocked)
- [ ] Edge cases covered (null, empty, boundary, error)
- [ ] No fragile assertions (no toString comparison)
- [ ] No testing of implementation details
- [ ] Coverage meets minimum threshold

---

## Rules

1. **Test first** — write tests before implementation (TDD)
2. **One behavior per test** — do not test multiple things in one test
3. **Behavior, not implementation** — test WHAT, not HOW
4. **Isolation** — each test is independent and self-contained
5. **Fast feedback** — unit tests must be fast (< 100ms per test)
6. **No @SpringBootTest for unit tests** — use Mockito + @ExtendWith(MockitoExtension)
7. **Coverage is a floor, not a ceiling** — {{MIN_COVERAGE}} is minimum, aim higher
