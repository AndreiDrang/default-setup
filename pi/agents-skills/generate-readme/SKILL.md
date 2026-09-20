---
name: generate-readme
description: Creates and updates comprehensive README.md files for any project module with automatic analysis of code structure, dependencies, and functionality. Supports command-based invocation with path parameter.
---

# Universal README Generator

This skill creates comprehensive README.md files for **any project module** by analyzing the specified directory path. It automatically detects module type, structure, dependencies, and generates appropriate documentation.

## Usage

The skill will:
1. Analyze the specified directory path
2. Detect module type (Cloudflare Worker, Node.js, TypeScript, Python, etc.)
3. Extract configuration from relevant files
4. Generate comprehensive README.md in the target directory

## When to Use This Skill

- Creating documentation for a new module
- Updating existing README with current code analysis
- Standardizing documentation across different module types
- Generating README for any project component
- Automated documentation generation in CI/CD pipelines

## When NOT to Use This Skill

- **User provides explicit template**: Respect user's explicit template choice
- **Non-code directories**: For directories without source code (e.g., pure data directories)
- **Generated files only**: For directories containing only build outputs

## Supported Module Types

The skill automatically detects and adapts to:

### Cloudflare Workers
- Detects by: `wrangler.toml`, `.ts`/`.js` files in `src/`
- Generates: Queue bindings, service dependencies, configuration

### Node.js/TypeScript Modules
- Detects by: `package.json`, `.ts`/`.js` files
- Generates: Dependencies, exports, usage examples

### Python Modules
- Detects by: `requirements.txt`, `pyproject.toml`, `.py` files
- Generates: Dependencies, imports, usage examples

### Frontend Components
- Detects by: `.vue`, `.svelte`, `.jsx`, `.tsx` files
- Generates: Props, events, usage examples

### Generic Modules
- Detects by: Any source code files
- Generates: Structure, purpose, basic documentation

## README Structure

The generated README follows this adaptive structure:

```markdown
# {module-name}

## Overview
- Brief description (auto-generated from analysis)
- Module purpose and main functionality

## Features
- List of key features detected from code

## Installation/Setup
- Module-specific setup instructions

## Configuration
- Environment variables
- Configuration files
- Available options

## Usage
- Basic usage examples
- API/Interface documentation

## Architecture
- Module structure
- Key components
- Data flow (with Mermaid diagrams when applicable)

## Dependencies
- External dependencies
- Internal dependencies

## Testing
- Test commands
- Test coverage

## Deployment
- Deployment instructions

## Project Structure
- File tree with explanations

## Related Modules
- Links to related code
```

## Detection & Analysis Workflow

### Step 1: Path Analysis
1. Resolve the provided path to absolute path
2. Validate path exists and is a directory
3. Read directory contents
4. Identify file types and patterns

### Step 2: Module Type Detection
```
Priority order for type detection:
1. Cloudflare Worker: wrangler.toml + src/*.ts
2. Node.js/TypeScript: package.json + .ts/.js files
3. Python: requirements.txt/pyproject.toml + .py files
4. Frontend: .vue/.svelte/.jsx/.tsx files
5. Generic: Any source code files
```

### Step 3: Information Extraction

#### For Cloudflare Workers:
- Read `wrangler.toml` for configuration
- Extract queue bindings, secrets, environment variables
- Analyze main worker file for business logic
- Identify external service dependencies
- Detect AI model usage and prompts

#### For Node.js/TypeScript:
- Read `package.json` for dependencies and metadata
- Extract exported functions/classes from main files
- Identify type definitions
- Analyze test files for usage patterns

#### For Python:
- Read `requirements.txt` or `pyproject.toml` for dependencies
- Extract module docstrings
- Identify exported classes/functions
- Analyze imports for dependencies

#### For Frontend:
- Extract component props from `.vue`/`.svelte` files
- Identify emitted events
- Analyze template structure
- Extract style dependencies

### Step 4: README Generation

Generate README with sections appropriate for the detected module type:
- Use templates from `templates/` directory
- Adapt structure based on module complexity
- Include Mermaid diagrams for complex workflows
- Add code examples when applicable

## Command Processing

### Path Resolution
1. If path starts with `/`: Use as absolute path
2. If path starts with `./` or `../`: Resolve relative to current working directory
3. Otherwise: Resolve relative to workspace root

### Validation
- Check path exists
- Check path is a directory
- Check directory contains source code files
- Check write permissions

### Error Handling
- Invalid path: Return error with suggestion
- No source files: Return error with explanation
- Permission denied: Return error with context

## Templates

### Main Template (`templates/README-template.md`)
Universal README template with placeholders for all module types.

### Type-Specific Templates
- `templates/cloudflare-worker.md` - Cloudflare Worker specific
- `templates/node-module.md` - Node.js/TypeScript module
- `templates/python-module.md` - Python module
- `templates/frontend-component.md` - Frontend component

### Section Templates
- `templates/api-documentation.md` - API/Interface docs
- `templates/configuration.md` - Configuration section
- `templates/dependencies.md` - Dependencies section
- `templates/mermaid-diagrams.md` - Mermaid diagram examples

## Best Practices

### For All Modules
1. **Descriptive Names**: Use clear, descriptive module names
2. **Consistent Structure**: Follow project structure conventions
3. **Type Safety**: Use TypeScript/types when available
4. **Document Assumptions**: Document any non-obvious assumptions
5. **Link Related Code**: Reference related modules and dependencies

### For Cloudflare Workers
1. **Queue Documentation**: Document all queue bindings
2. **Secret Management**: Document required secrets
3. **Error Handling**: Document retry logic and error handling
4. **Performance**: Document performance considerations
5. **Cost Optimization**: Document cost optimization strategies

### For Node.js/TypeScript
1. **Export Documentation**: Document all exported members
2. **Type Definitions**: Include type information
3. **Usage Examples**: Provide clear usage examples
4. **Error Handling**: Document error cases

### For Python
1. **Docstrings**: Include module and function docstrings
2. **Type Hints**: Use type hints when available
3. **Dependency Management**: Document all dependencies
4. **Usage Patterns**: Show common usage patterns

### For Frontend
1. **Props Documentation**: Document all props
2. **Events**: Document emitted events
3. **Slots**: Document slots (for Vue/Svelte)
4. **Styling**: Document styling requirements

## Examples

### Example 1: Cloudflare Worker

For a Cloudflare Worker directory like `cf_workers/tb-news-ai-analyzer`:

Generates README with:
- Queue bindings from wrangler.toml
- Business logic from worker.ts
- AI model configuration
- Service dependencies
- Mermaid data flow diagram

### Example 2: Node.js Module

For a Node.js module directory like `src/utils/logger`:

Generates README with:
- Exported functions from index.ts
- Dependencies from package.json
- Usage examples
- Type definitions

### Example 3: Python Module

For a Python module directory like `src/data/processors`:

Generates README with:
- Module docstring
- Exported classes/functions
- Dependencies from requirements.txt
- Usage examples

## Quick Start

1. **Navigate to project root** (if needed):
   ```bash
   cd /workspace/Red-Panda-Dev__tbel
   ```

2. **Specify the module path**:
   ```bash
   src/xxx/vvv/
   ```

3. **Review generated README**:
   - Check for accuracy
   - Add any missing information
   - Customize as needed

## References

- [Module Detection Patterns](./references/detection-patterns.md)
- [README Best Practices](./references/best-practices.md)
- [Mermaid Syntax Guide](./references/mermaid-guide.md)
- [Documentation Standards](./references/standards.md)

## Integration with Development Workflow

### Pre-commit Hook
Add to `.git/hooks/pre-commit`:
```bash
#!/bin/sh
# Auto-generate README for changed modules
# Implementation depends on git diff analysis
```

### CI/CD Pipeline
Add to CI workflow:
```yaml
- name: Generate Documentation
  run: |
    # Generate README for all modules
    # Specify directory paths for each module
    find src -type d -name "*/" | while read dir; do
      echo "Processing module: $dir"
    done
```

### Manual Invocation
```bash
# Generate for specific module by specifying path
# The agent will use the skill name from the SKILL.md automatically

# Regenerate all READMEs
find . -name "README.md" -type f -delete
find . -type d | grep -v node_modules | while read dir; do
  # Specify directory path for each module
  echo "$dir"
done
```

## Customization

### Adding New Module Types
1. Create new template in `templates/`
2. Add detection logic in SKILL.md
3. Update type-specific generation rules

### Modifying Templates
1. Edit template files in `templates/`
2. Update placeholders as needed
3. Test with sample modules

### Extending Analysis
1. Add new file pattern detection
2. Implement additional extraction logic
3. Update documentation

## Troubleshooting

### Common Issues

1. **Path not found**: Verify path exists and is accessible
2. **No source files**: Ensure directory contains code files
3. **Permission denied**: Check write permissions for target directory
4. **Incorrect module type**: Add more specific detection patterns

### Debug Mode
Enable debug output for troubleshooting by setting DEBUG=1 environment variable.

This will output:
- Detected module type
- Files analyzed
- Extracted information
- Generation decisions

## Version History

- **v1.0**: Initial universal README generator
- **v1.1**: Added Cloudflare Worker specific detection
- **v1.2**: Added Node.js/TypeScript support
- **v1.3**: Added Python module support
- **v1.4**: Added frontend component support
- **v1.5**: Added command-based invocation
