# Module Detection Patterns

This document describes the patterns used to detect and classify different module types for README generation.

## Detection Priority

The skill uses a priority-based detection system. Module types are checked in the following order:

1. **Cloudflare Worker** (highest priority)
2. **Node.js/TypeScript Module**
3. **Python Module**
4. **Frontend Component**
5. **Generic Module** (fallback)

## Detection Rules

### 1. Cloudflare Worker Detection

**Primary Indicators:**
- Presence of `wrangler.toml` file
- Presence of `src/` directory with `.ts` or `.js` files
- Presence of `package.json` with Cloudflare-related dependencies

**File Patterns:**
```
wrangler.toml          # Cloudflare Workers configuration
src/*-worker.ts        # Main worker file pattern
src/*-worker.js        # Main worker file pattern
package.json           # With dependencies like "wrangler", "@cloudflare/workers-types"
```

**Additional Indicators:**
- Queue bindings in `wrangler.toml`
- Secret store configurations
- Cloudflare-specific environment variables
- Use of Cloudflare Workers API

**Example Structure:**
```
cf_workers/{worker-name}/
├── src/
│   └── {worker-name}-worker.ts
├── wrangler.toml
├── package.json
└── tsconfig.json
```

**Confidence Scoring:**
- `wrangler.toml` exists: +50 points
- `src/*-worker.ts` exists: +30 points
- `package.json` with wrangler dependency: +20 points
- Queue bindings configured: +15 points
- Secrets configured: +10 points
- **Threshold**: 80+ points = Cloudflare Worker

### 2. Node.js/TypeScript Module Detection

**Primary Indicators:**
- Presence of `package.json` file
- Presence of `.ts` or `.js` files
- Presence of `node_modules/` directory

**File Patterns:**
```
package.json           # Node.js manifest
.ts, .js              # TypeScript/JavaScript source files
index.ts              # Common entry point
index.js              # Common entry point
tsconfig.json         # TypeScript configuration
vitest.config.ts      # Test configuration
```

**Additional Indicators:**
- TypeScript configuration files
- Test files (`.test.ts`, `.spec.ts`)
- Build configuration files (`vite.config.ts`, `webpack.config.js`)
- Node.js-specific dependencies

**Example Structure:**
```
src/{module-name}/
├── index.ts
├── types.ts
├── utils.ts
├── package.json
└── tsconfig.json
```

**Confidence Scoring:**
- `package.json` exists: +40 points
- `.ts` or `.js` files exist: +30 points
- `node_modules/` exists: +15 points
- TypeScript config exists: +10 points
- Test files exist: +5 points
- **Threshold**: 70+ points = Node.js/TypeScript Module

### 3. Python Module Detection

**Primary Indicators:**
- Presence of `requirements.txt` or `pyproject.toml`
- Presence of `.py` files
- Presence of `__init__.py` files

**File Patterns:**
```
requirements.txt      # pip dependencies
pyproject.toml        # Modern Python project configuration
setup.py              # Legacy setup script
setup.cfg             # Legacy configuration
*.py                  # Python source files
__init__.py           # Package initialization
```

**Additional Indicators:**
- Virtual environment directories (`.venv/`, `venv/`)
- Python-specific files (`.python-version`, `Pipfile`)
- Type stub files (`.pyi`)

**Example Structure:**
```
src/{module-name}/
├── __init__.py
├── module.py
├── requirements.txt
└── pyproject.toml
```

**Confidence Scoring:**
- `requirements.txt` or `pyproject.toml` exists: +40 points
- `.py` files exist: +30 points
- `__init__.py` exists: +15 points
- Virtual environment exists: +10 points
- Type stubs exist: +5 points
- **Threshold**: 70+ points = Python Module

### 4. Frontend Component Detection

**Primary Indicators:**
- Presence of `.vue`, `.svelte`, `.jsx`, or `.tsx` files
- Presence of framework-specific configuration

**File Patterns:**
```
*.vue                 # Vue single-file components
*.svelte              # Svelte components
*.jsx, *.tsx          # React components
*.css, *.scss, *.sass # Style files
```

**Framework-Specific Indicators:**

**Vue:**
- `vue.config.js`
- `vite.config.ts` with Vue plugins
- `<script setup>` syntax in files

**React:**
- `jsx` or `tsx` extensions
- React imports in files
- `create-react-app` configuration

**Svelte:**
- `.svelte` extension
- `svelte.config.js`
- Svelte-specific imports

**Example Structure:**
```
src/components/{component-name}/
├── {ComponentName}.vue
├── {ComponentName}.tsx
├── index.ts
├── styles.scss
└── __tests__/
```

**Confidence Scoring:**
- Framework component files exist: +40 points
- Framework configuration exists: +20 points
- Framework imports detected: +15 points
- Style files exist: +10 points
- Test files exist: +5 points
- **Threshold**: 70+ points = Frontend Component

### 5. Generic Module Detection (Fallback)

**Indicators:**
- Any source code files exist
- No higher-priority module type detected

**File Patterns:**
```
*.rs, *.go, *.java, *.cpp, *.c, *.h
*.rb, *.php, *.swift, *.kt
*.sh, *.bash
Any other source code extensions
```

**Example Structure:**
```
src/{module-name}/
├── *.rs (Rust)
├── *.go (Go)
├── *.java (Java)
└── etc.
```

**Confidence Scoring:**
- Source code files exist: +50 points
- No other module type detected: +50 points
- **Threshold**: 50+ points = Generic Module

## File Type Classification

### Source Code Files

| Extension | Language | Type |
|-----------|----------|------|
| `.ts` | TypeScript | Node.js/TypeScript |
| `.js` | JavaScript | Node.js/TypeScript |
| `.tsx` | TypeScript JSX | Frontend (React) |
| `.jsx` | JavaScript JSX | Frontend (React) |
| `.vue` | Vue | Frontend (Vue) |
| `.svelte` | Svelte | Frontend (Svelte) |
| `.py` | Python | Python |
| `.rs` | Rust | Generic |
| `.go` | Go | Generic |
| `.java` | Java | Generic |
| `.cpp` | C++ | Generic |
| `.c` | C | Generic |
| `.h` | C/C++ Header | Generic |
| `.rb` | Ruby | Generic |
| `.php` | PHP | Generic |
| `.swift` | Swift | Generic |
| `.kt` | Kotlin | Generic |

### Configuration Files

| File | Purpose | Module Type |
|------|---------|-------------|
| `wrangler.toml` | Cloudflare Workers | Cloudflare Worker |
| `package.json` | Node.js manifest | Node.js/TypeScript |
| `tsconfig.json` | TypeScript config | Node.js/TypeScript |
| `requirements.txt` | Python dependencies | Python |
| `pyproject.toml` | Python project config | Python |
| `setup.py` | Python setup | Python |
| `vue.config.js` | Vue configuration | Frontend (Vue) |
| `svelte.config.js` | Svelte configuration | Frontend (Svelte) |
| `vite.config.ts` | Vite configuration | Frontend/Node.js |
| `webpack.config.js` | Webpack configuration | Frontend/Node.js |

### Test Files

| Pattern | Framework | Module Type |
|---------|-----------|-------------|
| `*.test.ts` | Vitest/Jest | Node.js/TypeScript |
| `*.spec.ts` | Jest | Node.js/TypeScript |
| `*.test.js` | Jest | Node.js/TypeScript |
| `test_*.py` | pytest | Python |
| `*_test.py` | pytest | Python |
| `*.test.vue` | Vue Test Utils | Frontend (Vue) |
| `*.test.tsx` | React Testing Library | Frontend (React) |

## Detection Algorithm

```
function detectModuleType(directory):
    files = listDirectory(directory)
    
    # Calculate scores for each module type
    scores = {
        'cloudflare-worker': 0,
        'node-typescript': 0,
        'python': 0,
        'frontend': 0,
        'generic': 0
    }
    
    # Cloudflare Worker detection
    if 'wrangler.toml' in files:
        scores['cloudflare-worker'] += 50
    if any(f.endswith('-worker.ts') for f in files if f.startswith('src/')):
        scores['cloudflare-worker'] += 30
    if 'package.json' in files:
        pkg = readJson('package.json')
        if 'wrangler' in pkg.get('dependencies', {}):
            scores['cloudflare-worker'] += 20
    if 'wrangler.toml' in files:
        wrangler = readToml('wrangler.toml')
        if 'queues' in wrangler:
            scores['cloudflare-worker'] += 15
        if 'secrets_store_secrets' in wrangler:
            scores['cloudflare-worker'] += 10
    
    # Node.js/TypeScript detection
    if 'package.json' in files:
        scores['node-typescript'] += 40
    ts_js_files = [f for f in files if f.endswith(('.ts', '.js'))]
    if ts_js_files:
        scores['node-typescript'] += 30
    if 'node_modules/' in files:
        scores['node-typescript'] += 15
    if 'tsconfig.json' in files:
        scores['node-typescript'] += 10
    test_files = [f for f in files if '.test.' in f or '.spec.' in f]
    if test_files:
        scores['node-typescript'] += 5
    
    # Python detection
    if 'requirements.txt' in files or 'pyproject.toml' in files:
        scores['python'] += 40
    py_files = [f for f in files if f.endswith('.py')]
    if py_files:
        scores['python'] += 30
    if '__init__.py' in files:
        scores['python'] += 15
    if '.venv/' in files or 'venv/' in files:
        scores['python'] += 10
    pyi_files = [f for f in files if f.endswith('.pyi')]
    if pyi_files:
        scores['python'] += 5
    
    # Frontend detection
    frontend_files = [f for f in files if f.endswith(('.vue', '.svelte', '.tsx', '.jsx'))]
    if frontend_files:
        scores['frontend'] += 40
    if 'vue.config.js' in files:
        scores['frontend'] += 20
    if 'svelte.config.js' in files:
        scores['frontend'] += 20
    if any(f for f in files if f.endswith(('.css', '.scss', '.sass'))):
        scores['frontend'] += 10
    frontend_test_files = [f for f in files if '.test.' in f and f.endswith(('.vue', '.tsx', '.jsx'))]
    if frontend_test_files:
        scores['frontend'] += 5
    
    # Generic fallback
    source_files = [f for f in files if any(f.endswith(ext) for ext in 
        ['.rs', '.go', '.java', '.cpp', '.c', '.h', '.rb', '.php', '.swift', '.kt', '.sh'])]
    if source_files:
        scores['generic'] += 50
    
    # Determine winner
    max_score = max(scores.values())
    if max_score == 0:
        return 'unknown'
    
    winners = [k for k, v in scores.items() if v == max_score]
    if len(winners) > 1:
        # Tie-breaker: prefer more specific types
        priority = ['cloudflare-worker', 'frontend', 'node-typescript', 'python', 'generic']
        for winner in priority:
            if winner in winners:
                return winner
    
    return winners[0]
```

## Edge Cases

### Mixed Module Types

When a directory contains files from multiple module types:

1. **Cloudflare Worker with Node.js**: Cloudflare Worker takes priority
2. **Node.js with Frontend**: Node.js takes priority (frontend files often in Node.js projects)
3. **Python with Generic**: Python takes priority

### Nested Modules

For nested module detection:
- Analyze the target directory first
- If unclear, analyze parent directories for context
- Use file patterns to determine the most specific module type

### Empty Directories

If a directory contains no source files:
- Return error: "No source files found in directory"
- Suggest checking the path or adding source files

### Configuration-Only Directories

If a directory contains only configuration files:
- Attempt to detect module type from configuration
- If still unclear, return error: "No source code detected"

## Custom Detection Rules

To add custom detection rules for project-specific patterns:

1. **Add to SKILL.md**: Update detection logic in the main skill file
2. **Create custom patterns**: Add project-specific file patterns
3. **Adjust scoring**: Modify confidence scores for better accuracy
4. **Test detection**: Verify with sample modules

## Testing Detection

To test the detection algorithm, specify the directory path for different module types:

- Cloudflare Worker: `cf_workers/tb-news-ai-analyzer`
- Node.js module: `src/utils/logger`
- Python module: `src/data/processors`
- Frontend component: `src/components/Button`

## Debugging Detection

To debug detection issues, set the DEBUG=1 environment variable.

This will output:
- Detected files in the directory
- Scores for each module type
- Final detection decision
- Reasoning for the decision
