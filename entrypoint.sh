#!/bin/bash
umask 0002
. "${DL_ANACONDA_HOME}/etc/profile.d/conda.sh"
conda activate base
exec "$@"