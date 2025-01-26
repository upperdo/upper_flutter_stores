# Contributing to **upper_flutter_stores**

We welcome contributions to the **upper_flutter_stores** package! Whether it's bug fixes, feature suggestions, documentation improvements, or code enhancements, your input is invaluable to us. Please follow the guidelines below to make the process smooth and collaborative.

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Reporting Issues](#reporting-issues)
3. [Feature Requests](#feature-requests)
4. [Code Contributions](#code-contributions)
   - [Fork and Clone](#fork-and-clone)
   - [Branch Naming Convention](#branch-naming-convention)
   - [Code Style Guidelines](#code-style-guidelines)
   - [Submitting Pull Requests](#submitting-pull-requests)
5. [Testing Contributions](#testing-contributions)
6. [Documentation Contributions](#documentation-contributions)
7. [Community Guidelines](#community-guidelines)

---

## Getting Started

1. Familiarize yourself with the repository by reading the [README.md](https://github.com/upperdo/upper_flutter_stores/blob/master/README.md) and the [API Definition](https://github.com/upperdo/upper_flutter_stores/blob/master/docs/API_DEFINITION.md).
2. Make sure you have Flutter and Dart installed. Refer to the [Flutter Installation Guide](https://docs.flutter.dev/get-started/install).
3. Clone the repository and set it up locally:
   ```bash
   git clone https://github.com/upperdo/upper_flutter_stores.git
   cd upper_flutter_stores
   flutter pub get
   ```

---

## Reporting Issues

If you encounter a bug or an issue:

1. Check if the issue has already been reported in the [Issues section](https://github.com/upperdo/upper_flutter_stores/issues).
2. If not, create a new issue and provide:
   - A clear and descriptive title.
   - Steps to reproduce the issue.
   - Expected and actual behavior.
   - Flutter version and relevant environment details.
   - If applicable, include code snippets or screenshots to help illustrate the problem.

---

## Feature Requests

We’re open to new ideas! To request a feature:

1. Search the [Issues section](https://github.com/upperdo/upper_flutter_stores/issues) to ensure the feature hasn’t already been requested.
2. Open a new issue and tag it with `feature-request`.
3. Clearly describe:
   - The problem the feature aims to solve.
   - How it would improve the package.
   - Any alternative solutions you’ve considered.

---

## Code Contributions

### Fork and Clone

1. Fork the repository by clicking the "Fork" button on the top right of the [repository page](https://github.com/upperdo/upper_flutter_stores).
2. Clone your fork locally:
   ```bash
   git clone https://github.com/<your-username>/upper_flutter_stores.git
   cd upper_flutter_stores
   ```

### Branch Naming Convention

Follow this convention for branch names:

- **Feature**: `feature/<feature-name>` (e.g., `feature/add-middleware`)
- **Bug Fix**: `bugfix/<issue-number>` (e.g., `bugfix/42-fix-persistence`)
- **Documentation**: `docs/<section>` (e.g., `docs/update-readme`)

### Code Style Guidelines

1. Follow Dart and Flutter best practices.
2. Run `flutter analyze` to ensure your code adheres to linting standards.
3. Write descriptive commit messages:
   - Use present tense (e.g., "Add new middleware support").
   - Include the issue number if applicable (e.g., "Fix #42: Resolve persistence bug").

### Submitting Pull Requests

1. Push your branch to your fork:
   ```bash
   git push origin <branch-name>
   ```
2. Open a pull request (PR) on the original repository:
   - Provide a clear title and description.
   - Reference related issues (e.g., "Closes #42").
   - Include screenshots or GIFs for visual changes.
3. Collaborate with maintainers by addressing review comments promptly.

---

## Testing Contributions

Before submitting your PR:

1. Write tests for your code if applicable.
2. Run all tests to ensure nothing is broken:
   ```bash
   flutter test
   ```
3. Make sure all tests pass and there are no regressions.

---

## Documentation Contributions

Help improve the documentation:

1. Update or create files in the `docs` folder following the existing structure.
2. Ensure links and examples are accurate.
3. For significant documentation changes, submit a PR with a description of what you’ve updated.

---

## Community Guidelines

1. Be respectful and collaborative.
2. Use inclusive language.
3. Provide constructive feedback during code reviews.
4. Follow the [Code of Conduct](https://github.com/upperdo/upper_flutter_stores/blob/master/CODE_OF_CONDUCT.md).

Thank you for contributing to **upper_flutter_stores**! Together, we can build a powerful and intuitive state management library for Flutter developers.
