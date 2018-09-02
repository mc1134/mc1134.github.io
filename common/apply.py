'''
Run this python script to automatically apply template files in the common
directory to html files
'''
import sys
from pathlib import Path

def prefix(matcher):
  def collect(s):
    for i in range(1, len(s)):
      if not matcher(s[:i]):
        return s[:i-1]
  return collect

def has_comment(s):
  return '<!--' in s and '-->' in s

def replace_between(original, lines):
  '''
  Input is lists of lines
  '''
  start, end = lines[0], lines[-1]
  replacements = []
  skip = -1  # Skip lines before this line number
  for before, line in enumerate(original):
    if before < skip:
      continue
    if line == start:
      for after, line2 in enumerate(original[before:]):
        if line2 == end:
          skip = after
          replacements.append((before, after))
          break

  # Apply replacements backwards
  for before, after in reversed(replacements):
    above = original[:before]
    below = original[after+1:]
    original = above + lines + below

  return original, len(replacements)


# ==== Main Script =====

DRY_RUN = True

templates = {
  'header.html': None,
  'footer.html': None
}

# Check parsing of templates
error = False
for t in templates:
  with open(t, 'r') as f:
    contents = f.readlines()
    start, end = contents[0], contents[-1]
    if not has_comment(start):
      print('Template file "%s" is missing starting comment. Ignoring' % t)
      continue
    if not has_comment(end):
      print('Template file "%s" is missing ending comment. Ignoring' % t)
      continue
    templates[t] = contents

# Process command-line args
directory = 'C:/Users/jmich_000/Desktop/CodingProjects/mc1134.github.io'
if len(sys.argv) > 1:
  directory = sys.argv[1]
  directory.replace('/C/', 'C:/')  # windows only

# Find all files to apply to using glob
print('Searching for html files in', directory)
files = [str(path) for path in Path(directory).glob('**/*.html')]

# Check for confirmation from user
print('Applying templates:\n ', '\n  '.join(t for t, v in templates.items() if v is not None))
print('Applying to files:\n ', '\n  '.join(files))
confirm = input('Enter [y] to apply templates to files: ')

if confirm.lower() != 'y' and confirm.lower() != 'yes':
  print('Canceled')
  sys.exit(1)

# Begin applying process
for f in files:
  print('Processing', f)
  contents = None
  with open(f, 'r') as infile:
    contents = infile.readlines()
  if contents is None:
    continue
  for t, v in templates.items():
    if v is None:
      continue
    contents, count = replace_between(contents, v)
    print('Replaced', t, count, 'times')
  if DRY_RUN:
    print('Dry run complete')
    continue
  with open(f, 'w') as outfile:
    pass # outfile.write(contents)

