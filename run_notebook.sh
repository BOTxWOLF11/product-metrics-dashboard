#!/usr/bin/env bash
# Simple script to execute the notebook and produce outputs (requires nbconvert)
NOTEBOOK=notebook.ipynb
OUTPUT=executed_notebook.ipynb
jupyter nbconvert --to notebook --execute $NOTEBOOK --output $OUTPUT --ExecutePreprocessor.timeout=600
echo "Executed notebook saved to $OUTPUT"
