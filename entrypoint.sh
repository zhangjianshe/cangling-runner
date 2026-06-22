#!/bin/bash
set -e

echo "=================================================="
echo "          CONTAINER STARTUP ENVIRONMENT           "
echo "=================================================="
echo "Python version:"
python --version 2>&1
echo "--------------------------------------------------"
echo "GDAL CLI version:"
gdalinfo --version 2>&1
echo "--------------------------------------------------"
echo "Installed Python Packages:"
python -c "
libs = ['gdal', 'kafka', 'loguru', 'cangling_ai']
for lib in libs:
    try:
        mod = __import__(lib)
        # Handle cases where __version__ might be missing or structured differently
        version = getattr(mod, '__version__', 'Installed (Version hidden/unknown)')
        print(f'  - {lib}: {version}')
    except ImportError:
        print(f'  - {lib}: NOT INSTALLED')
"
echo "=================================================="
echo ""

# Execute the CMD passed from the Dockerfile (e.g., /bin/bash)
exec "$@"