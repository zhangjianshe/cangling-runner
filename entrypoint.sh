#!/bin/bash
set -e

# Force usage of the conda environment's python for the diagnostic report
export PATH="/opt/conda/envs/myenv/bin:$PATH"

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
libs = ['osgeo', 'kafka', 'loguru', 'cangling']
friendly_names = {'osgeo': 'gdal (osgeo)', 'kafka': 'kafka', 'loguru': 'loguru', 'cangling': 'cangling'}
for lib in libs:
    try:
        mod = __import__(lib)
        version = getattr(mod, '__version__', 'Installed')
        print(f'  - {friendly_names[lib]}: {version}')
    except ImportError:
        print(f'  - {friendly_names[lib]}: NOT INSTALLED')
"
echo "=================================================="
echo ""

exec "$@"