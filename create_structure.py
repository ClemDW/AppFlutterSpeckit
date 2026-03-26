import os
import shutil
from pathlib import Path

# Define paths
repo_root = Path(r"C:\Users\cleme\Documents\AppFlutter")
feature_dir = repo_root / "specs" / "001-offline-object-detection"
template_path = repo_root / ".specify" / "templates" / "plan-template.md"
plan_path = feature_dir / "plan.md"

# Create feature directory
feature_dir.mkdir(parents=True, exist_ok=True)
print(f"Created directory: {feature_dir}")

# Copy plan template
if template_path.exists():
    shutil.copy(template_path, plan_path)
    print(f"Copied plan template to: {plan_path}")
else:
    print(f"Warning: Template not found at {template_path}")
    plan_path.touch()

# Output paths
print("\nPaths:")
print(f"FEATURE_SPEC: {feature_dir / 'spec.md'}")
print(f"IMPL_PLAN: {plan_path}")
print(f"SPECS_DIR: {feature_dir}")
print(f"HAS_GIT: {(repo_root / '.git').exists()}")
