FROM apache/superset:3.0.1
# Switching to root to install the required packages
USER root

RUN pip install pydoris
# Switching back to using the `superset` user
USER superset
