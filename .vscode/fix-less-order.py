#!/usr/bin/env python3
import sys


def fix_less_file(file_path):
    """Fix property ordering in LESS file - ensures vendor prefixes are sorted correctly"""

    with open(file_path, 'r') as f:
        lines = f.readlines()

    modified = False
    in_after_block = False
    after_block_start = -1
    after_block_end = -1
    brace_count = 0

    for i, line in enumerate(lines):
        if '&::after' in line and '{' in line:
            in_after_block = True
            after_block_start = i
            brace_count = 1
        elif in_after_block:
            brace_count += line.count('{') - line.count('}')
            if brace_count == 0:
                after_block_end = i
                in_after_block = False

                # Check if this block has vendor prefixes that need sorting
                block_text = ''.join(lines[after_block_start:after_block_end+1])
                if '-moz-osx-font-smoothing:' in block_text or '-webkit-font-smoothing:' in block_text:
                    # Extract and sort properties
                    properties = []
                    indent = ''

                    for j in range(after_block_start + 1, after_block_end):
                        line_content = lines[j]
                        stripped = line_content.strip()

                        if stripped and ':' in stripped and not stripped.startswith('//'):
                            if not indent and line_content != line_content.lstrip():
                                indent = line_content[:len(line_content) - len(line_content.lstrip())]

                            # Store property with its line for sorting
                            prop_name = stripped.split(':')[0].strip()
                            properties.append((prop_name.lower(), stripped))

                    # Sort properties alphabetically (vendor prefixes with - come first)
                    properties.sort(key=lambda x: x[0])

                    # Rebuild the block with sorted properties
                    new_lines = [lines[after_block_start]]
                    for _, prop_line in properties:
                        new_lines.append(indent + prop_line + '\n')
                    new_lines.append(lines[after_block_end])

                    # Replace the block in the original lines
                    lines[after_block_start:after_block_end+1] = new_lines
                    modified = True
                    break

    # Write back only if modified
    if modified:
        with open(file_path, 'w') as f:
            f.writelines(lines)

    return modified


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: fix-less-order.py <file>")
        sys.exit(1)

    file_path = sys.argv[1]

    try:
        if fix_less_file(file_path):
            print(f"Fixed: {file_path}")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)