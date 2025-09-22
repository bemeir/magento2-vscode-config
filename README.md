# VS Code Configuration Guide for Magento 2 Project

## Overview
This guide explains how to use the VS Code integration with Captain Hook, code quality tools, and Magento 2 coding standards.

## Running Tasks in VS Code

### Method 1: Command Palette (Recommended)
1. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac)
2. Type "Tasks: Run Task"
3. Select from available tasks

### Method 2: Keyboard Shortcut
- Press `Ctrl+Shift+B` to run build tasks
- Configure custom shortcuts in VS Code keybindings

### Method 3: Terminal Menu
- Menu: Terminal → Run Task...

## Available Tasks

### Captain Hook Tasks

#### 1. **Captain Hook: Install**
- **Purpose**: Install/reinstall git hooks
- **How to run**:
  - `Ctrl+Shift+P` → "Tasks: Run Task" → "Captain Hook: Install"
- **When to use**:
  - After cloning the repository
  - If hooks aren't working properly
  - After updating Captain Hook configuration

#### 2. **Captain Hook: Run Pre-Commit**
- **Purpose**: Manually test pre-commit checks without committing
- **How to run**:
  - `Ctrl+Shift+P` → "Tasks: Run Task" → "Captain Hook: Run Pre-Commit"
- **What it checks**:
  - PHP syntax (parallel-lint)
  - PHP code standards (PHPCS)
  - PHPStan static analysis
  - Composer lock file validation
  - Composer.json normalization

#### 3. **Captain Hook: Run Commit-Msg**
- **Purpose**: Test commit message validation
- **How to run**:
  - `Ctrl+Shift+P` → "Tasks: Run Task" → "Captain Hook: Run Commit-Msg"
- **Validates**:
  - Commit message format: `CU-[id]: message`
  - Branch naming: `feature/CU-xxx-description` or `hotfix/CU-xxx-description` or `bugfix/CU-xxx-description`

#### 4. **Captain Hook: Config Info**
- **Purpose**: View current Captain Hook configuration
- **How to run**:
  - `Ctrl+Shift+P` → "Tasks: Run Task" → "Captain Hook: Config Info"

### Code Quality Tasks

#### 5. **PHPCS: Check Staged Files**
- **Purpose**: Run PHP CodeSniffer on the current file
- **How to run**:
  - Open a PHP file
  - `Ctrl+Shift+P` → "Tasks: Run Task" → "PHPCS: Check Staged Files"
- **Checks**: Magento 2 coding standards

#### 6. **PHPStan: Analyze**
- **Purpose**: Run static analysis on current PHP file
- **How to run**:
  - Open a PHP file
  - `Ctrl+Shift+P` → "Tasks: Run Task" → "PHPStan: Analyze"
- **Level**: 1 (configurable in task)

#### 7. **Parallel Lint: Check PHP Syntax**
- **Purpose**: Check PHP syntax errors in current file
- **How to run**:
  - Open a PHP file
  - `Ctrl+Shift+P` → "Tasks: Run Task" → "Parallel Lint: Check PHP Syntax"

## Git Hooks (Automatic)

### Pre-Commit Hook
Automatically runs when you `git commit`:
1. **Composer Lock Validation** - Ensures composer.lock is in sync
2. **PHP Linting** - Checks for syntax errors in staged PHP/PHTML files
3. **Composer.json Validation** - For packages in composer/packages/envalo
4. **PHPStan** - Static analysis on staged PHP files
5. **PHPCS** - Coding standards check on staged PHP/PHTML/JS/HTML files

### Commit-Msg Hook
Automatically validates commit messages:
- **Format**: Must match `CU-[alphanumeric]: message`
- **Example**: `CU-2h2h2h: Fix checkout process`
- **Branch**: Must match `feature/CU-xxx-description` pattern

## Quick Actions

### Fix PHP Coding Standards
```bash
# Fix a single file
./vendor/bin/phpcbf path/to/file.php

# Fix all staged files
./vendor/bin/phpcbf $(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(php|phtml)$')
```

### Run All Checks Manually
```bash
# From project root
cd /home/goran/sites/SVPMagento2

# Run pre-commit checks
 ./vendor/bin/phpcs -q --standard=Magento2 -s app/design/frontend/Svp
 ./vendor/bin/phpcs -q --standard=Magento2 -s composer/packages/envalo
```



## LESS/CSS Development

### Auto-formatting
- LESS/CSS files are automatically formatted on save
- Uses Stylelint with Magento 2 standards
- 4-space indentation
- Properties in alphabetical order

### Manual Stylelint Check
```bash
npx stylelint "**/*.less" --fix
```

## VS Code Extensions Required

Install these extensions for full functionality:
- **PHP Intelephense** - PHP intelligence
- **PHPCS** - PHP CodeSniffer integration
- **PHP Sniffer** - Additional PHPCS support
- **ESLint** - JavaScript linting
- **Stylelint** - LESS/CSS linting
- **GitLens** - Enhanced Git capabilities
- **EditorConfig** - Consistent coding styles

## Troubleshooting

### Captain Hook not working
1. Reinstall hooks: Run "Captain Hook: Install" task
2. Check configuration: Run "Captain Hook: Config Info" task
3. Verify git hooks exist: `ls -la .git/hooks/`

### PHPCS errors
1. Ensure Magento coding standards are installed:
   ```bash
   composer require magento/magento-coding-standard --dev
   ```
2. Fix automatically where possible:
   ```bash
   ./vendor/bin/phpcbf path/to/file.php
   ```

### Task not found
1. Ensure you're in the project root
2. Reload VS Code window: `Ctrl+Shift+P` → "Developer: Reload Window"

### Commit rejected
1. Check the error message for specific validation failure
2. For commit message issues: Use format `CU-xxx: message`
3. For code issues: Run the specific failed check manually and fix

## Best Practices

1. **Always run pre-commit checks** before committing
2. **Use the provided tasks** to validate your code
3. **Fix issues immediately** when detected
4. **Keep tools updated** with `composer update`
5. **Follow branch naming conventions**: `feature/CU-xxx-description`

## Configuration Files

- **Captain Hook**: `tools/code-quality/captainhook/config.json`
- **VS Code Settings**: `.vscode/settings.json`
- **VS Code Tasks**: `.vscode/tasks.json`
- **Stylelint**: `.stylelintrc.json`
- **Extensions**: `.vscode/extensions.json`

## Need Help?

- Review this documentation
- Check the error messages carefully
- Run tasks with verbose output for more details
- Ask your team lead for specific project conventions
