# Patterns

## Style override

```scss
// CORRECT: minimal override using existing globals + CSS variables
h1 {
    font-weight: 700 !important;      // only override what differs from global.scss
    color: var(--existing-css-var);   // use theme system variables
    // let global.scss handle font-size, line-height, responsive breakpoints
}

// WRONG: complete redefinition ignoring globals
h1 {
    font-size: 24px;  // duplicates global.scss definition
    font-weight: 700;
    line-height: 28px;  // breaks responsive design patterns
}
```

## NgRx routing and navigation flow

Navigation always goes through the NgRx store, never directly via `router.navigate()`.

Forward navigation:
1. User clicks a button in the component
2. Component dispatches `selectAction({ objectId })`, state is updated
3. Component dispatches `navigateToPage()`, no direct `router.navigate()`
4. Effect listens for the action and calls `router.navigate()`
5. Next page renders from state

Back navigation:
1. User clicks `goBack()`
2. Component dispatches `navigateBack()`
3. Effect navigates back

## Anti-patterns

- Creating new CSS custom properties instead of using existing ones
- Redefining styles that already exist in `global.scss`
- Ignoring the global responsive breakpoints
- Hardcoded colors instead of theme CSS variables
- Not checking the existing component architecture patterns
