# Contributing to Delineate Hackathon Challenge

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## 🚀 Quick Start

1. **Fork the repository**
2. **Clone your fork**:

   ```bash
   git clone https://github.com/YOUR_USERNAME/cuet-micro-ops-hackthon-2025.git
   cd cuet-micro-ops-hackthon-2025
   ```

3. **Install dependencies**:

   ```bash
   npm install
   ```

4. **Create a branch**:

   ```bash
   git checkout -b feature/your-feature-name
   ```

5. **Make your changes**

6. **Run local CI checks**:

   ```bash
   ./scripts/check-ci-local.sh
   ```

7. **Commit and push**:

   ```bash
   git add .
   git commit -m "feat: your feature description"
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request**

---

## 📋 Development Workflow

### Before You Start

- Check existing issues and PRs to avoid duplicate work
- Discuss major changes in an issue first
- Make sure you have Node.js 24+ installed

### Local Development

```bash
# Start development server
npm run dev

# Start with Docker
npm run docker:dev

# Run tests
npm run test:e2e

# Lint code
npm run lint

# Format code
npm run format
```

### Testing Your Changes

Before pushing, **always** run the local CI check:

```bash
./scripts/check-ci-local.sh
```

This runs:

- ✅ ESLint
- ✅ Prettier format check
- ✅ E2E tests

---

## 📝 Commit Message Convention

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring without changing functionality
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependency updates
- `ci`: CI/CD pipeline changes

### Examples

```bash
# Simple feature
git commit -m "feat: add webhook notification support"

# Bug fix with scope
git commit -m "fix(api): handle timeout errors gracefully"

# Breaking change
git commit -m "feat!: redesign API response format

BREAKING CHANGE: Response format changed from {...} to {data: {...}}"

# Documentation
git commit -m "docs: update README with deployment instructions"
```

---

## 🔍 Code Quality Standards

### Linting Rules

- We use ESLint with @hono/eslint-config
- Run `npm run lint` to check
- Run `npm run lint:fix` to auto-fix

### Formatting

- We use Prettier for consistent formatting
- Run `npm run format:check` to check
- Run `npm run format` to auto-format

### Code Style

- Use TypeScript types properly
- Avoid `any` types
- Write descriptive variable names
- Add comments for complex logic
- Keep functions small and focused

---

## 🧪 Testing Guidelines

### Writing Tests

When adding new features:

1. Add E2E tests in `scripts/e2e-test.ts`
2. Test both success and failure cases
3. Validate error messages
4. Check edge cases

### Running Tests

```bash
# Run all E2E tests
npm run test:e2e

# Run with specific NODE_ENV
NODE_ENV=development npm run test:e2e

# Run tests in Docker
npm run docker:dev
docker exec -it delineate-app npm run test:e2e
```

---

## 🔐 Security Guidelines

### Do's ✅

- Use Zod for input validation
- Sanitize user input
- Use environment variables for secrets
- Follow OWASP guidelines
- Review security scan results in CI

### Don'ts ❌

- Never commit secrets or API keys
- Don't expose sensitive data in logs
- Avoid SQL injection risks
- Don't skip security headers

### Reporting Security Issues

If you discover a security vulnerability:

1. **DO NOT** create a public issue
2. Email the maintainers privately
3. Include detailed description and reproduction steps
4. Wait for confirmation before public disclosure

---

## 📦 Pull Request Process

### Before Submitting

- [ ] Run `./scripts/check-ci-local.sh` successfully
- [ ] Update documentation if needed
- [ ] Add tests for new features
- [ ] Ensure all CI checks pass
- [ ] Write clear commit messages

### PR Description Template

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing

How was this tested?

## Screenshots (if applicable)

Add screenshots for UI changes

## Checklist

- [ ] Code follows project style
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] CI checks pass
```

### Review Process

1. Maintainer reviews your PR
2. Address any requested changes
3. Once approved, PR will be merged
4. Your changes deploy automatically (if on main branch)

---

## 🎯 Issue Guidelines

### Creating Issues

Use the appropriate template:

**Bug Report**:

```markdown
**Describe the bug**
Clear description

**To Reproduce**
Steps to reproduce

**Expected behavior**
What should happen

**Screenshots**
If applicable

**Environment**

- OS:
- Node version:
- Docker version:
```

**Feature Request**:

```markdown
**Problem**
What problem does this solve?

**Proposed Solution**
How should it work?

**Alternatives**
Other options considered

**Additional Context**
Any other info
```

### Issue Labels

- `bug` - Something isn't working
- `enhancement` - New feature request
- `documentation` - Docs improvements
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `priority: high` - Urgent issue
- `security` - Security-related

---

## 🌟 Recognition

Contributors will be:

- Listed in the README Contributors section
- Acknowledged in release notes
- Given credit in project documentation

Thank you for contributing! 🎉

---

## 📚 Additional Resources

- [Project README](../README.md)
- [CI/CD Documentation](../docs/CI-CD.md)
- [Architecture Design](../ARCHITECTURE.md)
- [GitHub Actions Docs](https://docs.github.com/en/actions)

---

## 💬 Getting Help

- **Questions**: Open a discussion on GitHub
- **Bugs**: Create an issue with bug template
- **Features**: Create an issue with feature request template
- **Chat**: Join our Discord/Slack (if available)

---

_Last updated: 2025-12-12_
