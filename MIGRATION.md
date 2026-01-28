# Zensical Migration Notes

## Why Migrate?

MkDocs with Material theme has served well, but as of November 6th 2025 has entered "Maintenance Mode" meaning it is actively becoming an unsupported project. The Material for MkDocs team has since created [Zensical](https://zensical.org/). Rather than a theme built on MkDocs, Zensical is a full static site generator built from the ground up in Rust. It offers better performance and a more modern architecture with built-in features we previously had to add via plugins, including a faster native search engine, all with native support for existing Material theme features.

As of this PR, Zensical comes with everything OrcaSlicer's wiki needs out of the box, so we can remove dependencies, delete custom build scripts, and fully migrate to a more future-proof platform.

## What Changed

### Build Commands

- **Before**: `mkdocs build` / `mkdocs serve`
- **After**: `zensical build` / `zensical serve`

### Dependencies

- **Removed**: `mkdocs`, `mkdocs-material`, `mkdocs-github-admonitions-plugin`
- **Added**: `zensical` (includes Material theme, search, and all core features)

### Directory Structure

- **Source**: `docs/` (permanent source directory with all markdown content)
- **Output**: `html/` (build output, gitignored)
- **Deleted**: `build.ps1`, `build.sh` (no longer needed)

### Files Removed

- `build.ps1` - Zensical handles everything natively
- `build.sh` - Zensical handles everything natively  

## Deployment

### GitHub Actions Workflow

The workflow at `.github/workflows/pages.yml` now uses Zensical directly:

```yaml
- name: Install Zensical
  run: pip install zensical

- name: Build documentation
  run: zensical build
```

Output goes to `html/` which is uploaded as the Pages artifact.

## Benefits of Zensical

1. **Simpler Setup**: No build scripts needed, just `zensical build`
2. **Performance**: Built in Rust, faster build times
3. **Native Features**: Search, admonitions, etc. work out of the box
4. **Active Development**: Backed by Material for MkDocs team
5. **Compatibility**: Full feature parity with Material for MkDocs

## For Contributors

### Building Locally

```powershell
# Install (first time only)
pip install zensical

# Development server with live reload
zensical serve

# Production build
zensical build
```

## References

- [Zensical Documentation](https://zensical.org/docs/)
- [Zensical GitHub Repository](https://github.com/zensical/zensical)