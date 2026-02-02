# React / Frontend Development Rules

## Component Structure

```typescript
// Use functional components with hooks
import { useState, useEffect } from 'react';

interface Props {
  title: string;
  onSave: (value: string) => void;
}

export function Component({ title, onSave }: Props) {
  const [value, setValue] = useState('');

  // Handle side effects with proper dependencies
  useEffect(() => {
    // Cleanup function
    return () => {};
  }, [value]);

  return (
    <div className="container">
      <h1>{title}</h1>
    </div>
  );
}
```

## Best Practices

1. **TypeScript First**: Always define interfaces for props
2. **Component Naming**: PascalCase for components, camelCase for utilities
3. **File Organization**:
   ```
   src/
   ├── components/
   │   ├── ui/          # Reusable UI components
   │   └── features/    # Feature-specific components
   ├── hooks/           # Custom hooks
   ├── lib/             # Utilities
   └── types/           # TypeScript types
   ```

4. **Avoid**: Class components, `any` type, prop drilling

## State Management

```typescript
// Use React Query for server state
import { useQuery } from '@tanstack/react-query';

function UserProfile({ userId }: { userId: string }) {
  const { data, isLoading } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetchUser(userId),
  });
}

// Use Zustand for client state
import { create } from 'zustand';

interface Store {
  count: number;
  increment: () => void;
}

const useStore = create<Store>((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 })),
}));
```

## Styling

- Prefer **Tailwind CSS** for utility-first styling
- Use CSS Modules for component-specific styles
- Avoid inline styles except for dynamic values

## Performance

```typescript
// Memoize expensive computations
import { useMemo, useCallback } from 'react';

const ExpensiveList = ({ items }: { items: Item[] }) => {
  const sorted = useMemo(() => {
    return items.sort((a, b) => a.id - b.id);
  }, [items]);

  const handleClick = useCallback((id: number) => {
    // Handle click
  }, []);
};
```

## Form Handling

```typescript
// Use react-hook-form for forms
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});

function LoginForm() {
  const { register, handleSubmit } = useForm({
    resolver: zodResolver(schema),
  });
}
```
