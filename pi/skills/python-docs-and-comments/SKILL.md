---
name: python-docs-and-comments
description: Review and improve Python comments and docstrings for aiohttp backend code.
---

# Python Docs and Comments

Use this skill when the task is specifically about:

- adding missing docstrings
- improving handler contracts
- cleaning stale comments
- reviewing TODO/FIXME quality

Follow the canonical policy in `.skills/python-docs-and-comments.md`.

Apply these rules:

- keep comments high-signal and non-obvious
- prefer explaining intent, invariants, side effects, and risks
- avoid narrating obvious code
- document only facts supported by the code
- do not invent route paths, status codes, auth requirements, or side effects
- add handler docstrings for aiohttp entrypoints
- update stale comments/docstrings in the same edit

## Docstring format requirement

All Python docstrings added or changed by this skill **must use Google-style docstrings**.

This requirement is mandatory for:

- modules
- classes
- functions
- methods
- aiohttp handlers
- service methods
- controller methods
- helpers with non-obvious behavior

Do not use NumPy-style, Sphinx/reStructuredText-style, Javadoc-style, or free-form mixed docstrings.

### Google-style sections

Use only the sections that are relevant to the function being documented.

Common sections:

- `Args:`
- `Returns:`
- `Yields:`
- `Raises:`
- `Attributes:`
- `Example:`
- `Note:`

Do not add empty sections.

Do not add sections just to make the docstring look complete.

### Preferred function docstring shape

```python
async def get_company_data(company_id: str) -> CompanyData:
    """Load company data for dashboard rendering.

    Args:
        company_id: Public company identifier used by dashboard routes.

    Returns:
        Company data prepared for the dashboard view.

    Raises:
        CompanyNotFoundError: If the company does not exist.
    """
```

### Aiohttp handler docstrings

For aiohttp handlers, document the user-visible contract and side effects without inventing route paths or status codes.

Good:

```python
async def company_page(request: web.Request) -> ViewResponse:
    """Render the company dashboard page.

    Args:
        request: Incoming aiohttp request with route parameters and user context.

    Returns:
        View response containing the company page context.

    Raises:
        HTTPNotFound: If the requested company cannot be found.
    """
```

Bad:

```python
async def company_page(request):
    """GET /companies/{id}; returns 200/404."""
```

Only mention route paths, status codes, authentication, cache behavior, database writes, or external calls when they are directly visible in the code being edited.

### Comment and docstring quality

Docstrings should explain:

- purpose
- contract
- important arguments
- returned value
- raised exceptions
- side effects
- invariants
- non-obvious business rules

Docstrings should not explain:

- obvious Python syntax
- every local variable
- implementation steps that may change soon
- facts not supported by the code

### Final check

Before finishing a docs/comments edit, verify:

- every added or changed Python docstring is Google-style
- no NumPy/Sphinx-style sections were introduced
- no empty docstring sections remain
- comments and docstrings match the current code
- stale comments were updated or removed
- no unsupported API, auth, route, status-code, or side-effect claims were added
