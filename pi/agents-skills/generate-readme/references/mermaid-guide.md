# Mermaid Syntax Guide for README Diagrams

This guide provides examples and best practices for using Mermaid diagrams in README files.

## Why Use Mermaid?

Mermaid is a JavaScript-based diagramming and charting tool that renders Markdown-inspired text definitions to create and modify diagrams dynamically. It's perfect for documentation because:

- **Text-based**: Diagrams are defined as text, making them version-controllable
- **GitHub Support**: Native support in GitHub Markdown
- **Simple Syntax**: Easy to learn and use
- **Consistent**: Same diagram across all platforms
- **Maintainable**: Update diagrams by editing text

## Basic Syntax

### Flowchart (Most Common)

```mermaid
flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Do Something]
    B -->|No| D[Do Something Else]
    C --> E[End]
    D --> E
```

**Key Elements:**
- `flowchart TD` or `flowchart LR` - Top-Down or Left-Right direction
- `A[Text]` - Node with text
- `-->` - Arrow to next node
- `-- Text -->` - Arrow with text label
- `|Text|` - Edge label syntax
- `B{Decision}` - Diamond shape for decisions
- `C(Start)` - Rounded rectangle
- `D[[Subroutine]]` - Subroutine shape
- `E((Database))` - Database shape

### Sequence Diagram

```mermaid
sequenceDiagram
    participant User
    participant API
    participant Database
    
    User->>API: GET /data
    API->>Database: Query data
    Database-->>API: Return results
    API-->>User: JSON response
```

### Class Diagram

```mermaid
classDiagram
    class Animal {
        +String name
        +eat()
        +sleep()
    }
    
    class Dog {
        +bark()
    }
    
    class Cat {
        +meow()
    }
    
    Animal <|-- Dog
    Animal <|-- Cat
```

### State Diagram

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing: Start
    Processing --> Idle: Complete
    Processing --> Error: Fail
    Error --> Idle: Retry
```

### ER Diagram

```mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : referenced_in
    
    USER {
        int id PK
        string name
        string email
    }
    
    ORDER {
        int id PK
        date created_at
        string status
    }
    
    ORDER_ITEM {
        int id PK
        int quantity
        decimal price
    }
    
    PRODUCT {
        int id PK
        string name
        decimal price
    }
```

## Cloudflare Worker Diagrams

### Queue Processing Flow

```mermaid
flowchart TD
    Q[Queue: tb-news-raw-article-saved] --> W[Worker: tb-news-ai-analyzer]
    W --> VALIDATE[Validate Message]
    VALIDATE --> FETCH[Fetch from Backend]
    FETCH --> L0[Layer 0: Cleaner]
    L0 --> L1[Layer 1: Prefilter]
    L1 --> GATE{Gate: relevance >= 0.65?}
    GATE -->|No| SAVE1[Save with layer: 1]
    GATE -->|Yes| L21[Layer 2.1: Fact Distillation]
    L21 --> L22[Layer 2.2: Event Builder]
    L22 --> MAP[Mapping & Normalization]
    MAP --> SAVE2[Backend API: POST analysis]
    SAVE2 --> Q2[Queue: tb-news-ai-analysis-completed]
```

### Service Dependencies

```mermaid
flowchart TD
    subgraph Cloudflare
        W[tb-news-ai-analyzer]
        Q1[tb-news-raw-article-saved]
        Q2[tb-news-ai-analysis-completed]
        SS[Secrets Store]
        KV[KV Namespace]
    end
    
    subgraph External
        BE[TokenBel Backend]
        AI[Mistral AI]
    end
    
    Q1 --> W
    W --> SS
    W --> KV
    W --> BE
    W --> AI
    W --> Q2
```

### Data Flow with Error Handling

```mermaid
flowchart TD
    START[Message Received] --> VALIDATE
    VALIDATE -->|Valid| PROCESS
    VALIDATE -->|Invalid| REJECT[Reject Message]
    
    PROCESS --> FETCH
    FETCH -->|Success| ANALYZE
    FETCH -->|Failure| RETRY1[Retry x3]
    
    RETRY1 -->|Success| ANALYZE
    RETRY1 -->|Fail x3| ERROR[Record Error]
    
    ANALYZE -->|Success| SAVE
    ANALYZE -->|Failure| RETRY2[Retry x3]
    
    RETRY2 -->|Success| SAVE
    RETRY2 -->|Fail x3| ERROR
    
    SAVE -->|Success| ACK[ACK Message]
    SAVE -->|Failure| RETRY3[Retry x3]
    
    RETRY3 -->|Success| ACK
    RETRY3 -->|Fail x3| ERROR
```

## Node.js/TypeScript Module Diagrams

### Module Dependencies

```mermaid
flowchart TD
    subgraph "src/utils/logger"
        L[logger.ts]
    end
    
    subgraph "src/data"
        P[processor.ts]
        V[validator.ts]
    end
    
    subgraph "src/api"
        C[client.ts]
    end
    
    P --> L
    P --> V
    P --> C
    V --> L
```

### Function Call Flow

```mermaid
flowchart TD
    A[processData] --> B[validateInput]
    B -->|Valid| C[normalizeData]
    B -->|Invalid| D[throw Error]
    C --> E[transformData]
    E --> F[return Result]
```

### Class Hierarchy

```mermaid
classDiagram
    class DataProcessor {
        +config: ProcessConfig
        +logger: Logger
        +process(data: unknown): Promise~ProcessedData~
        +validate(data: unknown): ValidationResult
        -normalize(data: unknown): unknown
    }
    
    class TextProcessor {
        +cleanText(text: string): string
        +extractKeywords(text: string): string[]
    }
    
    class JsonProcessor {
        +parseJson(json: string): unknown
        +stringify(data: unknown): string
    }
    
    DataProcessor <|-- TextProcessor
    DataProcessor <|-- JsonProcessor
```

## Python Module Diagrams

### Package Structure

```mermaid
flowchart TD
    subgraph data_processor
        __init__.py
        processor.py
        validators.py
        utils.py
    end
    
    processor.py --> validators.py
    processor.py --> utils.py
    __init__.py --> processor.py
```

### Data Processing Pipeline

```mermaid
flowchart LR
    INPUT[Raw Data] --> CLEAN[Clean]
    CLEAN --> VALIDATE[Validate]
    VALIDATE --> TRANSFORM[Transform]
    TRANSFORM --> OUTPUT[Processed Data]
```

## Frontend Component Diagrams

### Component Hierarchy

```mermaid
flowchart TD
    App --> Header
    App --> Main
    App --> Footer
    
    Main --> Sidebar
    Main --> Content
    
    Content --> Card
    Card --> CardHeader
    Card --> CardBody
    Card --> CardFooter
```

### Component Props Flow

```mermaid
flowchart TD
    Parent -->|props| Child
    Child -->|events| Parent
    Child -->|context| ContextProvider
```

### User Interaction Flow

```mermaid
flowchart TD
    U[User] --> C[Component]
    C -->|Render| UI[User Interface]
    UI -->|Click| C
    C -->|Handle Click| A[Action]
    A -->|Update State| S[State]
    S -->|Re-render| UI
```

## Complex Diagrams

### Multi-Worker System

```mermaid
flowchart TD
    subgraph Workers
        W1[tb-news-discoverer]
        W2[tb-news-fetcher]
        W3[tb-news-ai-analyzer]
        W4[tb-news-saver]
    end
    
    subgraph Queues
        Q1[tb-news-discovered]
        Q2[tb-news-raw-article-saved]
        Q3[tb-news-ai-analysis-completed]
        Q4[tb-news-saved]
    end
    
    subgraph External
        S[Sitemap]
        W[Website]
        BE[Backend]
        AI[AI Service]
    end
    
    S --> W1
    W1 --> Q1
    Q1 --> W2
    W2 --> W
    W --> Q2
    Q2 --> W3
    W3 --> AI
    W3 --> Q3
    Q3 --> W4
    W4 --> BE
    W4 --> Q4
```

### Decision Tree

```mermaid
flowchart TD
    START[Start Analysis] --> CHECK1{Has Content?}
    CHECK1 -->|No| REJECT1[Reject: Empty]
    CHECK1 -->|Yes| CHECK2{Length > 100?}
    
    CHECK2 -->|No| REJECT2[Reject: Too Short]
    CHECK2 -->|Yes| CHECK3{Valid Language?}
    
    CHECK3 -->|No| REJECT3[Reject: Wrong Language]
    CHECK3 -->|Yes| CHECK4{Relevance Score >= 0.65?}
    
    CHECK4 -->|No| SAVE1[Save: Layer 1]
    CHECK4 -->|Yes| PROCESS[Process: Layer 2]
    
    PROCESS --> CHECK5{AI Confidence >= 0.8?}
    CHECK5 -->|No| SAVE2[Save: Layer 2]
    CHECK5 -->|Yes| SAVE3[Save: Layer 3]
```

### Error Handling Flow

```mermaid
flowchart TD
    START[Start] --> TRY[Try Operation]
    TRY -->|Success| SUCCESS[Success]
    TRY -->|Error| CATCH[Catch Error]
    
    CATCH --> IS_RETRYABLE{Is Retryable?}
    IS_RETRYABLE -->|Yes| CHECK_RETRIES{Retries < 3?}
    IS_RETRYABLE -->|No| LOG[Log Error]
    
    CHECK_RETRIES -->|Yes| WAIT[Wait 1s]
    CHECK_RETRIES -->|No| LOG
    
    WAIT --> TRY
    LOG --> FAIL[Fail]
```

## Styling Diagrams

### Custom Styling

```mermaid
flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Success]
    B -->|No| D[Failure]
    
    style A fill:#f9f,stroke:#333
    style C fill:#bbf,stroke:#333,stroke-width:2px
    style D fill:#f99,stroke:#333,stroke-width:2px
```

### Class Definitions

```mermaid
flowchart TD
    classDef success fill:#9f9,stroke:#333
    classDef failure fill:#f99,stroke:#333
    classDef decision fill:#ff9,stroke:#333
    
    A[Start] --> B{Decision?}
    B -->|Yes| C[Success]
    B -->|No| D[Failure]
    
    class B decision
    class C success
    class D failure
```

### Themes

```mermaid
%%{init: {'theme': 'base', 'themeVariables': { 'primaryColor': '#ff0000'}}}%%
flowchart TD
    A --> B
```

Available themes: `base`, `forest`, `dark`, `default`, `neutral`

## Best Practices

### 1. Keep It Simple

**Good:**
```mermaid
flowchart TD
    A --> B --> C
```

**Bad:**
```mermaid
flowchart TD
    A1[Very Long Node Name That Makes The Diagram Hard To Read] --> B2[Another Very Long Node Name]
    B2 --> C3[Yet Another Extremely Long Node Name With Too Much Text]
```

### 2. Use Descriptive Node Names

**Good:**
```mermaid
flowchart TD
    Fetch[Fetch Article] --> Clean[Clean Text]
```

**Bad:**
```mermaid
flowchart TD
    A --> B
```

### 3. Limit Diagram Size

- Maximum 10-15 nodes for readability
- Break complex flows into multiple diagrams
- Use subgraphs to group related nodes

### 4. Use Consistent Direction

- Use `TD` (Top-Down) for most flows
- Use `LR` (Left-Right) for sequences
- Be consistent within a document

### 5. Add Descriptions

Always include a brief description before the diagram:

```markdown
### Data Processing Pipeline

The following diagram shows how data flows through the processing layers:

```mermaid
flowchart TD
    Input --> Layer0 --> Layer1 --> Layer2 --> Output
```
```

### 6. Test Diagrams

Always test your Mermaid diagrams:
1. View in GitHub to ensure rendering
2. Check on different devices
3. Verify all syntax is correct

## Common Mistakes

### 1. Syntax Errors

**Wrong:**
```mermaid
flowchart TD
    A -> B  # Wrong arrow syntax
```

**Correct:**
```mermaid
flowchart TD
    A --> B  # Correct arrow syntax
```

### 2. Missing Direction

**Wrong:**
```mermaid
flowchart
    A --> B  # Missing direction (TD or LR)
```

**Correct:**
```mermaid
flowchart TD
    A --> B  # With direction
```

### 3. Special Characters

**Wrong:**
```mermaid
flowchart TD
    A[Node with "quotes"] --> B
```

**Correct:**
```mermaid
flowchart TD
    A[Node with quotes] --> B
    # or
    A["Node with 'single quotes'"] --> B
```

### 4. Line Breaks in Nodes

**Wrong:**
```mermaid
flowchart TD
    A[Line 1
    Line 2] --> B  # Literal newline
```

**Correct:**
```mermaid
flowchart TD
    A["Line 1<br>Line 2"] --> B  # HTML line break
```

## Tools for Creating Mermaid Diagrams

### Online Editors
- [Mermaid Live Editor](https://mermaid.live/) - Official live editor
- [Mermaid Chart](https://www.mermaidchart.com/) - Advanced editor
- [Draw.io with Mermaid](https://app.diagrams.net/) - Import/export Mermaid

### VS Code Extensions
- [Mermaid Preview](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid) - Preview Mermaid in VS Code
- [Markdown Preview Mermaid Support](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid) - Mermaid support for markdown preview

### CLI Tools
- [mermaid-cli](https://github.com/mermaid-js/mermaid-cli) - Generate diagrams from command line
- [mmdc](https://github.com/mermaid-js/mermaid-cli/tree/master/packages/mermaid-cli) - Mermaid CLI

## Advanced Examples

### Interactive Diagram (GitHub only)

```mermaid
flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Success]
    B -->|No| D[Failure]
    click A "https://example.com/start" _blank
    click C "https://example.com/success" _blank
```

### Complex Subgraphs

```mermaid
flowchart TD
    subgraph Input
        A1[Source 1]
        A2[Source 2]
        A3[Source 3]
    end
    
    subgraph Processing
        B1[Processor 1]
        B2[Processor 2]
    end
    
    subgraph Output
        C1[Destination 1]
        C2[Destination 2]
    end
    
    A1 --> B1
    A2 --> B1
    A3 --> B2
    B1 --> C1
    B2 --> C2
```

### Custom Shapes

```mermaid
flowchart TD
    A([Start]) --> B{{Decision}}
    B -->|Yes| C[/Input/]
    B -->|No| D(\Output\)
    C --> E((Database))
    D --> F[[Subroutine]]
```

Available shapes:
- `[` `]` - Rectangle (default)
- `(` `)` - Circle
- `(` `)` - Rounded rectangle (subroutine)
- `{` `}` - Diamond (decision)
- `[/` `/]` - Hexagon
- `[[` `]]` - Subroutine
- `((` `))` - Cylinder (database)
- `>` `]` - Right arrow
- `<` `[` - Left arrow
- `<>` `>` - Double arrow

## References

- [Mermaid Official Documentation](https://mermaid.js.org/)
- [Mermaid Syntax Reference](https://mermaid.js.org/syntax/flowchart.html)
- [GitHub Mermaid Support](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams)
- [Mermaid Live Editor](https://mermaid.live/)
