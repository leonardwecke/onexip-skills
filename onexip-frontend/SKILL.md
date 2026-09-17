---
name: onexip-frontend
description: Workflow and style rules for onexip Angular/Ionic/NgRx frontends built from Figma designs. Use in any repo with angular.json, or when the user asks to implement a component or page from Figma, align styles with global/theme CSS variables, or fix missing colors/fonts against a Figma design.
---

# onexip Frontend

Implement Figma designs in Angular/Ionic/NgRx apps with the smallest possible change on top of the existing theme system. Figma defines the design; `global.scss` and the theme variables define how it is expressed.

## 1. Prerequisites

- If a component-network analysis for the target feature exists, the user provides its path. Read it first.
- If none exists, create one before changing code: every component, asset, HTML and CSS file involved; the links between components, services and styling; every code location a complex change touches. Save it as Markdown under `./docs/analysis/`.

## 2. Analysis (run the parts in parallel)

**Figma** (priority 1)
- Extract the node id from the Figma URL when given.
- Use the Figma MCP tools: `get_code`, `get_image`, `get_variable_defs`.
- Pin down the exact design tokens: colors, fonts, spacing, typography.

**Existing architecture** (priority 1)
- Read the component SCSS.
- Read `global.scss` for the styles already defined.
- Grep the theme files for CSS custom properties (`src/theme/**/*.scss`).
- Map the Figma tokens onto existing CSS variables.

**Minimal override strategy** (priority 2)
- What is global, what genuinely needs an override?
- Use existing custom properties from the theme system; create no new ones.
- Override only the properties that differ from the global definition.
- Keep responsive breakpoints and the existing architecture patterns.

See [patterns.md](patterns.md) for the override example, the NgRx navigation flow and the anti-pattern list.

## 3. Implementation plan

- Concrete todo list, split into theme updates, component changes, asset migration.
- Validate against the existing architecture patterns.
- Make the changes yourself, then explain each one (what, how, why) so the user could present it as their own. The explanation has high priority.

Success probability, state it up front:
- High (90%+): color/font variables, direct asset copies, simple styling
- Medium (70-89%): component SCSS updates, small structural changes
- Low (50-69%): complex component logic, new components
- Critical (<50%): breaking architectural changes, dependency conflicts

## 4. Rules while implementing

- Figma MCP is the source of truth for design tokens.
- Colors go through CSS custom properties with consistent naming; no hardcoded colors.
- Keep existing functionality intact during a styling update.
- Smallest change, simplest solution. No refactoring unless a ticket or review asks for it.
- Navigation always runs through the NgRx store, never `router.navigate()` in a component (flow in [patterns.md](patterns.md)).
- When icons inside buttons change, tell the user they must go through the `app-icon` component (SVGs generated from assets), not hardcoded SVG.
- Text goes in `p`, not `span`; then check `margin-top: 0`.

## 5. Debugging component and template problems

Draw the tree before theorising: where is the `@if`, where are the directives, does X sit directly under Y or is there a level in between? Check level by level. Check the simple causes first (element in the wrong place, missing import) before proposing `setTimeout`, event listeners or other workarounds. A one-line fix beats a fifty-line workaround.

## 6. Final validation

- Visual comparison with the Figma design.
- Functionality check and minimum-change check: nothing changed that does not directly fix the problem.
- Responsive design check.
