#!/usr/bin/env python3
"""Helper script to setup plan - replicates setup-plan.ps1 functionality"""
import os
import json
import subprocess
import sys
from pathlib import Path

def get_repo_root():
    """Get repository root"""
    # Check for .specify directory
    current = Path.cwd().resolve()
    while current != current.parent:
        if (current / ".specify").exists():
            return str(current)
        current = current.parent
    
    # Fallback to git
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except:
        return str(Path.cwd())

def get_current_branch():
    """Get current git branch"""
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except:
        # Check for latest feature directory in specs/
        repo_root = get_repo_root()
        specs_dir = Path(repo_root) / "specs"
        if specs_dir.exists():
            # Find latest timestamp-based or numeric branch
            latest = None
            for d in specs_dir.iterdir():
                if d.is_dir():
                    latest = d.name
                    break
            if latest:
                return latest
        return "main"

def has_git():
    """Check if this is a git repository"""
    repo_root = get_repo_root()
    git_path = Path(repo_root) / ".git"
    if not git_path.exists():
        return False
    try:
        subprocess.run(
            ["git", "-C", repo_root, "rev-parse", "--is-inside-work-tree"],
            capture_output=True,
            check=True
        )
        return True
    except:
        return False

def test_feature_branch(branch, has_git_repo):
    """Check if we're on a proper feature branch"""
    if not has_git_repo:
        print("Warning: Git repository not detected; skipped branch validation", file=sys.stderr)
        return True
    
    import re
    if not re.match(r'^[0-9]{3}-', branch) and not re.match(r'^\d{8}-\d{6}-', branch):
        print(f"ERROR: Not on a feature branch. Current branch: {branch}", file=sys.stderr)
        print("Feature branches should be named like: 001-feature-name or 20260319-143022-feature-name", file=sys.stderr)
        return False
    return True

def resolve_template(template_name, repo_root):
    """Resolve template path"""
    base = Path(repo_root) / ".specify" / "templates"
    
    # Priority 1: Project overrides
    override = base / "overrides" / f"{template_name}.md"
    if override.exists():
        return str(override)
    
    # Priority 2: Installed presets
    presets_dir = Path(repo_root) / ".specify" / "presets"
    if presets_dir.exists():
        for preset in sorted(presets_dir.iterdir()):
            if preset.is_dir() and not preset.name.startswith('.'):
                candidate = preset / "templates" / f"{template_name}.md"
                if candidate.exists():
                    return str(candidate)
    
    # Priority 3: Extension templates
    ext_dir = Path(repo_root) / ".specify" / "extensions"
    if ext_dir.exists():
        for ext in sorted(ext_dir.iterdir()):
            if ext.is_dir() and not ext.name.startswith('.'):
                candidate = ext / "templates" / f"{template_name}.md"
                if candidate.exists():
                    return str(candidate)
    
    # Priority 4: Core templates
    core = base / f"{template_name}.md"
    if core.exists():
        return str(core)
    
    return None

def main():
    output_json = "--json" in sys.argv or "-Json" in sys.argv
    
    repo_root = get_repo_root()
    current_branch = get_current_branch()
    has_git_repo = has_git()
    
    # Check feature branch
    if not test_feature_branch(current_branch, has_git_repo):
        sys.exit(1)
    
    feature_dir = Path(repo_root) / "specs" / current_branch
    feature_dir.mkdir(parents=True, exist_ok=True)
    
    # Copy plan template
    template = resolve_template("plan-template", repo_root)
    impl_plan = feature_dir / "plan.md"
    
    if template and Path(template).exists():
        import shutil
        shutil.copy(template, impl_plan)
        if not output_json:
            print(f"Copied plan template to {impl_plan}")
    else:
        if not output_json:
            print("Warning: Plan template not found", file=sys.stderr)
        impl_plan.touch()
    
    paths = {
        "FEATURE_SPEC": str(feature_dir / "spec.md"),
        "IMPL_PLAN": str(impl_plan),
        "SPECS_DIR": str(feature_dir),
        "BRANCH": current_branch,
        "HAS_GIT": has_git_repo
    }
    
    if output_json:
        print(json.dumps(paths))
    else:
        for key, value in paths.items():
            print(f"{key}: {value}")

if __name__ == "__main__":
    main()
